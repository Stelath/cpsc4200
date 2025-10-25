#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main()
{
    char * fn = "/tmp/XYZ";
    char buffer[60];
    FILE *fp;

    /* get user input */
    scanf("%50s", buffer);

    // Apply Principle of Least Privilege
    // Temporarily disable root privilege
    uid_t real_uid = getuid();
    uid_t effective_uid = geteuid();

    // Drop privilege to real user's privilege
    seteuid(real_uid);

    // Now perform the check with the real user's privilege
    if(!access(fn, W_OK)){
        // Re-enable root privilege only for the file operation if needed
        // But since we want to write as the real user, keep it disabled
        fp = fopen(fn, "a+");
        if (fp != NULL) {
            fwrite("\n", sizeof(char), 1, fp);
            fwrite(buffer, sizeof(char), strlen(buffer), fp);
            fclose(fp);
        }
    }
    else {
        printf("No permission \n");
    }

    // Restore effective UID (though program is ending)
    seteuid(effective_uid);

    return 0;
}
