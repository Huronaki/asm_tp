global _start:

section .bss
    msg resb 1025
    reversed resb 1025

section .data
    newline db 10

section .text
_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, msg
    mov rdx, 1025
    syscall

    cmp rax, 0
    je .exit_error

    cmp rax, 1025
    jg .exit_error

    cmp byte [rsi + rax - 1], 10
    jne .correct_input

    dec rax

    cmp rax, 0
    je .exit_error

.correct_input:
    mov r8, rax
    mov rcx, rax

    add rsi, rcx
    dec rsi

    mov rdi, reversed

.reverse:
    mov dl, [rsi]
    mov [rdi], dl

    dec rsi
    inc rdi

    dec rcx
    jnz .reverse

.write:
    mov rax, 1
    mov rdi, 1
    mov rsi, reversed
    mov rdx, r8
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall


    mov rax, 60
    mov rdi, 0
    syscall


.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall