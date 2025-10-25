#include <unistd.h>

extern char **environ;

int main()
{
    char *argv[2];

    argv[0] = "/usr/bin/env";
    argv[1] = NULL;

    // Step 1: execve with NULL environment (uncomment below)
    // execve("/usr/bin/env", argv, NULL);

    // Step 2: execve with environ (comment above, uncomment below)
    execve("/usr/bin/env", argv, environ);

    return 0;
}
