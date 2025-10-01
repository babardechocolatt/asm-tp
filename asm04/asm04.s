section .bss
buffer resb 32   ;réserve 32 octets en mémoire pour stocker l'entrée clavier

section .text
global _start

_start:

mov rax, 0         ;syscall number 0 = read
mov rdi, 0         ;fichier décris 0 = stdin
mov rsi, buffer    ;adresse mémoire ou stocker ce qu'on lit
mov rdx, 32        ;max 32 octets
syscall

xor rbx, rbx       ;on met rbx = 0, ce sera notre nombre final
mov rcx, buffer    ;rcx = pointeur qui lit caractère par caractère

mov al, [buffer]   ;récupère le premier caractère 

;vérifier si caractère chiffre
cmp al, '0'        ;compare avec '0'
jb .invalid        ;si plus petit>invalid
cmp al, '9'        ;compare avec '9'
ja .invalid        ;si plus grand>invalid

;transforme caractère nombre
sub al, '0'        ;décallage aschii
movzx rbx, al      ;stock nombre dans rbx



;tester si pair ou impair
mov rax, rbx
test rax, 1        ;regarde le dernier bit
jz .even           ;si 0>pair

.odd: ;sortie impair 
mov rax, 60        ;syscall exit   
mov rdi, 1         ; code retour  impair
syscall

.even: ;sortie pair
mov rax, 60       ; syscall exit
xor rdi, rdi     ; code retour 0 = pair
syscall

.invalid:     ;entrée invalide
mov rax, 60
mov rdi, 2    ;code retour 2
syscall
