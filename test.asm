[bits 32]

section .data

program db "Program: ", 0
programlen equ $-program

nl db "", 13, 10, 0
nllen equ $-nl

section .bss

buf resd 1
argc resd 1
argv resb 255

section .text

global Start
extern GetStdHandle
extern __getmainargs
extern WriteConsoleA
extern ExitProcess

strlen:             ; eax: a string ending in 0
push eax            ; cache eax

.strloop:

mov bl, byte [eax]
cmp bl, 0
je .strret          ; return len if bl == 0
inc eax             ; else eax++
jmp .strloop

.strret:

pop ebx             ; ebx = cached eax
sub eax, ebx        ; eax -= ebx
ret                 ; eax = len

Start:

push 0
push buf
push argv
push argc
call __getmainargs
add esp, 16         ; clear stack (4 * 4 arguments)

push -11            ; get stdout
call GetStdHandle
mov esi, eax
add esp, 4          ; clear stack (4 * 1 argument)

push 0              ; null
push buf            ; [chars written]
push programlen
push program
push esi            ; stdout
call WriteConsoleA
add esp, 20         ; clear stack (4 * 5 arguments)


; [argv] = argv[0]
mov edx, [argv]
mov eax, [edx]   ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
call strlen
push 0              ; null
push buf            ; [chars written]
push eax            ; len argv[0]
push dword [edx]    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<       ; argv[0]
push esi            ; stdout
call WriteConsoleA
add esp, 20         ; clear stack (4 * 5 arguments)


; [argv+4] = argv[1]
mov edx, [argv]
add edx, 4
mov eax, [edx]   ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
call strlen
push 1              ; null
push buf            ; [chars written]
push eax            ; len argv[0]
push dword [edx]    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<       ; argv[0]
push esi            ; stdout
call WriteConsoleA
add esp, 20         ; clear stack (4 * 5 arguments)

push 0              ; null
push buf            ; [chars written]
push nllen
push nl
push esi            ; stdout
call WriteConsoleA
add esp, 20         ; clear stack (4 * 5 arguments)

push 0
call ExitProcess