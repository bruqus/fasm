format ELF64

public gcd
public fibonacci
public factorial

section '.gcd' executable
  ; | input
  ; rax = number 1
  ; rbx = number 2
  ; | output
  ; rax = number
  gcd:
    push rbx
    .next_iter:
      cmp rbx, 0
      je .close
      xor rdx, rdx
      div rbx
      push rbx
      mov rbx, rdx
      pop rax
      jmp .next_iter
    .close:
      pop rbx
      ret

section '.fibonacci' executable
  ; | input:
  ; rax = number
  ; | output:
  ; rax = number
  fibonacci:
    push rbx
    push rcx
    xor rbx, rbx
    mov rcx, 1
    cmp rax, 0
    je .next_step
    .next_iter:
      cmp rax, 1
      jle .close
      push rcx
      add rcx, rbx
      pop rbx
      dec rax
      jmp .next_iter
    .next_step:
      xor rcx, rcx
    .close:
      mov rax, rcx
      pop rcx
      pop rbx
      ret

section '.factorial' executable
  ; | input:
  ; rax = number
  ; | output:
  ; rax = number
  factorial:
    push rbx
    mov rbx, rax
    mov rax, 1
    .next_iter:
      cmp rbx, 1
      jle .close
      mul rbx 
      dec rbx
      jmp .next_iter
    .close:
      pop rbx
      ret