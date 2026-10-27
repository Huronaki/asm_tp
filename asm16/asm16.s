global _start

section .bss
    header resb 5

section .text

_start:
    cmp qword [rsp], 2
    jne .exit_argument_error

    mov rax, 2
    mov rdi, [rsp + 16]
    xor rsi, rsi
    syscall

    test rax, rax
    js .exit_argument_error

    mov r8, rax

    mov rax, 0
    mov rdi, r8 
    lea rsi, [rel header]
    mov rdx, 5
    syscall

    cmp rax, 5
    jne .exit_not_binary

    mov rax, 4
    mov rdi, r8
    syscall

    cmp byte [header], 0x7F
    jne .exit_not_binary

    cmp byte [header + 1], 'E'
    jne .exit_not_binary

    cmp byte [header + 2], 'L'
    jne .exit_not_binary

    cmp byte [header + 3], 'F'
    jne .exit_not_binary

    cmp byte [header + 4], 2
    jne .exit_not_binary

    .exit_binary:
    mov rax, 60
    mov rdi, 0
    syscall

    .exit_not_binary:
    mov rax, 60
    mov rdi, 1
    syscall

    .exit_argument_error:
    mov rax, 60
    mov rdi, 2
    syscall

