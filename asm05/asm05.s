global _start

section .data
    newline db 10
section .text

_start:
    mov rsi, [rsp+16]

.count:
    cmp byte [rsi + rcx], 0
    je .print

    inc rcx
    jmp .count

.print:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall