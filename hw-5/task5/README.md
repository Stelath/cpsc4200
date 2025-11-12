# Task 5: Level-4 Attack

## Objective
Exploit with very small buffer (20 bytes) and strcpy restriction. Shellcode must be placed outside buffer.

## Target Info
- **IP**: 10.9.0.8:9090
- **Buffer**: 20 bytes (very small!)
- **Vulnerability**: `strcpy()` - no null bytes
- **Debug**: Provides frame pointer + buffer address
- **Input size**: 517 bytes total

## Key Challenge: Insufficient Buffer Space

Shellcode is ~200 bytes, but buffer is only 20 bytes. Solution: Place shellcode elsewhere in the input.

## Strategy

The program reads 517 bytes total from the network. The `strcpy()` call copies this to the 20-byte buffer:

```
Input (517 bytes):  [-------------------------------------------]
                     ^       ^
                     0      20                              517

Buffer (20 bytes):   [---]
```

Even though buffer is small, we can:
1. Place shellcode at higher offsets in the 517-byte input (e.g., offset 300-500)
2. These bytes get written somewhere in stack memory
3. Calculate where they end up
4. Point return address to that location

## Memory Layout Insight

When `bof()` is called:
- Stack grows with function frames
- The 517-byte input is in `main()`'s stack frame
- We can calculate addresses relative to buffer address

## Quick Start

### 1. Start Server
```bash
cd ../Labsetup && docker compose up bof-server-L4
```

### 2. Get Addresses
```bash
echo hello | nc 10.9.0.8:9090
```

### 3. Update Exploit
Edit `exploit.py` with buffer and frame pointer values.

### 4. Send Payload
```bash
python3 exploit.py
cat badfile | nc 10.9.0.8 9090
# Or: ./send_payload.sh
```

## Payload Structure

```
[Buffer overflow (20 bytes)][Padding][Return addr][More padding][Shellcode at offset ~300]
 ^                                                                ^
 buffer_addr                                                      Calculate address
```

The shellcode is placed late in the payload where it won't be affected by strcpy's null byte termination (until the null bytes in return address are reached).

## Lab Report Requirements
- Explanation of small buffer challenge
- How you determined where to place shellcode
- Address calculations for shellcode location
- Memory layout diagram
- Screenshot of success
