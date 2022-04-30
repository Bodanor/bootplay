.intel_syntax noprefix
.code16

stringCmp:
    pusha

stringCmpLoop:
    mov al, byte ptr[si]
    cmp al, byte ptr[di]
    jne stringCmpFail

    cmp al, 0
    je stringCmpReturnEqual

    inc si
    inc di
    jmp stringCmpLoop


stringCmpFail:
    cmp al, byte ptr[si]
    jl stringCmpReturnbelow

    cmp al, byte ptr[di]
    jg stringCmpReturnGreater

stringCmpReturnbelow:
    popa
    mov ax, -1
    jmp stringCmpReturn

stringCmpReturnGreater:
    popa
    mov ax, 1
    jmp stringCmpReturn

stringCmpReturnEqual:
    popa
    mov ax, 0

stringCmpReturn:
    ret
