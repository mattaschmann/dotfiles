#!/bin/bash

# This file is used to generate the .zsh_plugins.sh file we use to load
# our antibody plugins

antibody bundle < .zsh_plugins.txt > .zsh_plugins.sh
