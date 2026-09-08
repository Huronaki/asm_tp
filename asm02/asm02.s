global _start

section .data
  msg1 db "1337"
  
section .bss
  msg2 resb 10

section .text
_start:
  
  mov rax, 0
  mov rdi, 0
  mov rsi, msg2
  mov rdx, 10
  syscall
  
  cmp rax, 3
  jne .exit
  
  cmp byte [msg2], '4'
  jne .exit
  
  cmp byte [msg2 + 1], '2'
  jne .exit
  
  mov rax, 1
  mov rdi, 1
  mov rsi, msg1
  mov rdx, 4
  syscall
  
  mov rax, 60
  mov rdi, 0
  syscall
  
  .exit
  mov rax, 60
  mov rdi, 1
  syscall