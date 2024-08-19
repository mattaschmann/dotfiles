#!/bin/bash

if ! command -v brew &> /dev/null
then
	echo "brew not found"
	echo "see: https://brew.sh/"
	exit 1
else
	brew bundle
fi
