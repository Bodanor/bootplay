.intel_syntax noprefix
.code16

print_16:
    pusha

    mov ah, 0x0E
printloop:
    mov al, byte ptr[si]
    cmp al, 0
    je endloop
    int 0x10
    inc si
    jmp printloop

endloop:
    popa
    ret

print_new_line:
    pusha

    mov ah, 0x0E
    mov al, 0xd
    int 0x10

    mov al, 0xa
    int 0x10

    popa
    ret