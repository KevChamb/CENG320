	.data
str1:	.asciz "%d"	//formatting string for reading an int with scanf
	.align 2

str2:	.asciz "%ld"	//format string for reading a 64-bit int with scanf
	.align 2

str3:	.asciz "You entered %d\n"	//format string for printing an int with	scanf
	.align 2

str4:	.asciz "You entered %ld\n" //format string for printing a 64-bit int with 	scanf
	.align 2

fmt:	.asciz "The sum is: %d\n"
	.align 2

n:	.word  0
m:	.dword 0

i:	.word  0
j:	.dword 0

	.text

// .global enable the compuler to locate main function
// allowed function to be called by other functions not in file
	.global main

main:
   str lr, [sp, #-16]! //push lr onto the stack

   //Read in a 32 bit number
   ldr x0, =str1	//load the address of format string
   ldr x1, =n		//load address of 32-bit int variable
   bl scanf 		// call scanf( '%d", &n)

   //Read in a 32 bit number
   ldr x0, =str1	//loading the address of format string
   ldr x1, =i		//load address of 32-bit int variable
   bl scanf		// call scanf( '%d", &n)
   

   //Print a 32 bit number
   ldr x0, =fmt  	//load the address of the format string
   ldr w1, n		//load the address of the 64-bit int variable
   ldr w2, i		//load the address of "i" 64-bit int
   add w1, w1, w2
   bl printf		//call printf("You entered %d\n"

   //Read a 64 bit number
   ldr x0, =str2	//load the address of the format string
   ldr x1, =m		//load the address of the 64-bit int variable
   bl  scanf		//call scanf( "%ld", &m)
   
   //Read in another 64
   mov x2, x1	//Move registers to make room for another 64 bit int
   ldr x0, =str2
   ldr x1, =j
   bl  scanf
  
   //print a 64 bit number
   ldr x0, =fmt		//load the address of the format string
   ldr x1, j
   ldr x2, m
   add x1, x1, x2
   bl  printf		//call printf( "You entered %;d\n"
   
   ldr lr, [sp], #16	//pop lr from stack
   mov x0, #0		//load return value
   ret			//return from main

   
   .end

