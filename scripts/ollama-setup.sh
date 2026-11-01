#!/bin/bash

# APT update and upgrade
sudo apt update
sudo apt upgrade -y

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Update a systemd service for Ollama
echo '[Service]' >> /etc/systemd/system/ollama.service
echo 'Environment="OLLAMA_HOST=0.0.0.0"' >> /etc/systemd/system/ollama.service

# Reload systemd and restart Ollama service
sudo systemctl daemon-reload
sudo systemctl restart ollama
sudo systemctl enable ollama

# Pull the tinyllama model
# ollama pull tinyllama