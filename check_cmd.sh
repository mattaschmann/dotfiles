#!/bin/bash

CHECK_CMD=$1
LINK=$2

YELLOW="\e[93m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

if ! command -v $1 &> /dev/null
then
  printf "${GREEN}$1${ENDCOLOR} not found, see: ${YELLOW}$2${ENDCOLOR}\n"
  exit 1
else
  printf "${GREEN}$1${ENDCOLOR} already installed\n"
fi
