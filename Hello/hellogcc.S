/***********************************************************************
* hellogcc.S
*
* "Hello World" in ARm Assembly
*
* Kevin J Chamberlain
*
* Tue Sept 7, 2021
*
* This is a simple Hello World program written in ARm assembly and using
* printf() frin the C standard library.
* 
* It should be compuled and linked as follows:
*   gcc -o hellogcc.S
*
* gcc will call the asembler and linker, telling the linker to inclyde
* the C standard library in the executable program.
***********************************************************************/
    .data

msg:	.ascii "Hello World!\n"
len	= . - msg

	.text

.globl main
    //main is called by the _start function which is in the C 
    // standard library
main:
    str    lr, [sp, #-16]!
    //write( int fd, const void *buf, size_t count)
    //standard library
    ldr    x0, =msg
    bl     printf
    // return from main()
    mov    x0, #0
    ldr    lr, [sp], #16
    ret
.end

