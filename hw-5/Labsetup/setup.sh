#!/bin/bash
set -e

# Check Docker permissions
if ! docker ps &>/dev/null; then
    echo "Docker permission denied. Add user to docker group:"
    echo "  sudo usermod -aG docker \$USER && newgrp docker"
    exit 1
fi

# Make scripts executable
cd ..
find task* -name "*.sh" -exec chmod +x {} \;
find task* -name "*.py" -exec chmod +x {} \;
cd Labsetup

# Compile and install
cd server-code
make clean 2>/dev/null || true
make
make install
cd ..

# Build containers
docker compose build

echo "Setup complete. Run: docker compose up"
