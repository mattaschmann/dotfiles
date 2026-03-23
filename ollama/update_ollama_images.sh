#!/bin/bash
echo "Updating Ollama images"
ollama pull qwen3-coder:30b

echo "Re-running Modelfiles"
$HOME/.dotfiles/ollama/gen_qwen3_coder_model.sh $HOME/.dotfiles/ollama/qwen3-coder.Modelfile
