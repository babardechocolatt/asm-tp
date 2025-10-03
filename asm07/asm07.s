
section .bss
buffer resb 32    ;résserve 32 octets

section .text 
global _start 

_start:

;lire entrée standard
mov rax, 0        ;syscall read
mov rdi, 0        ;stdin
mov rsi, buffer   ;ou stocker
mov rdx, 32       ;max 32 octets
syscall        

;convertion aschii
xor rax, rax      ;rax = nombre final
mov rsi, buffer   ;pointe sur buffer

.conv_loop:
mov bl, byte [rsi]    ;lire caractère
cmp bl, 10            ;fin si tombe sur '\n'
je .after_conv        ;sortie boucle

cmp bl, '0'           ;si caractère < '0'
jl .invalid_input
cmp bl, '9'           ;si caractère > '9'
jg .invalid_input

sub bl, '0'           ;conversion chiffre numérique
imul rax, rax, 10     ;déclarer
add rax, rbx          ;ajoute chiffre courant 
inc rsi               ;avancer
jmp .conv_loop

.after_conv:
mov rcx, 2            ;diviseur = 2
mov rbx, rax          ;rbx = copie nmbr original

cmp rbx, 2
jl .not_prime         ;si n < 2 -> pas premier
je .is_prime          ;si n = 2 -> premier direct

.check_loop:
cmp rcx, rbx
jge .is_prime         ;si tout les diviseurs testés < n -> premier

;faire division : rdx:rax /rcx
xor rdx, rdx          ;remettre reste à 0
mov rax, rbx          ;rax = nombre
div rcx               ;rax = quotient, rdx = reste

cmp rdx, 0            
je .not_prime         ;si reste = 0 ->pas premier

inc rcx               ;diviseur ++
jmp .check_loop

.is_prime:
mov rax, 60           ;syscall exit
xor rdi, rdi          ;code retour 0
syscall

.not_prime:
mov rax, 60           ;syscall exit
mov rdi, 1            ;code retour 1
syscall

.invalid_input:
mov rax, 60           ;syscall exit
mov rdi, 2            ;code retour 2 (erreur input)
syscall
