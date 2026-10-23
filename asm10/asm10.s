global _start

section .data
    buffer times 21 db 0
    newline db 10

section .text

_start:
    cmp qword [rsp], 4
    jne .exit_argument_error

    lea r12, [rsp + 16]

    mov r13, 3

.next_argument:
    mov rsi, [r12]
    xor rcx, rcx

    cmp byte [rsi], 0
    je .exit_number_error

.count:
    cmp byte [rsi + rcx], 0
    je .count_done

    inc rcx
    jmp .count

.count_done:
    mov r8, rcx

    cmp r8, 20
    jg .exit_number_error

    cmp byte [rsi], '-'
    jne .positive

    cmp r8, 1
    je .exit_number_error

    mov rcx, 1
    jmp .check_loop

.positive:
    xor rcx, rcx

.check_loop:
    cmp rcx, r8
    je .convert

    cmp byte [rsi + rcx], '0'
    jl .exit_number_error

    cmp byte [rsi + rcx], '9'
    jg .exit_number_error

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

    ; Limit before multiplying: -922337203685477580
    mov r10, -922337203685477580

    cmp rax, r10
    jl .exit_number_error
    jne .accumulate

    ; Last digit limit: 8 for negative, 7 for positive
    mov r11, 7
    cmp byte [rsi], '-'
    jne .check_last_digit

    mov r11, 8

.check_last_digit:
    cmp rdx, r11
    ja .exit_number_error

.accumulate:
    imul rax, 10
    jo .exit_number_error

    sub rax, rdx
    jo .exit_number_error

    inc rcx
    jmp .convert_loop

.conversion_done:
    cmp byte [rsi], '-'
    je .number_ready

    neg rax

.number_ready:
    cmp r13, 3
    jne .compare_with_max

    mov r9, rax
    jmp .next

.compare_with_max:
    cmp rax, r9
    jle .next

    mov r9, rax

.next:
    add r12, 8
    dec r13
    jnz .next_argument

    mov rax, r9
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

    cmp r9, 0
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

.exit_number_error:
    mov rax, 60
    mov rdi, 1
    syscall

.exit_argument_error:
    mov rax, 60
    mov rdi, 2
    syscall