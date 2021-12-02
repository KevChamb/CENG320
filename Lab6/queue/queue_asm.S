# 1 "queue_asm.S"
# 1 "/home/pi/CENG_320/Labs/Lab6/queue//"
# 1 "<built-in>"
# 1 "<command-line>"
# 31 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 32 "<command-line>" 2
# 1 "queue_asm.S"

    .text
    .global _ZN5queue5enqueEi
    .global _ZN5queue5dequeERi


_ZN5queue5enqueEi:

    stp x29,lr, [sp, #-16]!

    mov x19, x0
    mov x20, x1

    bl _ZN5queue6isfullEv

    cmp x0, #1
    mov x0, #0
    beq quit

    ldr w23, [x19,#212]
    ldr w24, [x19,#216]
    str w20, [x19,x23,lsl#2]

    add x23, x23, #1
    mov x8, x23
    cmp x23, #52
    mov x23, #0
    bge endif

    mov x23, x8

endif:
    add x24,x24,#1
    str w23,[x19,#212]
    str w24,[x19,#216]
    mov x0, #1

quit:
    ldp x29, lr, [sp], #16
    ret
    .size _ZN5queue5enqueEi, (. - _ZN5queue5enqueEi)




_ZN5queue5dequeERi:

    stp x29, lr, [sp, #-16]!
    mov x21, x0
    mov x22, x1

    bl _ZN5queue7isemptyEv

    cmp x0, #1
    mov x0, #0
    beq quit2

    ldr w25, [x21, #208]
    ldr w26, [x21, #216]

    ldr w27,[x21, x25, lsl#2]

    add x25, x25, #1
    cmp x25, #52

    blt endif2
    mov x25, #0

endif2:
    sub x26, x26, #1

    str w25,[x21,#208]
    str w26, [x21, #216]
    mov x0, x27

quit2:
    ldp x29, lr, [sp], #16
    ret
    .size _ZN5queue5dequeERi, (. - _ZN5queue5dequeERi)
