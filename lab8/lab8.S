    .data
prmt_desc:   .asciz  "This program will create a table for the equation f(x) = (x^3 - x^2 - 2x)/(((x-2)^4/11) + 3)\n"
prmt_xmin:   .asciz  "Enter the lower limit of x: "
prmt_xmax:   .asciz  "Enter the upper limit of x: "
prmt_nrow:   .asciz  "Enter the number of rows: "
prnt_row:    .asciz  " - "
prnt_newlin: .asciz  "\n"
scan_x:      .asciz  "%s"
scan_num_row: .asciz  "%d"
lower:       .skip   8, 0
upper:       .skip   8, 0
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

    // Turns the strings into fixed points as S(15, 16)
    adr     x0, upper
    mov     w1, 16
    bl      strtoSfixed
    mov     w21, w0
    adr     x0, lower
    mov     w1, 16
    bl      strtoSfixed
    mov     w20, w0
    
    // Calcuates the value we are incrementing by
    sub     w0, w21, w20   // w23 = upper - lower, S(15, 16)
    adr     x1, nrow
    ldr     w1, [x1]
    lsl     x1, x1, 16      // Makes the integer into S(15, 16)
    lsl     x0, x0, 31      // Shifts the dividend by i2 (15) + f2 (16)
    sdiv    x0, x0, x1      // calculates diff/nrows, S(32, 31)
    asr     x23, x0, 15      // Goes back to S(15, 16)  

    // Loops for the amount of rows
    // for (int i = 0; i < nrows; i++)
    mov     w22, 0      // i = 0
loop:

    // Calculates the new x
    smull   x0, w22, w23    // x0 = i*diff, S(47, 16)
    add     w0, w0, w20     // Trims the top and add lower, S(15, 16)

    mov     w24, w0         // Saves x
    mov     w1, 16
    bl      printS
    adr     x0, prnt_row
    bl      printf

    // Calculates the top part equation
    mov     w0, w24
    smull   x1, w0, w0      // w1 = x^2, S(31, 32)
    asr     x1, x1, 16      // Goes back to S(15, 16)
    smull   x2, w1, w0      // w2 = x^3, S(31, 32)
    asr     x2, x2, 16      // Goes back to S(15, 16)
    sub     w1, w2, w1      // x^3 - x^2 = w2 - w1 = w1
    lsl     w2, w0, 1       // w2 = 2x
    sub     w1, w1, w2      // x^3 - x^2 - 2x = w1 - w2
    lsl     x1, x1, 32
    asr     x1, x1, 32

    // Calculates (x - 2)^4
    mov     w2, 2
    lsl     w2, w2, 16       // Turns 2 into a S(15, 16)
    sub     w2, w0, w2       // w2 = x - 2
    smull   x3, w2, w2       // w3 = (x - 2)^2, S(31, 32)
    asr     x3, x3, 16       // Goes back to S(15, 16)
    smull   x3, w3, w2       // w3 = (x - 2)^3, S(31, 32)
    asr     x3, x3, 16       // Goes back to S(15, 16)
    smull   x3, w3, w2       // w3 = (x - 2)^4, S(31, 32)
    asr     x2, x3, 16       // Goes back to S(15, 16)

    // Calculates (x - 2)^4/11 + 3
    mov     w3, 0x1745       // stores 1/11 into w3
    smull   x2, w3, w2       // w2 = (x - 2)^4/11, S(31, 32)
    asr     x2, x2, 16       // Goes back to S(15, 16)
    mov     w3, 3
    lsl     w3, w3, 16
    add     w2, w2, w3

    // Calculates f(x)
    lsl     x1, x1, 31      // Shifts the dividend by i2 (15) + f2 (16)
    sdiv    x0, x1, x2      // calculates top/bottom, S(32, 31)
    asr     x0, x0, 15      // Goes back to S(15, 16)

    // Prints the result
    mov     w1, 16
    bl      printS
    adr     x0, prnt_newlin
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
