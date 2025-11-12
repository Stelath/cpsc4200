#!/bin/bash
set -e

echo "Task 1: Testing Modified Shellcode"
echo "==================================="
echo ""

# Create test file
echo "Creating test file: /tmp/testfile_task1.txt"
echo "This file will be deleted by shellcode" > /tmp/testfile_task1.txt
ls -l /tmp/testfile_task1.txt
echo ""

# Build shellcode and test harness
echo "Building..."
make
echo ""

# Execute shellcode
echo "Executing shellcode..."
./call_shellcode
echo ""

# Check result
if [ -f /tmp/testfile_task1.txt ]; then
    echo "⚠ Test file still exists - shellcode may not have worked"
    ls -l /tmp/testfile_task1.txt
else
    echo "✓ Success! Test file was deleted by shellcode"
fi
