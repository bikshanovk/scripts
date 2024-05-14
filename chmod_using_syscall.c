#include <sys/syscall.h>
 
int main() {
 
    syscall(SYS_chmod, "/bin/chmod", 0755);
    return 0;
 
}

#How to use:
#1. Compile file using command gcc chmod.c -o chmod2
#3. Run using ./chmod2 or sudo ./chmod2
