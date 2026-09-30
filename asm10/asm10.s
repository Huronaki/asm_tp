global _start

section .data
    buffer times 21 db 0
    newline db 10

section .text
_start:
    cmp qword [rsp], 4
    jne .exit_argument_error

.check_first:
    mov rsi, [rsp+16]
    xor rcx, rcx

    cmp byte [rsi], 0
    je .exit_number_error

.count1:
    cmp byte [rsi + rcx], 0
    je .count_done1

    inc rcx
    jmp .count1

.count_done1:
    mov r8, rcx
    cmp r8, 20
    jg .exit_number_error

    cmp byte [rsi], '-'
    jne .positive1

    cmp r8, 1
    je .exit_number_error

    mov rcx, 1
    jmp .check_loop1

.positive1:
    xor rcx, rcx

.check_loop1:
    cmp rcx, r8
    je .convert1

    cmp byte [rsi + rcx], '0'
    jl .exit_number_error

    cmp byte [rsi + rcx], '9'
    jg .exit_number_error

    inc rcx
    jmp .check_loop1


.convert1:
    xor rax, rax
    xor rcx, rcx

    cmp byte [rsi], '-'
    jne .convert_loop1

    mov rcx, 1

.convert_loop1:
    cmp rcx, r8
    je .conversion_done1

    movzx rdx, byte [rsi + rcx]
    sub rdx, '0'

    imul rax, 10
    jo .exit_argument_error

    add rax, rdx
    jo .exit_argument_error

    inc rcx
    jmp .convert_loop1


.conversion_done1:
    cmp byte [rsi], '-'
    jne .first_done

    neg rax

.first_done:
    mov r9, rax


.check_second:
    mov rsi, [rsp+24]
    xor rcx, rcx

    cmp byte [rsi], 0
    je .exit_number_error

.count2:
    cmp byte [rsi + rcx], 0
    je .count_done2

    inc rcx
    jmp .count2

.count_done2:
    mov r8, rcx
    cmp r8, 20
    jg .exit_number_error

    cmp byte [rsi], '-'
    jne .positive2

    cmp r8, 1
    je .exit_number_error

    mov rcx, 1
    jmp .check_loop2

.positive2:
    xor rcx, rcx

.check_loop2:
    cmp rcx, r8
    je .convert2

    cmp byte [rsi + rcx], '0'
    jl .exit_number_error

    cmp byte [rsi + rcx], '9'
    jg .exit_number_error

    inc rcx
    jmp .check_loop2


.convert2:
    xor rax, rax
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
    jo .exit_argument_error

    add rax, rdx
    jo .exit_argument_error

    inc rcx
    jmp .convert_loop2


.conversion_done2:
    cmp byte [rsi], '-'
    jne .second_done

    neg rax

.second_done:
    mov r10, rax

.check_third:
    mov rsi, [rsp+32]
    xor rcx, rcx

    cmp byte [rsi], 0
    je .exit_number_error

.count3:
    cmp byte [rsi + rcx], 0
    je .count_done3

    inc rcx
    jmp .count3

.count_done3:
    mov r8, rcx
    cmp r8, 20
    jg .exit_number_error

    cmp byte [rsi], '-'
    jne .positive3

    cmp r8, 1
    je .exit_number_error

    mov rcx, 1
    jmp .check_loop3

.positive3:
    xor rcx, rcx

.check_loop3:
    cmp rcx, r8
    je .convert3

    cmp byte [rsi + rcx], '0'
    jl .exit_number_error

    cmp byte [rsi + rcx], '9'
    jg .exit_number_error

    inc rcx
    jmp .check_loop3


.convert3:
    xor rax, rax
    xor rcx, rcx

    cmp byte [rsi], '-'
    jne .convert_loop3

    mov rcx, 1

.convert_loop3:
    cmp rcx, r8
    je .conversion_done3

    movzx rdx, byte [rsi + rcx]
    sub rdx, '0'

    imul rax, 10
    jo .exit_argument_error

    add rax, rdx
    jo .exit_argument_error

    inc rcx
    jmp .convert_loop3


.conversion_done3:
    cmp byte [rsi], '-'
    jne .third_done

    neg rax

.third_done:
    mov r11, rax


    mov r8, r9

    cmp r10, r8
    jle .compare_third

    mov r8, r10

.compare_third:
    cmp r11, r8
    jle .end

    mov r8, r11

.end:
    mov rax, r8
    mov rsi, buffer + 21
    xor rcx, rcx

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

    cmp r8, 0
    jge .exit_result

    dec rsi
    mov byte [rsi], '-'
    inc rcx



.exit_result:
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

.exit_argument_error:
    mov rax, 60
    mov rdi, 2
    syscall

.exit_number_error:
    mov rax, 60
    mov rdi, 1
    syscall