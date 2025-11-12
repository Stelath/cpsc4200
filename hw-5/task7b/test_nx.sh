#!/bin/bash
set -e

if [ ! -f "../Labsetup/shellcode/codefile_64" ]; then
    cd ../Labsetup/shellcode
    ./shellcode_64.py
    cd ../../task7b
fi

if [ ! -f "call_shellcode_nx" ]; then
    make
fi

cp ../Labsetup/shellcode/codefile_64 .

echo "Testing non-executable stack..."
./call_shellcode_nx || true
echo ""
echo "Expected: Segmentation fault"
echo "Compare with: cd ../Labsetup/shellcode && ./a64.out"
