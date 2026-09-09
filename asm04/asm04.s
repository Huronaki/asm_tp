global _start
  
section .bss
    msg resb 15

section .text
_start:
  
    mov rax, 0
    mov rdi, 0
    mov rsi, msg
    mov rdx, 10
    syscall
  
    dec rax
  
    cmp rax, 0
    je .not_number
  
    cmp byte [rsi], '-'
    je .negative
  
    mov rcx, 0
    jmp .check_loop
  
.negative:
    cmp rax, 1
    je .not_number

    mov rcx, 1

.check_loop:
    cmp rcx, rax
    je .convert
  
    cmp byte [rsi+rcx], '0'
    jl .not_number
  
    cmp byte [rsi+rcx], '9'
    jg .not_number
  
    inc rcx
    jmp .check_loop
  
.convert:
    mov r8, rax
    xor rax, rax
  
    xor rcx, rcx
    cmp byte [rsi], '-'
    jne .convert_loop

    mov rcx, 1
  
.convert_loop:
    cmp rcx, r8
    je .check_even
    
    movzx rdx, byte [rsi + rcx]
    sub rdx, '0'
    
    imul rax, 10
    add rax, rdx
    
    inc rcx
    jmp .convert_loop
    
.check_even:
    test rax, 1
    jz .exit_even
    jnz .exit_odd
  
.exit_even:
    mov rax, 60
    mov rdi, 0
    syscall
  
.exit_odd:
    mov rax, 60
    mov rdi, 1
    syscall
  
.not_number:
    mov rax, 60
    mov rdi, 2
    syscall