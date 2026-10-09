global _start

section .data
  msg1 db "1337"
  newline db 10
  
section .bss
  msg2 resb 10

section .text
_start:
  
  mov rax, 0
  mov rdi, 0
  mov rsi, msg2
  mov rdx, 10
  syscall
  
  cmp byte [rsi + rax - 1], 10
  jne .no_newline

  dec rax

  .no_newline:
  cmp rax, 2
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

  mov rax, 1
  mov rdi, 1
  mov rsi, newline
  mov rdx, 1
  syscall
  
  mov rax, 60
  mov rdi, 0
  syscall
  
.exit:
  mov rax, 60
  mov rdi, 1
  syscall