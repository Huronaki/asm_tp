global _start

section .bss
    buffer resb 1024

section .text

_start:
    cmp qword [rsp], 2
    jne .exit_usage

    mov rsi, [rsp + 16]

    xor r9, r9
    xor r8, r8

    cmp byte [rsi], '-'
    jne .check_plus

    mov r9, 1
    inc rsi
    jmp .check_empty

.check_plus:
    cmp byte [rsi], '+'
    jne .check_empty

    inc rsi

.check_empty:
    cmp byte [rsi], 0
    je .exit_error

.check_loop:
    movzx rdx, byte [rsi]
    test rdx, rdx
    jz .start_conversion

    cmp rdx, '0'
    jb .exit_error
    cmp rdx, '9'
    ja .exit_error

    inc rsi
    inc r8
    jmp .check_loop

.start_conversion:
    mov rsi, [rsp + 16]

    cmp byte [rsi], '-'
    jne .skip_plus_check
    inc rsi
    jmp .conversion_init

.skip_plus_check:
    cmp byte [rsi], '+'
    jne .conversion_init
    inc rsi

.conversion_init:
    xor rax, rax
    xor rcx, rcx

.convert_loop:
    movzx rdx, byte [rsi + rcx]
    test rdx, rdx
    jz .conversion_done

    sub rdx, '0'

    imul rax, 10
    jo .exit_error

    sub rax, rdx
    jo .exit_error

    inc rcx
    jmp .convert_loop

.conversion_done:
    cmp r9, 1
    je .normalize_shift

    neg rax
    jo .exit_error

.normalize_shift:
    cqo
    mov r10, 26
    idiv r10

    test rdx, rdx
    jns .save_shift
    add rdx, 26

.save_shift:
    mov r12, rdx

.read_loop:
    xor eax, eax
    xor edi, edi
    lea r15, [rel buffer]
    mov rsi, r15 
    mov edx, 1024
    syscall

    test rax, rax
    js .exit_error
    jz .exit_success

    mov r13, rax
    xor r14, r14

.encrypt_loop:
    cmp r14, r13
    jae .write_start

    movzx rax, byte [r15 + r14]

    cmp al, 'A'
    jb .check_lower
    cmp al, 'Z'
    ja .check_lower

    sub rax, 'A'
    add rax, r12
    cmp rax, 26
    jb .store_upper
    sub rax, 26

.store_upper:
    add al, 'A'
    mov byte [r15 + r14], al
    jmp .next_char

.check_lower:
    cmp al, 'a'
    jb .next_char
    cmp al, 'z'
    ja .next_char

    sub rax, 'a'
    add rax, r12
    cmp rax, 26
    jb .store_lower
    sub rax, 26

.store_lower:
    add al, 'a'
    mov byte [r15 + r14], al

.next_char:
    inc r14
    jmp .encrypt_loop

.write_start:
    xor r14, r14

.write_loop:
    cmp r14, r13
    jae .read_loop

    mov eax, 1
    mov edi, 1
    lea rsi, [r15 + r14]
    mov rdx, r13
    sub rdx, r14
    syscall

    test rax, rax
    jle .exit_error

    add r14, rax
    jmp .write_loop

.exit_success:
    mov eax, 60
    xor edi, edi
    syscall

.exit_error:
    mov eax, 60
    mov edi, 1
    syscall

.exit_usage:
    mov eax, 60
    mov edi, 2
    syscall