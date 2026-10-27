
global _start

section .data
    new_msg db "H4CK"

section .bss
    buffer resb 65536

section .text
_start:
    cmp qword [rsp], 2
    jne .exit_error

    mov rax, 2
    mov rdi, [rsp + 16]
    mov rsi, 2
    xor rdx, rdx
    syscall

    test rax, rax
    js .exit_error

    mov r12, rax

    mov rax, 0
    mov rdi, r12
    mov rsi, buffer
    mov rdx, 65536
    syscall

    test rax, rax
    jle .exit_error

    mov r13, rax                 ; количество прочитанных байтов

    ; Ищем "1337"
    xor rcx, rcx

.search_loop:
    mov rax, r13
    sub rax, rcx
    cmp rax, 4
    jb .not_found

    cmp dword [buffer + rcx], 0x37333331
    je .found

    inc rcx
    jmp .search_loop

.found:
    mov r14, rcx

    mov rax, 8
    mov rdi, r12
    mov rsi, r14
    xor rdx, rdx
    syscall

    test rax, rax
    js .exit_error

    mov rax, 1
    mov rdi, r12
    mov rsi, new_msg
    mov rdx, 4
    syscall

    cmp rax, 4
    jne .exit_error

    mov rax, 3
    mov rdi, r12
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

.not_found:
    mov rax, 3
    mov rdi, r12
    syscall

.exit_error:
    mov rax, 60
    mov rdi, 2
    syscall
