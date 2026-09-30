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

    xor rcx, rcx

    cmp rax, 0
    je .exit_error
    
    cmp byte [rsi + rax - 1], 10
    jne .check_loop

    dec rax

    cmp rax, 0
    je .exit_error

    cmp byte [rsi], '-'
    jne .check_loop

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

    cmp byte [rsi], '0'
    je .exit_non_prime

    cmp byte [rsi], '1'
    jne .continue

    cmp rax, 1
    je .exit_non_prime

.continue:

    mov r8, rax
    xor rax, rax
    xor rcx, rcx
  
.convert_loop:
    cmp rcx, r8
    je .check_prime
    
    movzx rdx, byte [rsi + rcx]
    sub rdx, '0'
    
    imul rax, 10
    jo .exit_error

    add rax, rdx
    jo .exit_error
    
    inc rcx
    jmp .convert_loop

.check_prime:
    cmp rax, 2
    je .exit_prime

    mov rcx, 3

.check_prime_loop:
    mov rbx, rcx
    imul rbx, rcx
    jo .exit_error

    cmp rbx, rax
    jg .exit_prime

    mov r8, rax

    xor rdx, rdx
    div rcx

    cmp rdx, 0
    je .exit_non_prime

    mov rax, r8

    add rcx, 2
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