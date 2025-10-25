# Task 2B: The Real Attack

## Objective
Exploit the race condition without the artificial delay, using concurrent processes.

## Setup

1. **Disable Ubuntu's protection** (if not already done):
   ```bash
   sudo sysctl -w fs.protected_symlinks=0
   sudo sysctl fs.protected_regular=0
   ```

2. **Backup the password file**:
   ```bash
   sudo cp /etc/passwd /etc/passwd.backup
   ```

3. **Compile the programs**:
   ```bash
   make
   ```

4. **Make the shell script executable**:
   ```bash
   chmod +x target_process.sh
   ```

## Attack Steps

1. **Run the attack program** in one terminal (continuously swaps symbolic links):
   ```bash
   ./attack
   ```

2. **Run the target process** in another terminal (repeatedly calls vulp):
   ```bash
   ./target_process.sh
   ```

3. **Wait for success**. The script should terminate within a few minutes when `/etc/passwd` is modified.

4. **Stop the attack program** with Ctrl-C

5. **Verify the attack**:
   ```bash
   tail /etc/passwd
   su test
   id
   ```

## Notes
- This attack has probabilistic success - it may take several attempts
- If `/tmp/XYZ` becomes owned by root, you'll need to manually delete it as root:
  ```bash
  sudo rm /tmp/XYZ
  ```
- The attack exploits the time window between `access()` and `fopen()` calls

## Cleanup
```bash
sudo sed -i '/^test:/d' /etc/passwd
sudo rm /tmp/XYZ /tmp/ABC
```

## Expected Observations
- The attack should succeed within 5 minutes
- You may observe `/tmp/XYZ` ownership changing to root, which prevents further attack attempts
- This limitation is addressed in Task 2C
