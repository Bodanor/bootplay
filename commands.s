.intel_syntax noprefix
.code16

whoami:
    pusha
    mov si, offset flat:whoami_user
    call print_16
    popa
    ret

whoami_user:
    .asciz "root"