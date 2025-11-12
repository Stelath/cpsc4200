#!/bin/bash

if ! docker ps &>/dev/null; then
    echo "Docker permission denied. Run: sudo usermod -aG docker \$USER && newgrp docker"
    exit 1
fi

cd ../Labsetup
docker compose up bof-server-L1
