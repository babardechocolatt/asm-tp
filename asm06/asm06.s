section .data
    error_msg db "Error: need 2 arguments", 10
    error_len equ $ - error_msg

section .bss

section .text
    global _start

_start:
    ; Vérifier le nombre d'arguments
    pop rdi                 ; argc
    cmp rdi, 3              ; Il faut 3 (programme + 2 args)
    jne .error              ; Sinon erreur
    
    pop rdi                 ; nom programme
    pop rdi                 ; 1er argument
    pop rsi                 ; 2ème argument

    ; Conversion 1er nombre (avec signe)
    call atoi
    mov r12, rax

    ; Conversion 2ème nombre (avec signe)
    mov rdi, rsi
    call atoi
    mov r13, rax

    ; Addition
    mov rax, r12
    add rax, r13

    ; Affichage (avec signe si négatif)
    mov rdi, rax
    call print_number

    ; Nouvelle ligne
    mov rdi, 10
    call print_char

    ; Exit succès
    mov rax, 60
    xor rdi, rdi
    syscall

.error:
    ; Afficher message d'erreur
    mov rax, 1
    mov rdi, 2              ; stderr
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    
    ; Exit avec code 1
    mov rax, 60
    mov rdi, 1
    syscall


; Convertit string en nombre (gère le signe -)
atoi:
    xor rax, rax
    xor rcx, rcx
    xor r8, r8              ; r8 = flag négatif (0 = positif, 1 = négatif)
    
    ; Vérifier si le nombre commence par '-'
    movzx rcx, byte [rdi]
    cmp rcx, 45             ; '-' = ASCII 45
    jne .loop
    mov r8, 1               ; C'est négatif
    inc rdi                 ; Passer le '-'

.loop:
    movzx rcx, byte [rdi]
    cmp rcx, 48
    jl .done
    cmp rcx, 57
    jg .done
    sub rcx, 48
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .loop

.done:
    ; Si négatif, inverser le signe
    test r8, r8
    jz .positive
    neg rax                 ; rax = -rax

.positive:
    ret


; Affiche un nombre (gère les négatifs)
print_number:
    mov rax, rdi
    
    ; Si négatif, afficher '-' et prendre la valeur absolue
    test rax, rax
    jns .positive           ; Si positif, continuer
    
    push rax
    mov rdi, 45             ; '-' = ASCII 45
    call print_char
    pop rax
    neg rax                 ; Prendre la valeur absolue

.positive:
    mov rcx, 10
    push 0
    
.divide:
    xor rdx, rdx
    div rcx
    add rdx, 48
    push rdx
    test rax, rax
    jnz .divide
    
.print:
    pop rdi
    test rdi, rdi
    jz .done
    call print_char
    jmp .print
    
.done:
    ret


; Affiche un caractère
print_char:
    push rdi
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rdi
    ret
