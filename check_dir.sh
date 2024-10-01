#!/bin/bash

CHECK_DIR=$1
LINK=$2

YELLOW="\e[93m"
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

if test -d $CHECK_DIR; then
  printf "${GREEN}$1${ENDCOLOR} found\n"
else
  printf "${RED}$CHECK_DIR${ENDCOLOR} not found, see: ${YELLOW}$LINK${ENDCOLOR}\n"
  exit 1
fi
