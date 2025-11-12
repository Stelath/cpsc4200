#!/bin/bash
set -e

echo "This file will be deleted by shellcode" > /tmp/testfile_task1.txt
make
./call_shellcode

if [ ! -f /tmp/testfile_task1.txt ]; then
    echo "✓ Success: Test file deleted"
else
    echo "⚠ Test file still exists"
fi
