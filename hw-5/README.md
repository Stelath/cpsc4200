# Buffer Overflow Attack Lab (ARM64 Server Version)

## Lab Overview

This lab provides hands-on experience with buffer overflow vulnerabilities and attacks on ARM64 architecture. You will exploit vulnerable server programs running with root privilege to gain unauthorized access, and then experiment with various countermeasures.

**Learning Objectives:**
1. Understand how buffer overflow vulnerabilities work in ARM64 architecture
2. Learn to write and use shellcode for code injection attacks
3. Master techniques for exploiting buffer overflows with different constraints
4. Evaluate the effectiveness of various security countermeasures

---

## Task Progression

```
Task 1: Shellcode Familiarization
    ↓
Task 2: Level-1 Attack (Basic - with debug info)
    ↓
Task 3: Level-2 Attack (No frame pointer hints)
    ↓
Task 4: Level-3 Attack (strcpy - no null bytes)
    ↓
Task 5: Level-4 Attack (Small buffer challenge)
    ↓
Task 6: ASLR Countermeasure Testing
    ↓
Task 7a: StackGuard Protection
    ↓
Task 7b: Non-Executable Stack Protection
```

---

## ⚡ Quick Start

**First time setup (required before any tasks):**

```bash
cd Labsetup
chmod +x setup.sh
./setup.sh
```

This script will compile the server programs and build Docker images.

**After setup, start servers:**
```bash
docker compose up
```

Then begin with Task 1:
```bash
cd ../task1
./test_shellcode.sh
```

---

## Environment Setup

### Prerequisites

1. **SEED Ubuntu 20.04 VM** (ARM64 version recommended)
2. **Docker and Docker Compose** installed
3. **Python 3** for exploit development
4. **netcat (nc)** for network communication

### Initial Setup

#### 1. Disable Address Randomization

Before starting the lab, disable ASLR (Address Space Layout Randomization):

```bash
sudo /sbin/sysctl -w kernel.randomize_va_space=0
```

**Verification:**
```bash
cat /proc/sys/kernel/randomize_va_space
# Should output: 0
```

#### 2. Run Setup Script (Recommended)

```bash
cd Labsetup
chmod +x setup.sh
./setup.sh
```

Or manually:

**2a. Build Server Binaries:**
```bash
cd Labsetup/server-code
make
make install
```

**2b. Build Docker Containers:**
```bash
cd ..
docker compose build
```

#### 3. Start Servers

```bash
docker compose up
```

Or start individual servers:
```bash
docker compose up bof-server-L1  # Level 1 only
```

---

## Lab Architecture

### Server Infrastructure

| Level | IP Address | Port | Buffer Size | Vulnerability | Debug Info |
|-------|-----------|------|-------------|---------------|------------|
| L1 | 10.9.0.5 | 9090 | 100 bytes | memcpy | Frame pointer shown |
| L2 | 10.9.0.6 | 9090 | 80 bytes | memcpy | Buffer address only |
| L3 | 10.9.0.7 | 9090 | 300 bytes | strcpy | Frame pointer shown |
| L4 | 10.9.0.8 | 9090 | 20 bytes | strcpy | Frame pointer shown |

### Network Topology

```
┌─────────────────┐
│   Your VM       │
│  (Attacker)     │
│  10.9.0.1       │
└────────┬────────┘
         │
    ┌────┴────┐
    │ Network │ 10.9.0.0/24
    └────┬────┘
         │
    ┌────┴─────────────────┬─────────────┬─────────────┐
    │                      │             │             │
┌───▼────┐            ┌───▼────┐   ┌───▼────┐   ┌───▼────┐
│ L1     │            │ L2     │   │ L3     │   │ L4     │
│10.9.0.5│            │10.9.0.6│   │10.9.0.7│   │10.9.0.8│
└────────┘            └────────┘   └────────┘   └────────┘
```

---

## Complete File Structure

```
hw-5/
├── README.md                    ← You are here
├── Labsetup/                    ← Docker infrastructure
│   ├── docker-compose.yml
│   ├── server-code/            ← Vulnerable programs
│   │   ├── stack.c
│   │   ├── server.c
│   │   └── Makefile
│   ├── shellcode/              ← ARM64 shellcode
│   │   ├── shellcode_64.py
│   │   ├── call_shellcode.c
│   │   └── Makefile
│   ├── attack-code/            ← Exploit templates
│   │   └── exploit.py
│   └── bof-containers/         ← Docker files
│       └── Dockerfile
├── task1/                      ← Shellcode familiarization
│   ├── README.md
│   ├── test_shellcode.sh
│   └── shellcode_delete.py
├── task2/                      ← Level-1 attack
│   ├── README.md
│   ├── exploit.py
│   ├── send_payload.sh
│   └── start_server.sh
├── task3/                      ← Level-2 attack
│   ├── README.md
│   ├── exploit.py
│   └── send_payload.sh
├── task4/                      ← Level-3 attack
│   ├── README.md
│   ├── exploit.py
│   └── send_payload.sh
├── task5/                      ← Level-4 attack
│   ├── README.md
│   ├── exploit.py
│   └── send_payload.sh
├── task6/                      ← ASLR testing
│   ├── README.md
│   └── test_aslr.sh
├── task7a/                     ← StackGuard protection
│   ├── README.md
│   ├── Makefile
│   └── test_stackguard.sh
└── task7b/                     ← Non-executable stack
    ├── README.md
    ├── Makefile
    └── test_nx.sh
```

---

## Quick Start Guide

### Standard Workflow for Attack Tasks

1. **Navigate to task folder:**
   ```bash
   cd task2/  # or task3, task4, task5
   ```

2. **Read the README:**
   ```bash
   cat README.md
   ```

3. **Start the target server** (if not already running):
   ```bash
   ./start_server.sh
   # OR from Labsetup/:
   docker compose up bof-server-L1
   ```

4. **Develop exploit:**
   - Edit `exploit.py` with calculated offsets and addresses
   - Test locally if possible

5. **Send payload to server:**
   ```bash
   ./send_payload.sh
   # OR manually:
   cat badfile | nc 10.9.0.X 9090
   ```

6. **Verify success:**
   - Check server container output for command execution
   - Look for reverse shell connection

7. **Document findings:**
   - Take screenshots
   - Note addresses, offsets, and techniques used

---

## Safety and Best Practices

### ⚠️ Important Warnings

1. **VM Snapshots**: Take a snapshot before starting the lab
2. **Backup Data**: This lab modifies system files - backup important data
3. **Controlled Environment**: Only run attacks in the isolated Docker containers
4. **ASLR Disable**: Remember to re-enable ASLR after completing the lab
5. **Root Privilege**: Some commands require sudo - understand what they do

### Re-enabling ASLR After Lab

```bash
sudo /sbin/sysctl -w kernel.randomize_va_space=2
```

### Cleanup Commands

**Stop all containers:**
```bash
cd Labsetup/
docker compose down
```

**Remove all lab containers:**
```bash
docker compose down -v
docker system prune -f
```

**Reset network settings:**
```bash
sudo /sbin/sysctl -w kernel.randomize_va_space=2
```

---

## Key Concepts Covered

### 1. Buffer Overflow Mechanics
- Stack frame layout in ARM64 architecture
- Difference between x86/amd64 and ARM64 stack organization
- Role of frame pointer (x29) and link register (x30/LR)

### 2. Exploitation Techniques
- NOP sled construction (0xD503201F in ARM64)
- Return address overwriting
- Shellcode injection and execution
- Reverse shell establishment

### 3. Attack Constraints
- **memcpy vs strcpy**: Null byte handling
- **Buffer size variations**: From 20 to 300 bytes
- **Debug information availability**: With/without frame pointer hints
- **Address space restrictions**: 64-bit addresses with leading zeros

### 4. Security Countermeasures
- **ASLR** (Address Space Layout Randomization)
- **StackGuard/Stack Canaries**
- **Non-Executable Stack (NX bit)**

---

## Troubleshooting

### Common Issues

**Problem: Docker build fails with "stack-L1: not found" or similar**
```
ERROR [bof-server-L1 3/4] COPY stack-L1  /bof/stack
"/stack-L1": not found
```

**Cause:** Server binaries haven't been compiled yet.

**Solution:**
```bash
cd Labsetup
./setup.sh
```

Or manually:
```bash
cd Labsetup/server-code
make && make install
cd .. && docker compose build
```

**Problem: Docker permission denied**
```
permission denied while trying to connect to the Docker daemon socket
```

**Cause:** User doesn't have Docker permissions.

**Solution (Recommended):**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Apply group membership (choose one):
newgrp docker              # Apply in current terminal
# OR logout and login again
```

**Alternative:** Use sudo for all docker commands:
```bash
sudo docker compose up
```

**Verify it worked:**
```bash
docker ps  # Should work without sudo
```

**Problem: "Connection refused" when using nc**
```bash
# Solution: Check if server is running
docker ps | grep bof-server
# If not running:
cd Labsetup && docker compose up bof-server-L1
```

**Problem: "Cannot find badfile"**
```bash
# Solution: Generate payload first
python3 exploit.py
ls -l badfile  # Verify it exists
```

**Problem: Server crashes immediately**
```bash
# Solution: Check docker logs
docker compose logs bof-server-L1
# Restart container
docker compose restart bof-server-L1
```

**Problem: Addresses change between attempts**
```bash
# Check ASLR status
cat /proc/sys/kernel/randomize_va_space
# Should be 0, if not:
sudo /sbin/sysctl -w kernel.randomize_va_space=0
# Restart containers
docker compose restart
```

**Problem: Exploit works locally but not on server**
- Check that you're using correct IP address (10.9.0.X)
- Verify server is listening: `docker compose logs bof-server-LX`
- Ensure payload file is up-to-date: `ls -l badfile`
- Check for network issues: `ping 10.9.0.X`

---

## Lab Report Guidelines

Your lab report should include:

### For Each Attack Task (2-5):

1. **Objective**: Brief description of the task goal
2. **Analysis**:
   - Server output showing addresses
   - Calculations for offsets and return addresses
   - Stack diagram showing memory layout
3. **Exploit Code**: Commented exploit.py with explanations
4. **Execution**:
   - Screenshots of sending payload
   - Server output showing successful exploitation
5. **Explanation**:
   - Why the attack worked
   - How you determined the correct values
   - Challenges faced and solutions

### For Countermeasure Tasks (6, 7a, 7b):

1. **Objective**: What countermeasure is being tested
2. **Setup**: How you enabled the protection
3. **Testing**: Commands run and their output
4. **Results**: Whether attack succeeded or failed
5. **Analysis**:
   - Why the countermeasure worked or didn't work
   - Mechanisms behind the protection
   - Potential bypasses (if any)

### Required Elements:

- **Screenshots**: Clear and labeled
- **Code snippets**: With line-by-line explanations
- **Memory diagrams**: Showing stack layout
- **Command output**: Full terminal sessions
- **Analysis**: Deep understanding, not just "it worked"

---

## Additional Resources

### Documentation
- Original lab PDF in `Labsetup/` (if provided)
- SEED Project website: https://seedsecuritylabs.org/
- ARM64 architecture reference

### Tools Used
- **netcat (nc)**: Network communication
- **Python 3**: Exploit development
- **Docker**: Container management
- **GDB**: Debugging (optional, for analysis)

### Related SEED Labs
- Shellcode Development Lab
- Return-to-libc Attack Lab
- Format String Vulnerability Lab

---

## Getting Help

### Before Asking for Help:

1. Read the task README carefully
2. Check the Troubleshooting section above
3. Review your calculations and offsets
4. Verify server is running and accessible
5. Check docker logs for error messages

### Debugging Tips:

- Use `echo hello | nc 10.9.0.X 9090` to test connectivity
- Check server output for debug addresses
- Draw memory diagrams to visualize stack layout
- Test shellcode independently before integrating
- Start with simple payloads and add complexity

---

## Credits

**Copyright © 2020, 2023 by Wenliang Du**
SEED Security Labs
Licensed under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License

---

**Good luck with your lab!**

Remember: The goal is to understand how vulnerabilities work and how to defend against them. Always use these techniques responsibly and only in authorized environments.
