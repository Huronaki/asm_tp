global _start

section .data
    buffer times 21 db 0
    newline db 10

section .text

_start:
    cmp qword [rsp], 2
    je .one_argument

    cmp qword [rsp], 3
    je .two_arguments

    jmp .exit_error

.one_argument:
    mov rsi, [rsp+16]
    xor rcx, rcx

.count_loop:
    cmp byte [rsi + rcx], 0
    je .count_done

    inc rcx
    jmp .count_loop

.count_done:
    mov r8, rcx
    xor rcx, rcx

.check_loop:
    cmp rcx, r8
    je .check_done
    
    cmp byte [rsi+rcx], '0'
    jl .exit_error
    cmp byte [rsi+rcx], '9'
    jg .exit_error

    inc rcx
    jmp .check_loop

.check_done:
    xor rax, rax  
    xor rcx, rcx

.convert_loop:
    cmp rcx, r8
    je .convert_done

    movzx rdx, byte [rsi + rcx]
    sub rdx, '0'

    imul rax, 10
    add rax, rdx

    inc rcx
    jmp .convert_loop

.convert_done:
    xor rcx, rcx
    mov rsi, buffer + 16

    cmp rax, 0
    jne .convert_hex

    dec rsi
    mov byte [rsi], '0'
    mov rcx, 1
    jmp .exit_done

.convert_hex:
    mov rdx, rax
    and rdx, 0xF

    cmp dl, 9
    jg .letter

    add dl, '0'
    jmp .save

.letter:
    add dl, 'A' - 10

.save:
    dec rsi
    mov [rsi], dl
    inc rcx

    shr rax, 4
    test rax, rax
    jnz .convert_hex
    jmp .exit_done


.two_arguments:
    mov rsi, [rsp+16]    
    xor rcx, rcx

    cmp byte [rsi], '-'
    jne .exit_error

    cmp byte [rsi+1], 'b'
    jne .exit_error

    cmp byte [rsi+2], 0
    jne .exit_error

    mov rsi, [rsp+24]

.count_loop2:
    cmp byte [rsi + rcx], 0
    je .count_done2

    inc rcx
    jmp .count_loop2

.count_done2:
    mov r8, rcx
    xor rcx, rcx

.check_loop2:
    cmp rcx, r8
    je .check_done2
    
    cmp byte [rsi+rcx], '0'
    jl .exit_error
    cmp byte [rsi+rcx], '9'
    jg .exit_error

    inc rcx
    jmp .check_loop2

.check_done2:
    xor rcx, rcx
    xor rax, rax  

.convert_loop2:
    cmp rcx, r8
    je .convert_done2

    movzx rdx, byte [rsi + rcx]
    sub rdx, '0'

    imul rax, 10
    add rax, rdx

    inc rcx
    jmp .convert_loop2

.convert_done2:
    xor rcx, rcx
    mov rsi, buffer + 21

    cmp rax, 0
    jne .convert_binary

    dec rsi
    mov byte [rsi], '0'
    mov rcx, 1
    jmp .exit_done

.convert_binary:
    mov rdx, rax
    and rdx, 1

    add dl, '0'

    dec rsi
    mov [rsi], dl
    inc rcx

    shr rax, 1
    test rax, rax
    jnz .convert_binary
    
.exit_done:
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
