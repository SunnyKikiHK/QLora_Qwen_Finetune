#!/bin/bash

# Setup script for Miniconda and Python environment
# This script downloads Miniconda and creates a conda environment with all required dependencies

set -e  # Exit on error

echo "=========================================="
echo "Miniconda Setup and Environment Creation"
echo "=========================================="

# Define variables
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
MINICONDA_INSTALLER="Miniconda3-latest-Linux-x86_64.sh"
ENV_NAME="qwen_finetune"
PYTHON_VERSION="3.9"

# Step 1: Download Miniconda
echo ""
echo "[1/4] Downloading Miniconda..."
if [ ! -f "$MINICONDA_INSTALLER" ]; then
    wget "$MINICONDA_URL" -O "$MINICONDA_INSTALLER"
    echo "✓ Miniconda downloaded successfully"
else
    echo "✓ Miniconda installer already exists"
fi

# Step 2: Install Miniconda
echo ""
echo "[2/4] Installing Miniconda..."
if [ ! -d "$HOME/miniconda3" ]; then
    bash "$MINICONDA_INSTALLER" -b -p "$HOME/miniconda3"
    echo "✓ Miniconda installed successfully"
else
    echo "✓ Miniconda already installed"
fi

# Step 3: Initialize conda
echo ""
echo "[3/4] Initializing conda..."
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
conda init bash

conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Step 4: Create and activate environment
echo ""
echo "[4/4] Creating conda environment '$ENV_NAME' with Python $PYTHON_VERSION..."
conda create -n "$ENV_NAME" python="$PYTHON_VERSION" -y

# Activate the environment
source activate "$ENV_NAME"

# Install requirements
echo ""
echo "Installing Python packages from requirements.txt..."
pip install --upgrade pip
pip install -r requirements.txt

echo ""
echo "=========================================="
echo "✓ Setup completed successfully!"
echo "=========================================="
echo ""
echo "To activate the environment, run:"
echo "  conda activate $ENV_NAME"
echo ""
echo "To deactivate the environment, run:"
echo "  conda deactivate"
echo ""
