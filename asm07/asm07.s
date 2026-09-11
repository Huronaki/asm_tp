global _start
  
section .bss
    msg resb 15

section .text
_start:
  
    mov rax, 0
    mov rdi, 0
    mov rsi, msg
    mov rdx, 15
    syscall

    cmp byte [rsi + rax - 1], 10
    jne .check_loop

    dec rax

    cmp rax, 0
    je .exit_error

    cmp byte [rsi], '-'
    je .negative

.negative:
    mov rcx, 1

.check_loop:
    cmp rcx, rax
    je .convert
  
    cmp byte [rsi+rcx], '0'
    jl .exit_error
  
    cmp byte [rsi+rcx], '9'
    jg .exit_error
  
    inc rcx
    jmp .check_loop
  
.convert:
    cmp byte [rsi], '-'
    je .exit_non_prime

    mov r8, rax
    xor rax, rax
    xor rcx, rcx
  
.convert_loop:
    cmp rcx, r8
    je .check_prime
    
    movzx rdx, byte [rsi + rcx]
    sub rdx, '0'
    
    imul rax, 10
    add rax, rdx
    
    inc rcx
    jmp .convert_loop

.check_prime:
    mov rcx, 2

.check_prime_loop:
    mov rbx, rcx
    imul rbx, rcx

    cmp rbx, rax
    jg .exit_prime

    mov r8, rax

    xor rdx, rdx
    div rbx

    cmp rdx, 0
    je .exit_non_prime

    mov rax, r8

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