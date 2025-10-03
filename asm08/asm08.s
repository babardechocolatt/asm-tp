
section .bss
buffer resb 32

section .text
global _start

_start:

mov rax, [rsp]
cmp rax, 2            ;programme + 1 arg
jne .error 

;récupérer argv[1]
mov rsi, [rsp+16]     ;rsi = adresse de l'argument

;conversion aschii -> entier (rax = N)
xor rax, rax          ;N = 0

.conv:
mov bl, byte [rsi]    
cmp bl, 0
je .conv_done
cmp bl, '0'           ;si < '0'
jb .error
cmp bl, '9'           ;si > '9'
ja .error 
sub bl, '0'           ; convertir en chiffre
imul rax, rax, 10     ;N = N*10
movzx rbx, bl
add rax, rbx          ;N +chiffre
inc rsi
jmp .conv

.conv_done:
mov rcx, rax       ; rcx = N
xor rdx, rdx       ; somme = 0
mov rbx, 1         ; i = 1

.sum_loop:
cmp rbx, rcx       ; i < N ?
jge .sum_done
add rdx, rbx       ; somme += i
inc rbx            ; i++
jmp .sum_loop


.sum_done:
;conversion somme > texte
mov rax, rdx            ;bvaleur à convertir
lea rdi, [buffer+31]    ;pointeur fin buffer
mov byte [rdi], 10      ;'\n' final
dec rdi

cmp rax, 0
jne .utoa
mov byte [rdi], '0'
mov rsi, rdi
lea rdx, [buffer+32]
sub rdx, rsi
jmp .print

.utoa:
mov rcx, 10

.conv_loop2:
xor rdx, rdx
div rcx                ; rax / 10, reste = rdx
add dl, '0'            ; reste -> chiffre
mov [rdi], dl
dec rdi
test rax, rax
jnz .conv_loop2
lea rsi, [rdi+1]       ; début de la chaîne
lea rdx, [buffer+32]
sub rdx, rsi           ; longueur

.print:

mov rax, 1             ; syscall write
mov rdi, 1             ; fd = stdout
syscall

   
mov rax, 60
xor rdi, rdi
syscall

.error:
mov rax, 60
mov rdi, 1
syscall
