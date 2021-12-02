  /******************************************************************************
* change.S
* "Find change" in ARM Assembly
*
* Kevin Chamberlain
*
* Tuesday Oct 19, 2021
*
* This program takes in 4 pecies of information where the user is asked for how
* many pennies, nickles, dimes, and quarters they have and caculates out the 
* average amount of change they have. 
*
*It shoould be compiled and linked as follows:
*   gcc -o change change.s
*
*gcc will call the assembler and linker, telling the linker to include the C 
*standard library in the executable program.
******************************************************************************/   

               .data

str1:           .asciz  "Enter the number of pennies, nickels, dimes, and quarters for a week %d: "
                .align 2
str2:           .asciz  "\nOver four weeks you have collected %d pennies, %d nickels, %d dimes and %d quarters.\n"
                .align 2
str3:           .asciz  "\n\nThis comes to $%d.%d\n"
                .align 2
str4:           .asciz  "Your weekly average is $%d.%d\n"
                .align 2
str5:           .asciz  "Your estimated yearly savings is $%d.%.2d\n"
                .align 2

input:         .asciz  "%d %d %d %d"

                

pen:            .word   0
nic:            .word   0

dime:           .word   0
quarter:        .word   0

                .text

                .type main, function
                .global main

main:
        stp     x29, lr, [sp, #-16]!
        stp     x20, x21, [sp, #-16]!
        stp     x22, x23, [sp, #-16]!
        stp     x24, x25, [sp, #-16]!

        mov     x20, #1             //The Week Counter
        mov     x21, #0             //The number of penneys
        mov     x22, #0             //The number of nickels
        mov     x23, #0             //The number of dimes
        mov     x24, #0             //The number of quarters

loop:
        cmp     x20, #5             //Compare the counter to 5
        beq     exit

        ldr     x0, =str1           //load the output message
        mov     x1, x20             //load the counter in x1
        bl      printf              //print the output message with the counter

        ldr     x0, =input          //load the input string in reg x0
        ldr     x1, =pen            //load the location of penney
        ldr     x2, =nic            //load the location of nickels
        ldr     x3, =dime           //load the location of dimes
        ldr     x4, =quarter        //load the location of quarters
        bl      scanf               //obtain the inputs

        ldr     x1, =pen            //load the location of penney
        ldrb    w1, [x1]            //load the value of the penny
        add     x21, x21, x1        //add the pennys together

        ldr     x2, =nic            //load the location of nickels
        ldrb    w2, [x2]            //load the value of the nickels
        add     x22, x22, x2        //add the nickels together

        ldr     x3, =dime           //load the location of dimes
        ldrb    w3, [x3]            //load the value of the dime
        add     x23, x23, x3        //add the dimes together

        ldr     x4, =quarter        //load the location of quarter
        ldrb    w4, [x4]            //load the value of the quarter
        add     x24, x24, x4        //add the quaters together

        add     x20, x20, #1        //increase the counter by 1
        b       loop                //loop back

exit:
        ldr     x0, =str2            //load the output message into x0
        mov     x1, x21             //load the value of pennys
        mov     x2, x22             //load the value of nickels
        mov     x3, x23             //load the value of dimes
        mov     x4, x24             //load the value of quarters
        bl      printf

        mov     x1, x22               //Move Nickles to x0
        lsl     x1, x1, #2
        add     x0, x1, x22
        mov     x22, x0               //store answer from multiplyNickles to x22

        mov     x1, x23 
        lsl     x1, x1, #2
        add     x1, x1, x23
        lsl     x1, x1, #1
        mov     x23, x1               //Store answer from multiply Dime to x23

        mov     x1, x24               //Move Quaters to x0
        add     x2, x1, x1
        add     x2, x2, x1
        lsl     x2, x2, #3
        add     x2, x2, x1
        mov     x24, x2
       

        mov     x20, #0                //load 0 into registart x0
        add     x20, x20, x21           //add pennies to x0
        add     x20, x20, x22           //add nickles to x0
        add     x20, x20, x23           //add dimes to x0
        add     x20, x20, x24           //add quarters to x0

        mov     x0, x20
        bl      divide
        mov     x18, x0
        mov     x19, x1

        ldr     x0, =str3
        mov     x1, x18
        mov     x2, x19
        bl      printf

        mov     x0, x20
        bl      average
        mov     x22, x0
        bl      divide
        mov     x2, x0
        mov     x3, x1

        ldr     x0, =str4
        mov     x1, x2
        mov     x2, x3
        bl      printf

        mov     x0, x22
        mov     x1, x22
        mov     x3, x22
        add     x22, x22, x22, lsl #5
        add     x22, x22, x0, lsl #4
        add     x22, x22, x1, lsl #1
        add     x0, x22, x0
        bl      divide
        mov     x2, x0
        mov     x3, x1

        ldr     x0, =str5
        mov     x1, x2
        mov     x2, x3
        bl      printf

        mov     x0, #0
        ldp     x24, x25, [sp], #16
        ldp     x22, x23, [sp], #16
        ldp     x20, x21, [sp], #16
        ldp     x29, lr, [sp], #16            
        ret


//function to seperate dollars and cents
        .type divide, function
        .global divide

divide:
        mov     x2, x0              //first number
        ldr     x3, =0x28F5C2A
        smull   x1, w3, w2
        asr     x0, x1, #32
        sub     x0, x0, x1, asr #63

        mov     x1, #100            //decimal
        mul     x4, x1, x0
        sub     x1, x2, x4

        ret

//function to calculate the average 
        .type average, function
        .global average

average:
        mov     x2, x0              //first number
        ldr     x3, =0x40000000
        smull   x1, w3, w2
        asr     x0, x1, #32
        sub     x0, x0, x1, asr #63

        ret








