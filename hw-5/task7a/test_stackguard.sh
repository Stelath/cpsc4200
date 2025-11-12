#!/bin/bash
set -e

echo "StackGuard Protection Test"
echo "==========================="
echo ""

# Compile if needed
if [ ! -f "stack-L1-protected" ]; then
    echo "Compiling with StackGuard..."
    make
    echo ""
fi

# Check if badfile exists
if [ ! -f "../task2/badfile" ]; then
    echo "Error: Need badfile from task2"
    echo "Run: cd ../task2 && python3 exploit.py"
    exit 1
fi

echo "Testing protected binary with exploit payload..."
echo "------------------------------------------------"
./stack-L1-protected < ../task2/badfile || true
echo ""

echo "Expected: '*** stack smashing detected ***'"
echo "This means StackGuard caught the buffer overflow!"
