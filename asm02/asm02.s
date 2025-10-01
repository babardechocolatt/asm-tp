section .data
msg db "1337", 10
len equ $ - msg

section .bss
buffer resb 10

section .text
global _start

_start:
    ; read(stdin, buffer, 10)
    mov rax, 0        ; syscall read
    mov rdi, 0        ; stdin
    mov rsi, buffer   ; adresse du buffer
    mov rdx, 10       ; max 10 octets
    syscall           ; RAX = nb d’octets lus

    ; sauvegarder nb d’octets lus
    mov rcx, rax      


    ; Vérifier qu’on a au moins 2 caractères
    cmp rcx, 2
    jl not_equal

    ; Vérifier '4'
    mov al, [buffer]
    cmp al, '4'
    jne not_equal

    ; Vérifier '2'
    mov al, [buffer+1]
    cmp al, '2'
    jne not_equal

    ; Cas pile "42"
    cmp rcx, 2
    je ok_print

    ; Cas "42\n"
    cmp rcx, 3
    jne not_equal
    mov al, [buffer+2]
    cmp al, 10        ; '\n'
    jne not_equal

ok_print:
    ; write(stdout, msg, len)
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

not_equal:
    ; exit(1)
    mov rax, 60
    mov rdi, 1
    syscall
