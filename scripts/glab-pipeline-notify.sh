#!/usr/bin/env bash
set -euo pipefail

INTERVAL=30
TIMEOUT=3600

usage() {
  cat <<EOF
Usage: $(basename "$0") PIPELINE TOPIC [OPTIONS]

Wait for a GitLab pipeline to finish, then send a ntfy notification.

Arguments:
  PIPELINE   Pipeline ID or full pipeline URL
  TOPIC      ntfy topic to publish to

Options:
  -R, --repo REPO       Project path (GROUP/PROJECT). Inferred from URL or git remote if omitted.
  --interval SECONDS    Poll interval (default: 30)
  --timeout SECONDS     Max wait time (default: 3600)
  -h, --help            Show this help
EOF
  exit "${1:-0}"
}

die() { printf '%s\n' "$1" >&2; exit "${2:-1}"; }

for cmd in glab jq ntfy; do
  command -v "$cmd" >/dev/null || die "Required command not found: $cmd"
done

PIPELINE=""
TOPIC=""
REPO=""
POSITIONAL=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage 0 ;;
    -R|--repo) REPO="$2"; shift 2 ;;
    --interval) INTERVAL="$2"; shift 2 ;;
    --timeout) TIMEOUT="$2"; shift 2 ;;
    -*) die "Unknown option: $1" ;;
    *) POSITIONAL+=("$1"); shift ;;
  esac
done

[[ ${#POSITIONAL[@]} -ge 2 ]] || usage 1
PIPELINE="${POSITIONAL[0]}"
TOPIC="${POSITIONAL[1]}"

if [[ "$PIPELINE" == http* ]]; then
  if [[ -z "$REPO" ]]; then
    REPO=$(echo "$PIPELINE" | sed -E 's|^[a-z]+://[^/]+/||; s|/-/pipelines/[0-9]+/?$||; s|\.git$||')
  fi
  PIPELINE=$(echo "$PIPELINE" | grep -oE '[0-9]+$')
fi

if [[ -z "$REPO" ]]; then
  remote_url=$(git remote get-url origin 2>/dev/null) || die "Not in a git repo and no -R/--repo given"
  REPO=$(echo "$remote_url" | sed -E 's|^[a-z]+://[^/]+/||; s|^[^@]+@[^:]+:||; s|\.git$||')
fi

ENCODED_REPO=$(printf '%s' "$REPO" | jq -sRr @uri)
PIPELINE_URL=""

elapsed=0
final_status=""

while true; do
  if ! response=$(glab api "projects/${ENCODED_REPO}/pipelines/${PIPELINE}" 2>&1); then
    die "API call failed for project '${REPO}' pipeline #${PIPELINE}:\n${response}"
  fi
  if ! echo "$response" | jq empty 2>/dev/null; then
    die "API returned non-JSON for project '${REPO}' pipeline #${PIPELINE}:\n${response:0:200}"
  fi
  current_status=$(echo "$response" | jq -r '.status')

  if [[ -z "$PIPELINE_URL" ]]; then
    PIPELINE_URL=$(echo "$response" | jq -r '.web_url')
  fi

  case "$current_status" in
    success|failed|canceled|skipped|manual)
      final_status="$current_status"
      break
      ;;
  esac

  elapsed=$((elapsed + INTERVAL))
  if [[ $elapsed -ge $TIMEOUT ]]; then
    die "Timeout after ${TIMEOUT}s. Pipeline still: $current_status"
  fi

  sleep "$INTERVAL"
done

msg="Pipeline #${PIPELINE}: ${final_status}"
priority="high"
tags="white_check_mark"

if [[ "$final_status" == "failed" ]]; then
  priority="max"
  tags="rotating_light"
  jobs_response=$(glab api "projects/${ENCODED_REPO}/pipelines/${PIPELINE}/jobs" --paginate 2>/dev/null) || true
  failed_jobs=""
  if [[ -n "$jobs_response" ]] && echo "$jobs_response" | jq empty 2>/dev/null; then
    failed_jobs=$(echo "$jobs_response" | jq -r '[.[] | select(.status == "failed") | .name] | join(", ")') || true
  fi
  if [[ -n "$failed_jobs" ]]; then
    msg="${msg}\nFailed: ${failed_jobs}"
  fi
elif [[ "$final_status" == "canceled" ]]; then
  priority="low"
  tags="no_entry_sign"
fi

ntfy_args=(publish --title "glab" --priority "$priority" --tags "$tags")
if [[ -n "$PIPELINE_URL" ]]; then
  ntfy_args+=(--click "$PIPELINE_URL")
fi
ntfy_args+=("$TOPIC" "$msg")

ntfy "${ntfy_args[@]}"

if [[ "$final_status" == "success" || "$final_status" == "manual" ]]; then
  exit 0
else
  exit 1
fi
