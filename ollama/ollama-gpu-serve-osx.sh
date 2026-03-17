#!/bin/bash

# OLLAMA Apple Silicon M2 GPU Server Startup Script
# This script sets environment variables to maximize Apple Silicon GPU usage

echo "Starting OLLAMA with Apple Silicon M2 GPU optimizations..."

# Apple Silicon GPU Configuration
export OLLAMA_NUM_PARALLEL=4                   # Number of parallel requests to handle
export OLLAMA_MAX_LOADED_MODELS=1              # Max models to keep in memory
export OLLAMA_GPU_LAYERS=999                   # Load all layers to GPU (Metal)

# Metal Performance Shaders Settings
export GGML_METAL=1                            # Enable Metal acceleration
export GGML_METAL_NSEC=1                       # Use Metal for all operations
export OLLAMA_FLASH_ATTENTION=1                # Enable Flash Attention for better performance

# Memory Management for Apple Silicon
export OLLAMA_MEMORY_LIMIT=0                   # No memory limit (use all available)
export OLLAMA_KEEP_ALIVE=30m                   # Keep models loaded for 30 minutes
export OLLAMA_RUNNERS_DIR="/tmp/ollama-runners" # Faster storage for runner files

# Performance Tuning
export OLLAMA_NUM_THREAD=10                    # Use 10 threads (8 performance + 2 efficiency cores)
export OLLAMA_HOST=0.0.0.0                     # Listen on all interfaces

# Apple Silicon Specific Optimizations
export METAL_DEVICE_ID=0                       # Use the integrated GPU
export METAL_DEBUG=0                           # Disable Metal debugging for performance
export MLX_FAST_MEM=1                          # Enable fast memory access if using MLX backend

# macOS System Optimizations
export MPS_NUM_THREADS=0                       # Let MPS decide thread count
export VECLIB_MAXIMUM_THREADS=0                # Let vecLib optimize thread usage

# Debug Information
echo "Apple Silicon Configuration:"
echo "  OLLAMA_NUM_PARALLEL: $OLLAMA_NUM_PARALLEL"
echo "  OLLAMA_MAX_LOADED_MODELS: $OLLAMA_MAX_LOADED_MODELS"
echo "  OLLAMA_GPU_LAYERS: $OLLAMA_GPU_LAYERS"
echo "  GGML_METAL: $GGML_METAL"
echo "  OLLAMA_NUM_THREAD: $OLLAMA_NUM_THREAD"
echo ""

# Check Apple Silicon system info
if command -v sysctl &> /dev/null; then
    echo "Apple Silicon System Info:"
    echo "  Chip: $(sysctl -n machdep.cpu.brand_string)"
    echo "  CPU Cores: $(sysctl -n hw.ncpu)"
    echo "  Performance Cores: $(sysctl -n hw.perflevel0.logicalcpu_max 2>/dev/null || echo 'N/A')"
    echo "  Efficiency Cores: $(sysctl -n hw.perflevel1.logicalcpu_max 2>/dev/null || echo 'N/A')"
    echo "  Memory: $(echo "scale=2; $(sysctl -n hw.memsize) / 1024 / 1024 / 1024" | bc) GB"
    echo ""
fi

# Check if Metal is available
if command -v system_profiler &> /dev/null; then
    echo "Metal GPU Info:"
    system_profiler SPDisplaysDataType | grep -A 3 "Chipset Model:" | head -4
    echo ""
fi

# Start OLLAMA server
echo "Starting OLLAMA server with Apple Silicon optimizations..."
ollama serve