.intel_syntax noprefix
.code16
.text

.global _start
_start:
    jmp _start_16
    nop
    .space 59, 0

_start_16:
    ljmp 0x0000:_init

_init:
cld
mov bp, 0x9000
mov sp, bp

xor ax, ax
mov es, ax
mov ss, ax
mov ds, ax
mov fs, ax
mov gs, ax


cli

mov cx, 0   /* Couter to increment BX at every new input */
sub sp, 128 /* Make space on the stack for user input */


loop:
    mov si, offset flat:PWD
    call print_16
    mov bx, sp  /* BX will hold sp, as we are limited in 16-bit mode, so it's going to be our base index */

loopInput:

    /* Ask user for input */
    mov ah, 0x00
    int 0x16

    /* Check for Enter key */
    cmp al, 0xd
    je return_line

    cmp al, 0x8
    je delete_input
    /* Print input's user */
    mov ah, 0x0E
    int 0x10

    jmp iterate

return_line:

    mov byte ptr[bx], 0

    call print_new_line


    sub bx, cx  /* Get to the beginning of the buffer and start reading from there */
    mov si, bx  /* SI will have the buffer and will be compared to DI. */

    /* Whoami command */
    mov di, offset flat:WHOAMI_CMD
    call stringCmp
    cmp ax, 0
    je call_whoami

    /* Reboot Command */
    mov di, offset flat:REBOOT_CMD
    call stringCmp
    cmp ax, 0
    je call_reboot

    /* Halt command */
    mov di, offset flat:HALT_CMD
    call stringCmp
    cmp ax, 0
    je call_halt

    /* Shutdown command */
    mov di, offset flat:SHUTDOWN_CMD
    call stringCmp
    cmp ax, 0
    je call_halt


    cmp cx, 0
    jne command_not_found
    jmp new_buffer



call_whoami:

    call whoami
    call print_new_line
    jmp new_buffer

call_reboot:
    call reboot
    call print_new_line
    jmp new_buffer

call_halt:
    call halt
    call print_new_line

command_not_found:
    /* Command Not found */
    mov si, offset flat:NOT_FOUND_CMD
    call print_16

    call print_new_line
    /* Empty the buffer and wait for another command */
    
new_buffer:
    xor cx, cx
    jmp loop

delete_input:
    
    cmp cx, 0
    je loopInput

    dec cx
    dec bx
    mov byte ptr[bx], 0

    mov ah, 0x0E
    mov al, 0x8
    int 0x10

    mov ah, 0x0E
    mov al, 0
    int 0x10

    mov ah, 0x0E
    mov al, 0x8
    int 0x10

    jmp loopInput




iterate:
    mov byte ptr[bx], al
    inc bx
    inc cx

    jmp loopInput

.include "print.s"
.include "util.s"
.include "commands.s"
.include "sys.s"

PWD:
    .asciz "CMD >> "

WHOAMI_CMD:
    .asciz "whoami"

REBOOT_CMD:
    .asciz "reboot"

NOT_FOUND_CMD:
    .asciz "Commmand not found."

SHUTDOWN_CMD:
    .asciz "shutdown"
HALT_CMD:
    .asciz "halt"

DEBUG:
    .asciz "DEBUG"

. = _start + 510

.word 0xaa55
