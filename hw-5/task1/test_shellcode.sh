#!/bin/bash
set -e

echo "Creating test file..."
echo "This file will be deleted" > /tmp/testfile_task1.txt

cd ../Labsetup/shellcode
./shellcode_64.py
make -s
echo "Executing shellcode..."
./a64.out

if [ ! -f /tmp/testfile_task1.txt ]; then
    echo "✓ Success: Test file deleted"
else
    echo "⚠ Warning: Test file still exists"
fi
