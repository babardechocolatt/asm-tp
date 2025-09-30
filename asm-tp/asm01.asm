section .data
msg db "1337", 10     ; 10 = '\n'
len equ $ - msg

section .text
global _start

_start:
    mov rax, 1       ; syscall: write
    mov rdi, 1       ; fd = stdout
    mov rsi, msg     ; adresse du message
    mov rdx, len     ; longueur du message
    syscall

    mov rax, 60      ; syscall: exit
    xor rdi, rdi     ; code retour = 0
    syscall
