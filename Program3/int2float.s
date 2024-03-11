    .text
    .align 2
    .global main
main:
    stmfd sp!, {fp, lr}
    stmfd sp!, {r4-r11}
    ldr r3, [r1, #4]
    mov r4, #0 @ for "counting".
    mov r10, #0 @ store the transferred "decimal" num.

    ldrb r11, [r3], #1  @ LOAD "characters" into r11.
    b DETERMINE_digits
LOOP:
    ldrb r11, [r3], #1  @ LOAD "characters" into r11.
ctn:
    add r4, r4, #1  @ counter ++
    cmp r11, #0  @ if "end of argument", exit LOOP.
    bne LOOP
    sub r4, r4, #1
    mov r5, r4 @ for recording how many "bits".
    ldrb r11, [r3], #-2
string2decimal:
    ldrb r11, [r3], #-1
    b start_DETERMINE_digits
ifEND:
    sub r4, r4, #1  @ counter--
    cmp r4, #0  @ if counter(r4) = 0, means no characters, END.
    bne string2decimal

printNum_S:
    mov r1, r10
    ldr r0, =string
    bl printf
    mov r0, r9
    bl putchar

@ E
findE: @ in "r9"!!!
    mov r9, #0
    mov r11, r10 @ copying r10 to protect the data.
Rotate:
    lsr r11, r11, #1
    add r9, r9, #1 @ for "E".
    cmp r11, #1
    beq printInBinary_E
    b Rotate
printInBinary_E: @ eg. 10001001.
    mov r8, r9 @ copying r9 to protect "E".
    add r8, r8, #127
    ldr r3, ='1'
    ldr r4, ='0'
    mov r5, #8
NEXTbit_E:
    cmp r5, #0
    beq OUTPUT_E
    and r7, r8, #0x01
    cmp r7, #1
    sub r5, r5, #1
    lsr r8, r8, #1
    beq pushOne_E
    b pushZero_E
pushOne_E:
    push {r3}
    b NEXTbit_E
pushZero_E:
    push {r4}
    b NEXTbit_E
OUTPUT_E:
    mov r5, #8
popStack_E:
    cmp r5, #0
    beq findM
    pop {r0}
    bl putchar
    sub r5, r5, #1
    b popStack_E

@ M
// r10(num): protected.
// r9(E): protected.
// r3 ='1'
// r4 ='0'
findM:
    rsb r5, r9, #23 @ for counting # of '0' to output.
pushZeros_M:
    cmp r5, #0
    beq otherM
    push {r4}
    sub r5, r5, #1
    b pushZeros_M
otherM:
    mov r5, r9
NEXTbit_M:
    cmp r5, #0
    beq OUTPUT_M
    and r7, r10, #0x1
    cmp r7, #1
    sub r5, r5, #1
    lsr r10, r10, #1
    beq pushOne_M
    b pushZero_M
pushOne_M:
    push {r3}
    b NEXTbit_M
pushZero_M:
    push {r4}
    b NEXTbit_M
OUTPUT_M:
    mov r6, #23
popStack_M:
    cmp r6, #0
    beq END
    pop {r0}
    bl putchar
    sub r6, r6, #1
    b popStack_M

/////////////////////////////

@ r0, r4, r5, r10: protected.

DETERMINE_digits:
    cmp r11, #'N'
    beq STORE_S_1
    b STORE_S_0

start_DETERMINE_digits:
    sub r8, r5, r4
    add r8, r8, #1
    cmp r8, #1
    beq ones
    cmp r8, #2
    beq tens
    cmp r8, #3
    beq hundreds
    cmp r8, #4
    beq thousands
    cmp r8, #5
    beq ten_thousands
    cmp r8, #6
    beq hundred_thousands
    cmp r8, #7
    beq thousand_thousands
    cmp r8, #8
    beq _E
    cmp r8, #9
    beq _10E
    cmp r8, #10
    beq _100E

DETERMINE_num:
    cmp r11, #'N'
    beq ifEND
    cmp r11, #'0'
    beq ifEND
    cmp r11, #'1'
    beq plus1
    cmp r11, #'2'
    beq plus2
    cmp r11, #'3'
    beq plus3
    cmp r11, #'4'
    beq plus4
    cmp r11, #'5'
    beq plus5
    cmp r11, #'6'
    beq plus6
    cmp r11, #'7'
    beq plus7
    cmp r11, #'8'
    beq plus8
    cmp r11, #'9'
    beq plus9

ones:
    mov r8, #1
    b DETERMINE_num
tens:
    mov r8, #10
    b DETERMINE_num
hundreds:
    mov r8, #100
    b DETERMINE_num
thousands:
    mov r8, #1000
    b DETERMINE_num
ten_thousands:
    ldr r8, =10000
    b DETERMINE_num
hundred_thousands:
    ldr r8, =100000
    b DETERMINE_num
thousand_thousands:
    ldr r8, =1000000
    b DETERMINE_num
_E:
    ldr r8, =10000000
    b DETERMINE_num
_10E:
    ldr r8, =100000000
    b DETERMINE_num
_100E:
    ldr r8, =1000000000
    b DETERMINE_num

plus1:
    mov r7, #1
    mul r6, r7, r8
    add r10, r10, r6
    b ifEND
plus2:
    mov r7, #2
    mul r6, r7, r8
    add r10, r10, r6
    b ifEND
plus3:
    mov r7, #3
    mul r6, r7, r8
    add r10, r10, r6
    b ifEND
plus4:
    mov r7, #4
    mul r6, r7, r8
    add r10, r10, r6
    b ifEND
plus5:
    mov r7, #5
    mul r6, r7, r8
    add r10, r10, r6
    b ifEND
plus6:
    mov r7, #6
    mul r6, r7, r8
    add r10, r10, r6
    b ifEND
plus7:
    mov r7, #7
    mul r6, r7, r8
    add r10, r10, r6
    b ifEND
plus8:
    mov r7, #8
    mul r6, r7, r8
    add r10, r10, r6
    b ifEND
plus9:
    mov r7, #9
    mul r6, r7, r8
    add r10, r10, r6
    b ifEND

STORE_S_1:
    ldr r0, ='-'
    bl putchar

    ldr r9, ='1'
    b ctn
STORE_S_0:
    ldr r9, ='0'
    b ctn

END:
	ldmfd 	sp!, {r4-r11}
	ldmfd	sp!, {fp, lr}
	bx	lr

string:
    .asciz "%d is coded by "