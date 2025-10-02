section .text
    global _start

_start:
    ; On récupère les arguments passés au programme (10 et 15)
    pop rdi                 ; argc (on s'en fiche)
    pop rdi                 ; nom du programme (on s'en fiche)
    pop rdi                 ; rdi pointe vers "10"
    pop rsi                 ; rsi pointe vers "15"

    ; On convertit "10" en nombre 10
    call atoi
    mov r12, rax           ; r12 = 10

    ; On convertit "15" en nombre 15
    mov rdi, rsi
    call atoi
    mov r13, rax           ; r13 = 15

    ; On additionne : 10 + 15 = 25
    mov rax, r12
    add rax, r13           ; rax = 25

    ; On affiche le résultat (25)
    mov rdi, rax
    call print_number

    ; On affiche un retour à la ligne
    mov rdi, 10
    call print_char

    ; On quitte le programme
    mov rax, 60
    xor rdi, rdi
    syscall

; Transforme une chaîne ASCII ("10") en entier (10)
atoi:
    xor rax, rax           ; rax = 0
    xor rcx, rcx
.loop_atoi:
    movzx rcx, byte [rdi]  ; Lit un caractère ('1' puis '0')
    cmp rcx, 48            ; Si < '0'
    jl .done_atoi
    cmp rcx, 57            ; Si > '9'
    jg .done_atoi
    sub rcx, 48            ; Convertit ASCII -> chiffre
    imul rax, rax, 10      ; Multiplie par 10
    add rax, rcx           ; Ajoute le chiffre
    inc rdi                ; Caractère suivant
    jmp .loop_atoi
.done_atoi:
    ret

; Affiche un entier (25 → "25")
print_number:
    mov rax, rdi
    mov rcx, 10
    push 0
    
.divide:
    xor rdx, rdx
    div rcx                ; RAX / 10, reste dans RDX
    add rdx, 48            ; Convertit en ASCII
    push rdx               ; Empile le chiffre
    test rax, rax
    jnz .divide
    
.print:
    pop rdi                ; Dépile chiffre
    test rdi, rdi
    jz .done_print
    call print_char
    jmp .print
.done_print:
    ret

; Affiche un caractère (dans RDI)
print_char:
    push rdi
    mov rax, 1             ; syscall write
    mov rdi, 1             ; stdout
    mov rsi, rsp           ; adresse du caractère
    mov rdx, 1             ; longueur = 1
    syscall
    pop rdi
    ret
