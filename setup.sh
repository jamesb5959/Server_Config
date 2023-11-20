#!/bin/bash

# Define the required packages
required_packages=("exploitdb" "vim" "git" "docker")

# Function to check and install packages
check_and_install_packages() {
    local missing_packages=()
    for pkg in "${required_packages[@]}"; do
        if ! pacman -Qs "$pkg" &>/dev/null; then
            missing_packages+=("$pkg")
        fi
    }

    if [ "${#missing_packages[@]}" -gt 0 ]; then
        echo "Installing missing packages: ${missing_packages[@]}"
        sudo pacman -S "${missing_packages[@]}" || {
            echo "Failed to install the following packages: ${missing_packages[@]}"
            echo "Please install them manually."
        }
    fi
}

# Check and install required packages
check_and_install_packages

echo "Downloading packages completed."

mkdir models
wget https://gpt4all.io/models/ggml-gpt4all-j.bin -O models/ggml-gpt4all-j
docker run -p 8080:8080 -v $PWD/models:/models -ti --rm quay.io/go-skynet/local-ai:latest --models-path /models --context-size 700 --threads 4

echo "LocalGPT setup completed."
