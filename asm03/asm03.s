section .data
msg db "1337", 10        ; chaîne à afficher "1337\n"
len equ $ - msg          ; longueur = 5

section .text
global _start
_start: 

mov eax, [rsp]
cmp eax, 2            ;Compare le contenu du registre rdi (qui contient le nombre d’arguments) avec la valeur 2.
jl exit_fail          ;Jump if less : si rdi < 2 (donc si pas assez d’arguments), on saute au label exit_fail.

mov rbx, [rsp+16]      ;récupère l’adresse du premier argument utilisateur (argv[1], ex "42")
mov al, byte [rbx]    ;charge le 1er caractère de l’argument dans al
cmp al, '4'           ;compare ce caractère avec '4'
jne exit_fail         ; si c'est pas '4', saute vers sortie erreur 


mov al, byte [rbx+1]  ;lire le deuxième caractère
cmp al, '2'           ;compare avec '2'
jne exit_fail         ;si ce n'est pas 2 (echec)
mov al, byte [rbx+2]  ;lire le troisième caractère
cmp al, 0             ;vérifie que c'est bien la fin de chaine
jne exit_fail         ;si ce n'est pas 0 (fin)>echec

mov rax, 1            ;syscall write
mov rdi, 1            ;sortie standard (stdout)
mov rsi, msg          ;adresse de "1337\n"
mov rdx, len          ;longueur = 5
syscall               ;éxecute l'écriture

mov rax, 60           ;syscall exit
xor rdi, rdi          ;rdi=0 (succès)/xor rdi, rdi = “mets zéro dans rdi”,
syscall               ;quitter

exit_fail: 
mov rax, 60           ;syscall exit
mov rdi, 1            ; code rertour 1=erreur
syscall

