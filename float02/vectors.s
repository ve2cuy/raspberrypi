
.globl _start
_start:
    ldr pc,reset_handler
    ldr pc,undefined_handler
    ldr pc,swi_handler
    ldr pc,prefetch_handler
    ldr pc,data_handler
    ldr pc,unused_handler
    ldr pc,irq_handler
    ldr pc,fiq_handler
reset_handler:      .word reset
undefined_handler:  .word undef
swi_handler:        .word hang
prefetch_handler:   .word hang
data_handler:       .word hang
unused_handler:     .word hang
irq_handler:        .word hang
fiq_handler:        .word hang

reset:
    mov r0,#0x8000
    mov r1,#0x0000
    ldmia r0!,{r2,r3,r4,r5,r6,r7,r8,r9}
    stmia r1!,{r2,r3,r4,r5,r6,r7,r8,r9}
    ldmia r0!,{r2,r3,r4,r5,r6,r7,r8,r9}
    stmia r1!,{r2,r3,r4,r5,r6,r7,r8,r9}


    ;@ enable fpu
    mrc p15, 0, r0, c1, c0, 2
    orr r0,r0,#0x300000 ;@ single precision
    orr r0,r0,#0xC00000 ;@ double precision
    mcr p15, 0, r0, c1, c0, 2
    mov r0,#0x40000000
    fmxr fpexc,r0



    mov sp,#0x00200000
    bl notmain
hang: b hang


    .word 0
    .word 0
undef: b .
    .word 0
    .word 0


.globl PUT32
PUT32:
    str r1,[r0]
    bx lr

.globl GET32
GET32:
    ldr r0,[r0]
    bx lr

.globl dummy
dummy:
    bx lr


.globl start_l1cache
start_l1cache:
    mov r0, #0
    mcr p15, 0, r0, c7, c7, 0 ;@ invalidate caches
    mcr p15, 0, r0, c8, c7, 0 ;@ invalidate tlb
    mrc p15, 0, r0, c1, c0, 0
    orr r0,r0,#0x1000 ;@ instruction
    orr r0,r0,#0x0004 ;@ data
    mcr p15, 0, r0, c1, c0, 0
    bx lr

.globl stop_l1cache
stop_l1cache:
    mrc p15, 0, r0, c1, c0, 0
    bic r0,r0,#0x1000 ;@ instruction
    bic r0,r0,#0x0004 ;@ data
    mcr p15, 0, r0, c1, c0, 0
    bx lr

.globl m4add
m4add:
    vmov s0,r0
    vmov s1,r1
    vadd.f32 s2,s0,s1
    vmov r0,s2
    bx lr

.globl m4ftoi
m4ftoi:
    vmov s0,r0
    vcvt.s32.f32 s2,s0
    vmov r0,s2
    bx lr


.globl m4itof
m4itof:
    vmov s0,r0
    vcvt.f32.u32 s2,s0
    vmov r0,s2
    bx lr



