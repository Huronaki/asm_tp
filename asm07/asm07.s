global _start

section .bss
    msg resb 21

section .text

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, msg
    mov rdx, 21
    syscall

    cmp rax, 0
    je .exit_error
    cmp rax, 21
    je .check_full_buffer

    cmp byte [rsi + rax - 1], 10
    jne .save_length

    dec rax

.save_length:
    mov r8, rax
    jmp .check_empty

.check_full_buffer:
    cmp byte [rsi + 20], 10
    jne .exit_error

    mov r8, 20

.check_empty:
    cmp r8, 0
    je .exit_error

    xor rcx, rcx
    cmp byte [rsi], '-'
    jne .check_loop

    cmp r8, 1
    je .exit_error

    mov rcx, 1

.check_loop:
    cmp rcx, r8
    je .check_negative

    cmp byte [rsi + rcx], '0'
    jl .exit_error
    cmp byte [rsi + rcx], '9'
    jg .exit_error

    inc rcx
    jmp .check_loop

.check_negative:
    cmp byte [rsi], '-'
    je .exit_non_prime

    xor rax, rax
    xor rcx, rcx

.convert_loop:
    cmp rcx, r8
    je .conversion_done

    movzx rdx, byte [rsi + rcx]
    sub rdx, '0'

    imul rax, 10
    jo .exit_error

    add rax, rdx
    jo .exit_error

    inc rcx
    jmp .convert_loop

.conversion_done:
    cmp rax, 0
    je .exit_non_prime

    cmp rax, 1
    je .exit_non_prime

    mov rcx, 2

.check_prime_loop:
    mov rdx, rcx
    imul rdx, rcx

    cmp rdx, rax
    jg .exit_prime

    xor rdx, rdx
    div rcx

    cmp rdx, 0
    je .exit_non_prime

    inc rcx
    jmp .check_prime_loop

.exit_prime:
    mov rax, 60
    mov rdi, 0
    syscall

.exit_non_prime:
    mov rax, 60
    mov rdi, 1
    syscall

.exit_error:
    mov rax, 60
    mov rdi, 2
    syscall