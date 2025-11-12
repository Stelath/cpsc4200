# Task 3: Level-2 Attack

## Objective
Exploit buffer overflow without frame pointer information. Use NOP sled technique to handle uncertainty.

## Target Info
- **IP**: 10.9.0.6:9090
- **Buffer**: 80 bytes (unknown to you)
- **Vulnerability**: `memcpy()` copies 517 bytes
- **Debug**: Only buffer address (NO frame pointer)
- **Known**: Buffer size is between 100-200 bytes

## Challenge
Without the frame pointer, you don't know exactly where the return address is stored. Solution: NOP sled + multiple attempts.

## Quick Start

### 1. Start Server
```bash
cd ../Labsetup && docker-compose up bof-server-L2
```

### 2. Get Buffer Address
```bash
echo hello | nc 10.9.0.6 9090
```
Note the buffer address (frame pointer is NOT shown).

### 3. Update Exploit
Edit `exploit.py` line 40 with buffer address from server output.

### 4. Send Payload
```bash
python3 exploit.py
cat badfile | nc 10.9.0.6 9090
# Or: ./send_payload.sh
```

## Strategy: NOP Sled

Since we don't know exact offset to return address:
1. **Large NOP sled**: Fill most of payload with NOPs
2. **Multiple return addresses**: Overwrite range [100-200] bytes with return address
3. **Target NOP sled**: Return address points to middle of NOP sled

```
[Shellcode][NOP sled (large)][Multiple copies of return address]
           ^
           Return address points here (lands in NOPs, slides to shellcode)
```

## Key Differences from Level-1
- No frame pointer provided
- Must guess range where return address is
- Use NOP sled for reliability
- May need multiple attempts with different offsets

## Success Indicators
- Shellcode executes (see output in server logs)
- No "Returned Properly" message

## Lab Report Requirements
- Explanation of NOP sled technique
- How you determined payload structure
- Screenshot of successful attack
- Discussion of why one payload works for variable buffer sizes
