#!/bin/bash

# Get model list
models=$(ollama list | awk 'NR>1 {print $1}')
if [ -z "$models" ]; then
    echo "No Ollama models found."
    exit 1
fi

# Use fzf to select a model
model=$(echo "$models" | fzf --prompt="Select a model: ")
if [ -z "$model" ]; then
    echo "No model selected."
    exit 1
fi

echo "Starting chat with model: $model"

ollama run "$model" 
