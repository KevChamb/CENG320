	.data
str1:	.asciz "Enter text (ctrl-D to end): "
	.align 2
str2:	.asciz "\nThe checksum is %08X\n"
        .align 2
str3:	.asciz "%s\n"
	.align 2

	.text
checksum:
    mov x1,#0			//i=0 in x1
    mov x2,#0			//return value in x0

loop:
   ldrb w3,[x0,x1]		//w3 = buffer[i]
    add x2,x2,x3		//sum += buffer
    add x1,x1,#1		//i++
    cmp w3,#0			//comp if x3 = 0 (before add?)
    bne loop			//repeat loop
    mov x0,x2			

    ret

	.type main, %function
	.global main
main:
    str lr, [sp, #-16]!
    sub sp,sp,#4096
    
    ldr x0,=str1		//str stored in x0
     bl printf 
  								 // mov x4,sp
    mov w25,#0

dowhile:
     bl getchar			//getchar returns -1 on EOF
    str x0,[sp,x25]
  								// mov x6,#4096
    cmp x0,#-1
    beq done
    add x25,x25,#1		//i+=1
    cmp x25,#4095			// test < 4095
    blt dowhile			//loop if i < 4096 & buffer[i] != -1

done:
    mov x3,#0
    str x3,[sp,x5]		//buffer[i] = 0

    ldr x0,=str3		//load str3 into x0
    mov x1,sp			//load buffer from x4 to x1
     bl printf			//print str1 and buffer


    mov x0,sp			//loading x0 with buffer
     bl checksum		//run checksum with buffer
    mov x1,x0			//move result of checksum into x1
    ldr x0,=str2		//move str2 into x0
     bl printf 			//print output

    mov x0,sp
     bl checksum
    mov x1,x0			//load buffer into x0 from x4
    ldr x0,=str2
     bl printf			//print output

    add sp,sp,#4096
    ldr lr, [sp],#16
    mov x0, #0
    ret 
    
