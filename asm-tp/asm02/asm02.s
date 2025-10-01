section .data
msg db "1337", 10     ; 10 = '\n' ;"message qu’on affichera si input = "42" puis retour à la ligne \n"
len equ $ - msg       ; "longueur du msg"

section .bss          ;.bss sert à dire : “je veux un espace mémoire dispo pour stocker des données pendant l’exécution”.
    buffer resb 10    ;"buffer = c’est le label (un nom) → tu pourras l’utiliser comme adresse. resb 10 = reserve byte → réserve 10 octets.Donc buffer est une zone mémoire de 10 cases vides que tu peux remplir avec ce que l’utilisateur tape."

section .text    ; "le programme (les instructions que le processeur doit exécuter)"
global _start    ;"Le point d’entrée de mon programme s’appelle _start, et je rends ce label visible à l’éditeur de liens (ld) pour qu’il sache où commencer l’exécution."

_start: 

mov rax, 0        ;syscall read
mov rdi, 0        ;stdin
mov rsi, buffer   ;adresse où écrire
mov rdx, 10       ;max 10 octets
syscall


mov al, byte [buffer] ;mettre le premier caractère (1 octet) dans AL
cmp al, '4'  ;comparer à '4'
jne not_equal  ;si différent de '4' > aller à "not_equal"

mov al, byte [buffer+1] ;lire le deuxième caractère
cmp al, '2'   ;comparer à '2'
jne not_equal   ; si différent '2' >aller à "not_equal"

;si tout est bon>afficher 1337 >écrire msg vers stdout

mov rax, 1  ;syscall write 
mov rdi, 1  ;stdout
mov rsi, msg ; adresse de message
mov rdx, len  ;longueur
syscall
;exit 0
mov rax, 60
xor rdi, rdi 
syscall

;sinon>exit1

not_equal: 
mov rax, 60
mov rdi, 1  ; code retour 1
syscall
