section .text
    global _start

_start:
    mov rdi, 0      ; code retour = 0 (1er argument du syscall)
    mov rax, 60     ; numéro du syscall exit
    syscall         ; appel système
