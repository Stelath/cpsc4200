# Task 6: ASLR Countermeasure

## Objective
Observe how Address Space Layout Randomization (ASLR) defeats buffer overflow attacks.

## What is ASLR?

ASLR randomizes memory addresses each time a program runs:
- Stack addresses change
- Heap addresses change
- Library addresses change

This makes it hard for attackers to predict where to jump.

## Quick Start

### 1. Enable ASLR
```bash
sudo /sbin/sysctl -w kernel.randomize_va_space=2
```

### 2. Restart Containers
```bash
cd ../Labsetup
docker-compose restart
```

### 3. Test Address Randomization
```bash
cd ../task6
./test_aslr.sh
```

This script probes Level-1 and Level-3 servers multiple times to show changing addresses.

### 4. Manual Testing
```bash
# Probe Level-1 server multiple times
for i in {1..5}; do
    echo "Attempt $i:"
    echo hello | nc 10.9.0.5 9090 2>&1 | grep "address"
    sleep 1
done
```

## Expected Results

**With ASLR disabled (value=0):**
- Addresses stay the same across connections
- Exploit works consistently

**With ASLR enabled (value=2):**
- Addresses change each connection
- Exploit fails because return address is wrong

## Why ASLR Works

Your exploit hardcodes addresses like:
```python
buffer_addr = 0x0000fffffffff0a0
ret = buffer_addr + 20
```

With ASLR, `buffer_addr` changes each run:
- Run 1: `0x0000fffffffff0a0`
- Run 2: `0x0000ffffffffe8d0`
- Run 3: `0x0000ffffffff f2b0`

Your exploit points to wrong address → crash instead of shellcode execution.

## Bypassing ASLR (Advanced)

ASLR can be defeated by:
1. **Information leak**: Leak an address, calculate offsets
2. **Brute force**: Try many times (works if ASLR entropy is low)
3. **Partial overwrite**: Overwrite only lower bytes (some architectures)

## Cleanup

Re-disable ASLR for remaining tasks:
```bash
sudo /sbin/sysctl -w kernel.randomize_va_space=0
docker-compose restart
```

## Lab Report Requirements
- Screenshots showing changing addresses with ASLR enabled
- Comparison of addresses with ASLR on vs off
- Explanation of why your exploit fails with ASLR
- Discussion of ASLR effectiveness
