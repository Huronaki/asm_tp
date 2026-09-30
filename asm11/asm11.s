global _start
  
section .bss
    msg resb 1025

section .data
    newline db 10

section .text
_start:
  
    mov rax, 0
    mov rdi, 0
    mov rsi, msg
    mov rdx, 1025
    syscall

    cmp rax, 1025
    jl .correct_input

    cmp byte [rsi + rax - 1], 10
    jne .exit_error

.correct_input:
    xor rcx, rcx
    xor rbx, rbx

    mov r8, rax

.check:
    cmp r8, rcx
    je .convert_result

    movzx rdx, byte [rsi + rcx]
    or dl, 32

    cmp dl, 'a'
    je .increase

    cmp dl, 'e'
    je .increase

    cmp dl, 'i'
    je .increase

    cmp dl, 'o'
    je .increase

    cmp dl, 'u'
    je .increase

    jmp .next

.next:
    inc rcx
    jmp .check

.increase:
    inc rbx
    jmp .next

.convert_result:
    xor rcx, rcx
    mov rax, rbx
    mov rsi, msg + 1025

.convert:
    xor rdx, rdx
    mov rbx, 10
    div rbx

    add dl, '0'
    dec rsi
    mov [rsi], dl

    inc rcx
    test rax, rax
    jnz .convert

.write:
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

.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall