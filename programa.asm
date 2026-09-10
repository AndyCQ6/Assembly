section .data
    hola db "Hola, mundo!", 0Ah
    longitud equ $ - hola

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, hola
    mov rdx, longitud
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
