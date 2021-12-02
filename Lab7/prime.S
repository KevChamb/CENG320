/*********************************************************************
* prime.S
*
* Kevin Chamberlain
*
* Tue Oct 19, 2021
*
* This is a program that takes an interger from the user and prints
* out the prime numbers between 1 and that integer. The program will
* then output the amout of prime numbers between 1 and the integer.
*
* It should be compiled and linked as follows:
* 	gcc -o prime prime.S
*
* gcc will call the assembler and linker, telling the linker to include
* the C standard library in the executable program.
*********************************************************************/
	.data
prmptstr:
	.asciz	"Enter a natural number: "
outputstr:
	.asciz	"The number of primes between 1 and %d is: %d\n"
fmtstr:	.asciz	"%d\n"
scanstr:.asciz	"%d"
n:	.word	0	
	.text
	.type	main, function
	.global	main
main:	
	stp	x29, x30, [sp, #-16]!	// save lr and fp
	stp	x19, x20, [sp, #-16]!	// save non-volatile registers
	stp	x21, x22, [sp, #-16]!	// save non-volatile registers

	adr	x0, prmptstr		// print out prompt
	bl	printf			// call printf
	adr	x0, scanstr		// load address of scanstr
	adr	x1, n			// load address of n
	bl	scanf			// call scanf
	mov	w19, #2			// move i = 1 into x19
	mov	w20, #0			// x20 holds count
	adr	x21, n			// get address of n
	ldr	w21, [x21]		// load value of n into w21
	// x0 holds function input/output
mainfor:
	cmp	w19, w21		// compare i to n
	bge	returnmain		// end loop if i >= n
	mov	w0, w21			// move i to x0
	bl	isprime			// call isprime
	cbnz	x0, foundprime		// compare output of isprime to 0
endmainloop:
	add	w19, w19, #1		// i++
	b	mainfor			// repeat loop

foundprime:
	add	w20, w20, #1		// increment count
	adr	x0, fmtstr		// load address of fmtstr
	mov	w1, w19			// move i into w1
	bl	printf			// call printf
	b	endmainloop		// branch to endmainloop
	
returnmain:
	adr	x0, outputstr		// load address of outputstr
	mov	w1, w21			// move value of n into x1
	mov	w2, w20			// move value of count into x2
	bl	printf
	ldp	x21, x22, [sp], #16
	ldp	x19, x20, [sp], #16
	ldp	x29, x30, [sp], #16
	ret

	.type	divide, %function
	.global divide
/*divide divides the divdend in x0 by the divisor in x1.
 *It returns the quotient in x0 and the remainder in x1.*/
divide:
	stp	x29, x30, [sp, #-16]!	// save lr and frame pointer
	cbnz	x1, endif1		// if (divisor == 0)
	mov	x0, #0			// return 0
	mov	x1, #0
	b	return1
endif1:
	clz	x2, x1			// x2 = count
	lsl	x1, x1, x2		// divisor <<= count
	mov	x3, #0			// x3 = quotient
	add	x2, x2, #1		// x2 = count+1
divloop:
	lsl	x3, x3, #1		// Shift 0 into quotient LSB
	cmp	x0, x1			
	blo	endif2			// if(dividend >= divisor)
	orr	x3, x3, #1		// Set LSB of quotient
	sub	x0, x0, x1		// dividend -= divisor
endif2:
	sub	x2, x2, #1		// Decrement count
	lsr	x1, x1, #1		// Shift divisor right
	cbnz	x2, divloop		// while (count+1 != 0)
	mov	x1, x0			// remainder is the dividend
	mov	x0, x3			// return quotient
return1:
	ldp	x29, x30, [sp], #16	// restore lr and frame pointer
	ret
	.size	divide, (. - divide)



	// bool isprime(int x);
	// returns 0 if not prime
	// returns 1 if prime
	.type 	isprime, %function
	.global	isprime
isprime:
	stp	x29, x30, [sp, #-16]!	// save lr and frame pointer
	stp	x19, x20, [sp, #-16]!

	//base cases x <= 0 and x = 1 and x = 2
	cmp	w0, #1			// if x0 = 0
	ble	notprime		// if x <= 1, it is not prime
	cmp	w0, #2			// compare x0 to 2
	beq	prime			// if x == 2, it is prime
	mov	w20, #2			// store i = 2 in w20
	mov	w21, w0			// w21 holds dividend

	// start our loop knowing x > 2
	// x19 holds x or dividend
	// x20 holds i
for:	cmp	w20, w19		// compare i to dividend
	bge	prime			// if i >= dividend, end loop
	mov	w0, w19			// pass dividend as first parameter
	mov	w1, w20			// pass divisor as second argument
	bl	divide			// divide dividend/i
	cbz	w1, notprime		// if remainder = 0, number is not prime
	add	w20, w20, #1		// i++
	b	for
prime:
	mov	w0, #1			// return 1 if prime
	b	return2

notprime:
	mov	w0, #0			// return 0 if not prime
	b	return2

return2:
	ldp	x19, x20, [sp], #16
	ldp	x29, x30, [sp], #16
	ret
	.size	isprime, (. - isprime)


