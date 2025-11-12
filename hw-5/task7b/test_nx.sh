#!/bin/bash
set -e

echo "Non-Executable Stack Test"
echo "=========================="
echo ""

# Ensure shellcode is generated
if [ ! -f "../../Labsetup/shellcode/codefile_64" ]; then
    echo "Generating shellcode..."
    cd ../../Labsetup/shellcode
    ./shellcode_64.py
    cd ../../task7b
fi

# Compile if needed
if [ ! -f "call_shellcode_nx" ]; then
    echo "Compiling with NX protection..."
    make
    echo ""
fi

# Copy shellcode to current directory
cp ../../Labsetup/shellcode/codefile_64 .

echo "Testing shellcode with non-executable stack..."
echo "----------------------------------------------"
./call_shellcode_nx || true
echo ""

echo "Expected: Segmentation fault"
echo "This means NX prevented shellcode execution on the stack!"
echo ""
echo "Compare with executable stack version:"
echo "  cd ../../Labsetup/shellcode && ./a64.out"
