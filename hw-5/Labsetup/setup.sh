#!/bin/bash

echo "========================================="
echo "Buffer Overflow Lab Setup"
echo "========================================="
echo ""

set -e

# Step 1: Compile server binaries
echo "[1/3] Compiling vulnerable server programs..."
cd server-code
make clean 2>/dev/null || true
make
echo "✓ Compiled: server, stack-L1, stack-L2, stack-L3, stack-L4"
echo ""

# Step 2: Install binaries to container directory
echo "[2/3] Installing binaries to bof-containers/..."
make install
echo "✓ Binaries copied to bof-containers/"
echo ""

# Step 3: Build Docker images
cd ..
echo "[3/3] Building Docker container images..."
docker compose build
echo ""

echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Start all servers:    docker compose up"
echo "  2. Or start one level:   docker compose up bof-server-L1"
echo "  3. Begin with:           cd ../task1"
echo ""
