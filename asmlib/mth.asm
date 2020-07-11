format ELF64

public gcd
public fibonacci
public factorial
public bubble_sort

section '.gcd' executable
  ; | input
  ; rax = number 1
  ; rbx = number 2
  ; | output
  ; rax = number
  gcd:
    push rbx
    push rdx
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
      pop rdx
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

section '.bubble_sort' executable
  ; | input
  ; rax = array
  ; rbx = array size
  bubble_sort:
    push rbx
    push rcx
    push rdx
    xor rcx, rcx ; i
    .first_iter:
      cmp rcx, rbx
      je .break_first
      xor rdx, rdx ; j
      push rbx
      sub rbx, rcx
      dec rbx
      .second_iter:
        cmp rdx, rbx
        je .break_second
        push rbx
        mov bl, [rax+rdx]
        cmp bl, [rax+rdx+1]
        jg .swap
        jmp .pass
      .swap:
        push rcx
        mov cl, [rax+rdx+1]
        mov [rax+rdx+1], bl
        mov [rax+rdx], cl
        pop rcx
      .pass:
        pop rbx
        inc rdx
        jmp .second_iter
      .break_second:
        pop rbx
        inc rcx
        jmp .first_iter
    .break_first:
      pop rdx
      pop rcx
      pop rbx
      ret
