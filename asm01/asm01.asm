section .data
msg db "1337", 10
len equ $ - msg

section .text
global _start

_start:
    mov rax, 1      ; write
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    mov rax, 60     ; exit
    xor rdi, rdi
    syscall
