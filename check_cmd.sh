#!/bin/bash

CHECK_CMD=$1
LINK=$2

YELLOW="\e[93m"
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

if command -v $CHECK_CMD &> /dev/null; then
  printf "${GREEN}$1${ENDCOLOR} already installed\n"
else
  printf "${RED}$CHECK_CMD${ENDCOLOR} not found, see: ${YELLOW}$LINK${ENDCOLOR}\n"
  exit 1
fi
