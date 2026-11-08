global _start

section .data
    server_addr:
        dw 2
        dw 0x9210
        dd 0x0100007f
        dq 0

    pong db "PONG", 10
    pong_len equ $ - pong

    goodbye db "Goodbye!", 10
    goodbye_len equ $ - goodbye

    unknown db "Unknown command", 10
    unknown_len equ $ - unknown

section .bss
    buffer resb 1024

section .text

_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    xor rdx, rdx
    syscall

    test rax, rax
    js .exit_error

    mov r12, rax

    mov rax, 49
    mov rdi, r12
    mov rsi, server_addr
    mov rdx, 16
    syscall

    test rax, rax
    js .exit_error

    mov rax, 50
    mov rdi, r12
    mov rsi, 5
    syscall

    test rax, rax
    js .exit_error

.accept:
    mov rax, 43
    mov rdi, r12
    xor rsi, rsi
    xor rdx, rdx
    syscall

    test rax, rax
    js .exit_error

    mov r13, rax

.read_command:
    mov rax, 0
    mov rdi, r13
    mov rsi, buffer
    mov rdx, 1024
    syscall

    test rax, rax
    jle .close_client

    mov r14, rax

    cmp byte [buffer + r14 - 1], 10
    jne .check_cr

    dec r14

.check_cr:
    test r14, r14
    jz .check_ping

    cmp byte [buffer + r14 - 1], 13
    jne .check_ping

    dec r14

.check_ping:
    cmp r14, 4
    jne .check_reverse

    cmp byte [buffer], 'P'
    jne .check_reverse
    cmp byte [buffer + 1], 'I'
    jne .check_reverse
    cmp byte [buffer + 2], 'N'
    jne .check_reverse
    cmp byte [buffer + 3], 'G'
    jne .check_reverse

    mov rax, 1
    mov rdi, r13
    mov rsi, pong
    mov rdx, pong_len
    syscall

    jmp .read_command

.check_reverse:
    cmp r14, 8
    jl .check_exit

    cmp byte [buffer], 'R'
    jne .check_exit
    cmp byte [buffer + 1], 'E'
    jne .check_exit
    cmp byte [buffer + 2], 'V'
    jne .check_exit
    cmp byte [buffer + 3], 'E'
    jne .check_exit
    cmp byte [buffer + 4], 'R'
    jne .check_exit
    cmp byte [buffer + 5], 'S'
    jne .check_exit
    cmp byte [buffer + 6], 'E'
    jne .check_exit
    cmp byte [buffer + 7], ' '
    jne .check_exit

    mov rsi, 8
    mov rdi, r14
    dec rdi

.reverse_loop:
    cmp rsi, rdi
    jge .reverse_done

    mov al, [buffer + rsi]
    mov bl, [buffer + rdi]

    mov [buffer + rsi], bl
    mov [buffer + rdi], al

    inc rsi
    dec rdi

    jmp .reverse_loop

.reverse_done:
    mov byte [buffer + r14], 10
    inc r14

    mov rax, 1
    mov rdi, r13
    mov rsi, buffer
    mov rdx, r14
    syscall

    jmp .read_command

.check_exit:
    cmp r14, 4
    jne .unknown_command

    cmp byte [buffer], 'E'
    jne .unknown_command
    cmp byte [buffer + 1], 'X'
    jne .unknown_command
    cmp byte [buffer + 2], 'I'
    jne .unknown_command
    cmp byte [buffer + 3], 'T'
    jne .unknown_command

    mov rax, 1
    mov rdi, r13
    mov rsi, goodbye
    mov rdx, goodbye_len
    syscall

    jmp .close_client

.unknown_command:
    mov rax, 1
    mov rdi, r13
    mov rsi, unknown
    mov rdx, unknown_len
    syscall

    jmp .read_command

.close_client:
    mov rax, 3
    mov rdi, r13
    syscall

    jmp .accept

.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall