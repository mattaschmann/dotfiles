#!/bin/bash
# This script creates an Ollama model named "qwen3-coder-optimized" 
# using the Modelfile located in the current directory.
# It automates the process of building and registering this AI model
# for code generation tasks within the Ollama environment.

ollama create qwen3-coder-optimized -f qwen3-coder.Modelfile
