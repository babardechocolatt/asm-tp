
section .data
msg db "1337", 10     ; 10 = '\n' ;"reserve les 5 casesz mémoire et y met les valeurs des caractères puis retour à la ligne \n"
len equ $ - msg     ;"longueur calculée à l’assemblage (=5)"

section .text    ; "le programme (les instructions que le processeur doit exécuter)"
global _start    ;"Le point d’entrée de mon programme s’appelle _start, et je rends ce label visible à l’éditeur de liens (ld) pour qu’il sache où commencer l’exécution."

_start:          ;"sera la toute première ligne exécutée."

mov rax, 1       ;"syscall: 1: write"
mov rdi, 1       ;"je veux écrire vers stdout (l’écran)."
mov rsi, msg     ;"je veux écrire le texte stocké à l’adresse msg."
mov rdx, len     ;"correspond à notre constante/combien d’octets écrire" 
syscall

mov rax, 60      ; syscall: exit
xor rdi, rdi     ; code retour = 0 (met rdi à 0)
syscall