global _start
  
section .bss
    msg resb 22

section .text
_start:
  
    mov rax, 0
    mov rdi, 0
    mov rsi, msg
    mov rdx, 22
    syscall

    cmp rax, 0
    je .exit_error

    cmp byte [rsi + rax - 1], 10
    jne .check_length

    dec rax

.check_length:
    cmp rax, 21
    ja .exit_error

    cmp byte [rsi], '-'
    je .negative

    xor rcx, rcx
    jmp .check_loop

.negative:
    mov rcx, 1

    cmp rcx, rax
    je .exit_error

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
    je .check_number
    
    movzx r10, byte [rsi + rcx]
    sub r10, '0'

    mov r9, 10
    mul r9
    jo .exit_error

    add rax, r10
    jc .exit_error
    
    inc rcx
    jmp .convert_loop

.check_number:
    cmp rax, 0
    je .exit_non_prime

    cmp rax, 1
    je .exit_non_prime

.check_prime:
    mov r8, rax
    mov rcx, 2

.check_prime_loop:
    mov rax, rcx
    xor rdx, rdx
    mul rcx
    jc .exit_prime

    cmp rax, r8
    ja .exit_prime

    mov rax, r8
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


; BUGS
; 6 -> exit 0
; 10 -> exit 0
; 15 -> exit 0
; 21 -> exit 0
; 12345678901234567890\n -> exit 2
; 123456789012345678901\n -> exit 2
; 123456789012345678901 -> exit 2
; a\n -> exit 1
;  123\n -> exit 0
; 0002\n -> exit 1
; 1010\n -> exit 0