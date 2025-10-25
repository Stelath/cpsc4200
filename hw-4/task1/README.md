# Task 1: Choosing Our Target

## Objective
Verify that the magic password works by manually adding a test entry to `/etc/passwd`.

## Instructions

1. As a superuser, add the following entry to the end of `/etc/passwd`:
   ```
   test:U6aMy0wojraho:0:0:test:/root:/bin/bash
   ```

2. Try to log in as the `test` user without typing a password (just hit Enter when prompted)

3. Verify you have root privileges by running:
   ```bash
   id
   whoami
   ```

4. After verification, remove this entry from the password file

## Notes
- The magic password `U6aMy0wojraho` (6th character is zero, not letter O) is from Ubuntu live CD
- The third field (0) gives the user root privileges
- This is a manual verification before attempting the automated attack

## Warning
Make a backup of `/etc/passwd` before modifying it:
```bash
sudo cp /etc/passwd /etc/passwd.backup
```
