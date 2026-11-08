global _start

section .data
    server_addr:
        dw 2
        dw 0x3905
        dd 0x0100007f
        dq 0

    filename db "messages", 0

section .bss
    buffer resb 1024

section .text

_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 2
    xor rdx, rdx
    syscall

    test rax, rax
    js .exit_error

    mov r12, rax

    mov rax, 49
    mov rdi, r12
    mov rsi, server_addr
    mov rdx, 16
    syscall

    test rax, rax
    js .exit_error

    mov rax, 2
    mov rdi, filename
    mov rsi, 1089
    mov rdx, 420
    syscall

    test rax, rax
    js .exit_error

    mov r13, rax

.receive:
    mov rax, 45
    mov rdi, r12
    mov rsi, buffer
    mov rdx, 1024
    xor r10, r10
    xor r8, r8
    xor r9, r9
    syscall

    test rax, rax
    js .exit_error

    mov r14, rax

    mov rax, 1
    mov rdi, r13
    mov rsi, buffer
    mov rdx, r14
    syscall

    test rax, rax
    js .exit_error

    jmp .receive

.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall