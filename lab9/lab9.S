.data
prmt_desc:   .asciz  "This program will create a table for the equation f(x) = (x^3 - x^2 - 2x)/(((x-2)^4/11) + 3)\n"
prmt_xmin:   .asciz  "Enter the lower limit of x: "
prmt_xmax:   .asciz  "Enter the upper limit of x: "
prmt_nrow:   .asciz  "Enter the number of rows: "
prnt_row:    .asciz  "%lf - %lf\n"
scan_x:      .asciz  "%lf"
scan_num_row: .asciz  "%d"
lower:       .skip   8, 0
upper:       .skip   8, 0
diff:        .skip   8, 0
nrow:        .word   0

    .text
    .globl  main
main:
    stp     x29, lr, [sp, #-16]!
    stp     x20, X21, [sp, #-16]!
    stp     x22, X23, [sp, #-16]!
    stp     x24, X25, [sp, #-16]!
    
    // Tells the user the prompt
    adr     x0, prmt_desc
    bl      printf

    // Ask and scanf for x_lower
    adr     x0, prmt_xmin
    bl      printf
    adr     x0, scan_x
    adr     x1, lower
    bl      scanf

    // Ask and scanf for x_upper
    adr     x0, prmt_xmax
    bl      printf
    adr     x0, scan_x
    adr     x1, upper
    bl      scanf

    // Ask and scanf for num rows
    adr     x0, prmt_nrow
    bl      printf
    adr     x0, scan_num_row
    adr     x1, nrow
    bl      scanf

    // Calculates the value we are incrementing by
    adr     x0, lower
    ldr     d0, [x0]    // loads lower
    adr     x0, upper
    ldr     d1, [x0]    // loads upper
    fsub    d2, d1, d0  // diff = upper - lower
    adr     x0, nrow
    ldr     x0, [x0]
    scvtf   d0, x0      // converts nrow to a double
    fdiv    d2, d2, d0  // diff = diff / nrow
    adr     x0, diff    // saves it
    str     d2, [x0]

    // Loops for the amount of rows
    // for (int i = 0; i < nrows; i++)
    mov     w22, 0      // i = 0
loop:

    // Calculates the new x
    adr     x0, diff
    ldr     d0, [x0]
    scvtf   d1, w22     // converts i to a double
    fmul    d0, d1, d0  // x = diff*i
    adr     x0, lower
    ldr     d1, [x0]    // loads lower
    fadd    d0, d0, d1  // x = x + lower

    // calculates the top
    fmul    d1, d0, d0  // d1 = x * x
    fmul    d2, d1, d0  // d2 = d1 * x
    fsub    d1, d2, d1  // d1 = x^3 - x^2
    fmov    d2, 2.0 
    fmul    d2, d0, d2  // d2 = 2x
    fsub    d1, d1, d2  // d1 = x^3 - x^2 - 2x

    // Calculates the bottom
    fmov    d3, 2.0
    fsub    d2, d0, d3  // d2 = x - 2
    fmul    d2, d2, d2  // d2 = (x - 2)^2
    fmul    d2, d2, d2  // d2 = d2^2 = (x - 2)^4
    fmov    d3, 11.0
    fdiv    d2, d2, d3  // d2 = (x - 2)^4/11
    fmov    d3, 3.0
    fadd    d2, d2, d3  // d2 = (x - 2)^4/11 + 3

    // calculates the result
    fdiv    d1, d1, d2

    // Print the result
    adr     x0, prnt_row
    bl      printf

    add     w22, w22, 1 // i++
    adr     x1, nrow
    ldr     w1, [x1]
    cmp     w22, w1
    blt     loop

    ldp     x24, x25, [sp, #16]!
    ldp     x22, x23, [sp, #16]!
    ldp     x20, x21, [sp, #16]!
    ldp     x29, lr, [sp], #16
    mov     x0, #0
    ret
.end
