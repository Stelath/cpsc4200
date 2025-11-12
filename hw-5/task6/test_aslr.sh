#!/bin/bash

current=$(cat /proc/sys/kernel/randomize_va_space)
echo "ASLR setting: $current (0=disabled, 2=enabled)"
echo ""

echo "Probing Level-1 server 5 times:"
for i in {1..5}; do
    echo "Attempt $i:"
    echo hello | nc -w 1 10.9.0.5 9090 2>&1 | grep -E "(Buffer|Frame pointer)" | head -2
    sleep 0.5
done
echo ""

echo "With ASLR disabled (0): addresses should be identical"
echo "With ASLR enabled (2): addresses should change each time"
echo ""
echo "To toggle ASLR:"
echo "  sudo /sbin/sysctl -w kernel.randomize_va_space=0  # Disable"
echo "  sudo /sbin/sysctl -w kernel.randomize_va_space=2  # Enable"
echo "  docker compose restart  # After changing ASLR"
