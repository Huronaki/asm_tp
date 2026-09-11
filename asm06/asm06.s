global _start

section .data
    buffer times 21 db 0
    newline db 10

section .text
_start:
    mov rsi, [rsp+16]
    xor rcx, rcx

.count:
    cmp byte [rsi + rcx], 0
    je .count_done

    inc rcx
    jmp .count

.count_done:
    mov r8, rcx

    cmp byte [rsi], '-'
    jne .positive

    cmp r8, 1
    je .exit_error

    mov rcx, 1
    jmp .check_loop

.positive:
    xor rcx, rcx

.check_loop:
    cmp rcx, r8
    je .convert

    cmp byte [rsi + rcx], '0'
    jl .exit_error

    cmp byte [rsi + rcx], '9'
    jg .exit_error

    inc rcx
    jmp .check_loop


.convert:
    xor rax, rax
    xor rcx, rcx

    cmp byte [rsi], '-'
    jne .convert_loop

    mov rcx, 1

.convert_loop:
    cmp rcx, r8
    je .conversion_done

    movzx rdx, byte [rsi + rcx]
    sub rdx, '0'

    imul rax, 10
    add rax, rdx

    inc rcx
    jmp .convert_loop


.conversion_done:
    cmp byte [rsi], '-'
    jne .first_done

    neg rax



.first_done:
    mov r9, rax  

    mov rsi, [rsp+24]
    xor rcx, rcx
    xor rax, rax

.count2:
    cmp byte [rsi + rcx], 0
    je .count_done2

    inc rcx
    jmp .count2

.count_done2:
    mov r8, rcx

    cmp byte [rsi], '-'
    jne .positive2

    cmp r8, 1
    je .exit_error

    mov rcx, 1
    jmp .check_loop2

.positive2:
    xor rcx, rcx

.check_loop2:
    cmp rcx, r8
    je .convert2

    cmp byte [rsi + rcx], '0'
    jl .exit_error

    cmp byte [rsi + rcx], '9'
    jg .exit_error

    inc rcx
    jmp .check_loop2


.convert2:
    xor rcx, rcx

    cmp byte [rsi], '-'
    jne .convert_loop2

    mov rcx, 1

.convert_loop2:
    cmp rcx, r8
    je .conversion_done2

    movzx rdx, byte [rsi + rcx]
    sub rdx, '0'

    imul rax, 10
    add rax, rdx

    inc rcx
    jmp .convert_loop2


.conversion_done2:
    cmp byte [rsi], '-'
    jne .adding

    neg rax

.adding:
    add rax, r9
    mov r9, rax

    lea rsi, [buffer + 20]
    xor rcx, rcx
    mov r10, rax

    cmp rax, 0
    jge .convert_result

    neg rax

.convert_result:
    xor rdx, rdx
    mov rbx, 10
    div rbx

    add dl, '0'
    dec rsi
    mov [rsi], dl

    inc rcx
    test rax, rax
    jnz .convert_result

    cmp r10, 0
    jge .write_result

    dec rsi
    mov byte [rsi], '-'
    inc rcx

.write_result:
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
    mov rdi, 2
    syscall