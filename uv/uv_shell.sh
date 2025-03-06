#!/bin/bash

# from https://mil.ad/blog/2024/uv-poetry-install.html

va () {
    source .venv/bin/activate 2>/dev/null || source ../.venv/bin/activate 2>/dev/null || echo 'no .env found in this or parent directory' && false
}

va! () { 
    va || vc && va
}

vc () {
    uv venv --seed --python-preference managed "$@"
}

vd () { deactivate; }

uv_poetry_install () {
    uv pip install --no-deps -r <(POETRY_WARNINGS_EXPORT=false poetry export --without-hashes --with dev -f requirements.txt)
    poetry install --only-root
}
