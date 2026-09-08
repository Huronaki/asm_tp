global _start

section .data
	msg1 db "1337", 10

section .text

_start:

	mov rax, [rsp]
	cmp rax, 2
	jne .exit

	mov rbx, [rsp+16]
	cmp byte [rbx], '4'
	jne .exit

	cmp byte [rbx+1], '2'
	jne .exit

	mov rax, 1
	mov rdi, 1
	mov rsi, msg1
	mov rdx, 5
	syscall

	mov rax, 60
	mov rdi, 0
	syscall

.exit:
	mov rax, 60
	mov rdi, 1
	syscall
