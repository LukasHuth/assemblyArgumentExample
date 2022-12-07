global _main
extern _printf

section .text
_main:
    push message
    call _printf
    add esp, 4

    ;push 0
    ;call _ExitProcess
    mov eax, 2
    ret
message:
    db  'Hello, World',10,0