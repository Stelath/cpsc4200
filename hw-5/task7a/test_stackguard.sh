#!/bin/bash
set -e

if [ ! -f "stack-L1-protected" ]; then
    make
fi

if [ ! -f "../task2/badfile" ]; then
    echo "Error: Need badfile from task2"
    echo "Run: cd ../task2 && python3 exploit.py"
    exit 1
fi

echo "Testing StackGuard protection..."
./stack-L1-protected < ../task2/badfile || true
echo ""
echo "Expected: '*** stack smashing detected ***'"
