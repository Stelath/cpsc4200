#!/bin/bash

echo "ASLR Countermeasure Test"
echo "========================"
echo ""

# Check current ASLR status
current=$(cat /proc/sys/kernel/randomize_va_space)
echo "Current ASLR setting: $current"
if [ "$current" -eq 0 ]; then
    echo "  (0 = Disabled)"
    echo ""
    echo "To enable ASLR, run:"
    echo "  sudo /sbin/sysctl -w kernel.randomize_va_space=2"
    echo "  cd ../Labsetup && docker compose restart"
    echo ""
elif [ "$current" -eq 2 ]; then
    echo "  (2 = Full randomization)"
else
    echo "  (1 = Partial randomization)"
fi
echo ""

# Test Level-1 server multiple times
echo "Probing Level-1 server (10.9.0.5) 5 times..."
echo "--------------------------------------------"
for i in {1..5}; do
    echo "Attempt $i:"
    echo hello | nc -w 1 10.9.0.5 9090 2>&1 | grep -E "(Buffer|Frame pointer)" | head -2
    sleep 0.5
done
echo ""

# Test Level-3 server multiple times
echo "Probing Level-3 server (10.9.0.7) 5 times..."
echo "--------------------------------------------"
for i in {1..5}; do
    echo "Attempt $i:"
    echo hello | nc -w 1 10.9.0.7 9090 2>&1 | grep -E "(Buffer|Frame pointer)" | head -2
    sleep 0.5
done
echo ""

echo "Analysis:"
echo "---------"
if [ "$current" -eq 0 ]; then
    echo "With ASLR disabled, addresses should be identical across all attempts."
else
    echo "With ASLR enabled, addresses should be different each time."
    echo "This makes buffer overflow exploits much harder!"
fi
echo ""

echo "To disable ASLR:"
echo "  sudo /sbin/sysctl -w kernel.randomize_va_space=0"
echo "  cd ../Labsetup && docker compose restart"
