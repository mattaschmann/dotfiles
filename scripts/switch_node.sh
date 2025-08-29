#!/bin/bash

# # Save list of global packages from current Node version
npm list -g --depth=0 --json \
  | jq -r '.dependencies | keys | .[]' > /tmp/global-npm-packages.txt

## Install new Node version with fnm
NEW_NODE_VERSION=22   # change this to whatever version you want
fnm install $NEW_NODE_VERSION
fnm use $NEW_NODE_VERSION

# # Reinstall global packages into new version
xargs npm install -g < /tmp/global-npm-packages.txt

