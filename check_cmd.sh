#!/bin/bash

CHECK_CMD=$1
LINK=$2

YELLOW="\e[93m"
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

if ! [ -x "$(command -v git)" ]
then
  printf "${RED}$1${ENDCOLOR} not found, see: ${YELLOW}$2${ENDCOLOR}\n"
  exit 1
else
  printf "${GREEN}$1${ENDCOLOR} already installed\n"
fi
