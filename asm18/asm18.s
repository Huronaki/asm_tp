global _start

section .data
    request db "Hello"

    server_addr:
        dw 2
        dw 0x3905
        dd 0x0100007f
        dq 0

    timeout:
        dq 1
        dq 0

section .bss
    buffer resb 1024

section .text

_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 2
    mov rdx, 0
    syscall

    test rax, rax
    js .exit_error

    mov r12, rax

    mov rax, 54
    mov rdi, r12
    mov rsi, 1
    mov rdx, 20
    mov r10, timeout
    mov r8, 16
    syscall

    test rax, rax
    js .exit_error

    mov rax, 44
    mov rdi, r12
    mov rsi, request
    mov rdx, 5
    mov r10, 0
    mov r8, server_addr
    mov r9, 16
    syscall

    test rax, rax
    js .exit_error

    mov rax, 45
    mov rdi, r12
    mov rsi, buffer
    mov rdx, 1024
    mov r10, 0
    mov r8, 0
    mov r9, 0
    syscall

    test rax, rax
    js .timeout_error

    mov r13, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r13
    syscall

    mov rax, 3
    mov rdi, r12
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

.timeout_error:
    mov rax, 3
    mov rdi, r12
    syscall

    mov rax, 60
    mov rdi, 1
    syscall

.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall