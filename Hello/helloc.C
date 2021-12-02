/***********************************************************************
 * hello.c
 * "Hello World" in C
 *
 * Kevin J Chamberlain
 *
 * Tue Sept 7, 2021
 *
 * This is a simple Hello World program written int c and using
 * printf() from the C Standard library.
 *
 * It should be compiled and linked as follows:
 *   gcc -o helloc helloc.c
 *
 * gcc will call the compuler, assembler, and linker, telling the linker
 * to include the C standard library in the executable program.
 ***********************************************************************/

#include <stdio.h>

int main()
{
	printf("Hello World\n");
	return 0;
}

