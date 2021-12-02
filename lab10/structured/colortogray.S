
### Definitions for pixel and image data structure

	.equ 	p_red,	 	0
	.equ	p_green,	1
	.equ	p_blue,		2
	//.equ	p_size,		3

	.equ	i_width,	8
	.equ	i_height,	12
	.equ	i_pixels,	0
	//.equ	i_size,		12

/* color_to_gray will allocate a new grayimage structure and fill it
   with the grayscale equivalent of the given image.

   The C prototype is:

   grayimage *color_to_gray(rgbimage *image);

*/

	.global	color_to_gray
color_to_gray:
	stp		x29, lr, [sp, #-16]!

	/* Fill in the code to allocate a new grayimage, then convert
	   each pixel from the given rgbimage from color to grayscale,
	   and store it in the grayimage. */

	mov		x29, x0					// Saves the colored pointer

	ldr		w0, [x29, #i_width]		// Loads the width and height
	ldr		w1, [x29, #i_height]	
	bl		allocate_grayimage		// allocate_grayimage(width, height)

	ldr		w1, [x29, #i_width]		// Loads the width and height
	ldr		w2, [x29, #i_height]
	and		w3, w1, 7				// w3 = width % 8
	sub		w1, w1, w3				// w1 = width - (width % 8)
	ldr		x14, [x29, #i_pixels]	// x14 = rgb->pixels
	ldr		x15, [x0, #i_pixels]	// x15 = gray->pixels

	// Creates all of the constants to multiply by
	mov		w10, 54
	mov		w11, 184
	mov		w12, 18
	dup		v3.8b, w10				// Fills vectors of the corresponding values
	dup		v4.8b, w11
	dup		v5.8b, w12

	// This loop that will handle each row
	// while (i < height)
	mov		w4, wzr					// i = 0
rowLoop:
	cmp		w4, w2					// cmp i and height
	bge		end_rowLoop				// End of calculating

	// Loads the pointer to the row 
	ldr		x16, [x14, x4, lsl 3]
	ldr		x17, [x15, x4, lsl 3]

	mov		w5, w1					// j = width

	// Loads and caculates 8 pixels at a time
	// While (j > 0)
row8Loop:
	cmp		w5, wzr
	ble		end_row8Loop

	// Loads in the structure, multiples and add
	ld3		{v0.8b, v1.8b, v2.8b}, [x16], 24	// Loads 8 pixels, storing all red in v0, green in v1, and blue in v2
	umull	v7.8h, v0.8b, v3.8b					// v3 = 54 * red
	umlal	v7.8h, v1.8b, v4.8b					// v3 += 184 * green
	umlal	v7.8h, v2.8b, v5.8b					// v3 += 18 * blue

	// Does the divide
	uqshrn	v7.8b, v7.8h, 8						// v3 /= 256 and narrows

	// Stores them
	st1		{v7.8b}, [x17], 8

	sub		w5, w5, 8							// j -= 8
	b		row8Loop

end_row8Loop:

	// Calculates the remaining pixels
	// while (j >= 0)
	mov		w5, w3								// j = width % 8
fillRestLoop:
	cmp		w5, w3		
	blt		end_fillRestLoop

	// Load and calculate
	ldrb	w6, [x16], 1		// loads red
	ldrb	w7, [x16], 1		// loads green
	ldrb	w8, [x16], 1		// loads blue
	mul		w9, w6, w10
	madd	w9, w7, w11, w9
	madd	w9, w8, w12, w9
	lsr		w9, w9, 8			// gray /= 256

	// Store
	strb	w9, [x17], 1

	sub		w5, w5, 1			// j--
	b		fillRestLoop

end_fillRestLoop:

	add		w4, w4, 1			// i++

	// Go to next row
	b		rowLoop

end_rowLoop:

	ldp		x29, lr, [sp], #16
	ret
