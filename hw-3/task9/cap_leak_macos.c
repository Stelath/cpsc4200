#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

/*
 * macOS-friendly version that uses /tmp instead of /etc
 * This works around macOS SIP restrictions for demonstration purposes
 */

void main()
{
    int fd;
    char *v[2];

    // Use /tmp/zzz on macOS since /etc is SIP-protected
    fd = open("/tmp/zzz", O_RDWR | O_APPEND);
    if (fd == -1) {
        printf("Cannot open /tmp/zzz\n");
        printf("Run: touch /tmp/zzz\n");
        exit(0);
    }

    printf("fd is %d\n", fd);
    printf("File descriptor leaked! After privilege drop, you can still write:\n");
    printf("  echo 'capability leaked!' >&%d\n", fd);
    printf("  cat /tmp/zzz\n");

    // Permanently disable the privilege
    setuid(getuid());

    v[0] = "/bin/sh"; v[1] = 0;
    execve(v[0], v, 0);
}
