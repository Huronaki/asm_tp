global _start

section .data
    buffer times 21 db 0
    newline db 10

section .text

_start:

; проверить наличие аргумена
    cmp qword [rsp], 1
    je .exit_error

    mov rsi, [rsp+16]

; проверить что первый аргумент ТОЛЬКО позитивный инт (никаких символов кроме цифр)

.count:
    cmp byte [rsi + rcx], 0
    je .count_done

    inc rcx
    jmp .count

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

; конвертировать аргумент в число
.check_done:
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
    xor r8, r8

    mov r8, rax
    xor rax, rax

; посчитать 1 + 2 + ... + N-1 (где N наш первый аргумент)
.counting_loop:
    cmp rcx, r8
    je .counting_done

    add rax, rcx

    inc rcx
    jmp .counting_loop

; конвертировать в строку rax
.counting_done:
    xor rcx, rcx
    mov rsi, buffer + 21

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

; вывести в консоль с /n нашу сумму
.end:


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



