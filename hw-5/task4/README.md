# Task 4: Level-3 Attack

## Objective
Exploit buffer overflow with `strcpy()` vulnerability - no null bytes allowed in payload.

## Target Info
- **IP**: 10.9.0.7:9090
- **Buffer**: 300 bytes
- **Vulnerability**: `strcpy()` stops at null bytes
- **Debug**: Provides frame pointer + buffer address

## Key Challenge: Null Bytes

64-bit ARM addresses look like: `0x0000fffffffff0a0`
- Upper 2 bytes are **always 0x0000**
- `strcpy()` stops copying at first `\x00`
- Problem: Can't include full address in payload

## Solution Strategy

The payload itself gets copied until strcpy hits a null byte. However, the return address we need to overwrite might already contain data. The key insight:

1. **Payload structure**: `[Shellcode][NOPs][Return Address bytes]`
2. **Addressing null bytes**: Write address in little-endian format
   - Example: `0x0000fffffffff0a0` becomes `\xa0\xf0\xff\xff\xff\xff\x00\x00`
   - First 6 bytes have no nulls
   - strcpy copies until it hits the `\x00` bytes

3. **Critical placement**: Ensure shellcode and important data are placed before any null bytes in the payload

## Alternative Approach

If the simple approach doesn't work, place shellcode and NOP sled entirely before the return address location, then let strcpy stop at the null bytes of the return address.

## Quick Start

### 1. Start Server
```bash
cd ../Labsetup && docker-compose up bof-server-L3
```

### 2. Get Addresses
```bash
echo hello | nc 10.9.0.7 9090
```

### 3. Update Exploit
Edit `exploit.py` lines 42-43 with server output values.

### 4. Send Payload
```bash
python3 exploit.py
cat badfile | nc 10.9.0.7 9090
# Or: ./send_payload.sh
```

## Differences from Level-1/2
- Uses `strcpy()` instead of `memcpy()`
- Copying stops at first null byte
- Larger buffer (300 bytes) gives more space
- Must be careful about address encoding

## Lab Report Requirements
- Explanation of null byte problem
- How you solved the null byte restriction
- Memory layout showing payload structure
- Discussion of why strcpy makes exploitation harder
- Screenshot of successful attack
