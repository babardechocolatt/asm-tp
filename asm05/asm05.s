section .data
newline db 10

section .text
global _start

_start:

mov rbx, [rsp]   ;rbx = nombre d’arguments passés au programme (argc)/x: ./asm05 "Hello" → argc = 2
cmp rbx, 2       ;est-ce que argc < 2 ?
jb .no_param

          ;récupérer argv[1] (premier argument utilisateur)
mov rsi, [rsp+16]  ;adresse mémoire tu text user

;calcul du nombre de caractèe dans le texte 
;besoin de la longueur pour l'afficher

xor rdx, rdx   ;on met rdx à 0, ça va nous servir de compteur

.count:
cmp byte [rsi +rdx], 0  ;on regarde le caractère à l'adresse (rsi+rdx)/si 0 fin de texte
je .print   ;si à la fin, saute à l'étape print
inc rdx     ;sinon augmente compteur 
jmp .count  ;recommence avec le caractère suivant

.print:
      ;demander à linux d'afficher le texte
mov rax, 1    ;syscall write
mov rdi, 1    ;stdout
syscall

;afficher retour à la ligne 
mov rax, 1
mov rdi, 1
lea rsi, [rel newline]
mov rdx, 1
syscall

;quitter proprement
mov rax, 60      ;exit
xor rdi, rdi     ;code retour 0, rdi O
syscall

.no_param:
mov rax, 60
mov rdi, 1                ; code retour = 1
syscall
