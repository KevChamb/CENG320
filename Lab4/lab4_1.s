	.data
buffer: .skip 4096,0
i:      .word   0
sum:    .word   0					//HERE
str1:   .asciz  "Enter text (ctrl-D to end): "
        .align  2
str2:   .asciz  "\nThe checksum is %08X\n"
        .align  2
str3:   .asciz  "%s\n"
	.align  2

	.text
checksum:			//checksum will take in the buffer array and return the sum
   // str lr, [sp, #-16]!		//push lr onto the stack
    ldr w1,i			//i=0 in x1
   
   // mov x2,x0			//store buffer in x2, will return in x0
    ldr x2,sum			//put return var in x0
   // ldr x0,[x0]			//grab actual value of x0
loop:
  ldrb  w3,[x0,x1]		//w3=buffer[i]
  // cmp  x3,#0			//see if x3=0
   add  x2,x2,x3		//sum += buffer //changed 0 to 21
   add  x1,x1,#1		//i++
   cmp  x3,#0
   bne  loop			//repeat loop

   ldr  x20,=sum		//put sum address in x20
   str  x2,[x20]		//put x0 into sum addres
  // str lr, [sp, #16]		//end code
   ret			//return

	.global main
main:
    str lr, [sp, #-16]!
    ldr x0,=str1		//str1 stored in x0
    bl  printf			//print str1
    ldr x24,=buffer		//store buffer in x4
    ldr x25,i			//x5 = i
   
dowhile:
    bl  getchar			//getchar returns -1 EOF
   str  x0,[x24,x25]		//buffer[i] = getchar(x0)
   		
  // mov  x26,#4096		//x6 = 4096
  // sub  x26,x26,#1 		//x6 = 4096

   cmp  w0,#-1			// is buffer[i] != -1 //changed w to x
   beq done
   add x25,x25,#1			// i += 1
   cmp x25,#4095			// test i < 4096
   blt dowhile			//loop if i < 4096
done:
   mov x3,#0			//x3 has num 0
   str x3,[x24,x25]		//buffer[i] = 0

   ldr x0,=str3			//load str3 into x0
   ldr x1,=buffer		//load buffer into x1
    bl printf			//print stri1 and buffer

   ldr x0,=buffer		//load buffer into x0
    bl checksum			//run checksum with buffer
   ldr x1,sum			//move result of checksum into x1
   ldr x0,=str2			//move str2 into x0
    bl printf			//print output
   
   ldr x0,=buffer
    bl checksum
   ldr x1,sum
   ldr x0,=str2
    bl printf

   ldr lr, [sp], #16		//ending routine
   mov x0, #0			//load return val
   ret				//return from main
