global _start:

section .data
    msg db "Hello Universe!", 10
    msg_len equ $ - msg

section .text
_start:
    cmp qword [rsp], 2
    jne .exit_argument_error

    mov rax, 2
    mov rdi, [rsp+16]
    mov rsi, 577
    mov rdx, 420
    syscall

    test rax, rax
    js .exit_path_error

    mov r12, rax
    mov rax, 1
    mov rdi, r12
    mov rsi, msg
    mov rdx, msg_len
    syscall

    cmp rax, msg_len
    jne .close_error

    mov rax, 3
    mov rdi, r12
    syscall

    test rax, rax
    js .exit_path_error

    mov rax, 60
    mov rdi, 0
    syscall

    .close_error:
    mov rax, 3
    mov rdi, r12
    syscall

    jmp .exit_path_error

.exit_path_error:
    mov rax, 60
    mov rdi, 1
    syscall 

.exit_argument_error:
    mov rax, 60
    mov rdi, 2
    syscall
