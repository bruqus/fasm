format ELF64
public _start

section '.data' writable
  strnum db "322", 0
  _buffer.size equ 20

section '.bss' writable
  _buffer rb _buffer.size
  _bss_char rb 1

section '.text' executable
  _start:
    mov rax, strnum
    call string_to_number
    call print_number
    call print_line
    call exit

section '.string_to_number' executable
  ; | input:
  ; rax = string
  ; | output:
  ; rax = number
  string_to_number:
    push rbx
    push rcx
    push rdx
    xor rbx, rbx
    xor rcx, rcx
    .next_iter:
      cmp [rax+rbx], byte 0
      je .next_step
      mov cl, [rax+rbx]
      sub cl, '0'
      push rcx
      inc rbx
      jmp .next_iter
    .next_step:
      mov rcx, 1
      xor rax, rax
    .to_number:
      cmp rbx, 0
      je .close 
      pop rdx
      imul rdx, rcx
      imul rcx, 10
      add rax, rdx
      dec rbx
      jmp .to_number
    .close:
      pop rdx
      pop rcx
      pop rbx
      ret

section '.number_to_string' executable
  ; | input:
  ; rax = number
  ; rbx = buffer
  ; rcx = buffer size
  number_to_string:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi 
    mov rsi, rcx
    dec rsi
    xor rcx, rcx
    .next_iter:
      push rbx
      mov rbx, 10
      xor rdx, rdx
      div rbx
      pop rbx
      add rdx, '0'
      push rdx 
      inc rcx
      cmp rax, 0 
      je .next_step
      jmp .next_iter
    .next_step:
      mov rdx, rcx
      xor rcx, rcx
    .to_string:
      cmp rcx, rsi
      je .pop_iter
      cmp rcx, rdx
      je .null_char
      pop rax
      mov [rbx+rcx], rax
      inc rcx 
      jmp .to_string
    .pop_iter:
      cmp rcx, rdx
      je .close
      pop rax
      inc rcx
      jmp .pop_iter
    .null_char:
      mov rsi, rdx
    .close:
      mov [rbx+rsi], byte 0
      pop rsi
      pop rdx
      pop rcx
      pop rbx
      pop rax
      ret

section '.print_char' executable
  print_char:
    push rax
    push rbx
    push rcx
    push rdx
    mov [_bss_char], al

    mov rax, 4
    mov rbx, 1
    mov rcx, _bss_char 
    mov rdx, 1
    int 0x80

    pop rdx
    pop rcx
    pop rbx
    pop rax

    ret

section '.print_line' executable
  print_line:
    push rax
    mov rax, 0xA
    call print_char

    pop rax
    ret

section '.exit' executable
  exit:
    mov rax, 1
    xor rbx, rbx
    int 0x80

section '.print_string' executable
  ; | input
  ; rax = string
  print_string:
    push rax
    push rbx
    push rcx
    push rdx
    mov rcx, rax
    call length_string
    mov rdx, rax
    mov rax, 4
    mov rbx, 1
    int 0x80 
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

section '.length_string' executable
  ; | input:
  ; rax - string
  ; | output:
  ; rax = length
  length_string: 
    push rdx
    xor rdx, rdx
    .next_iter:
      cmp [rax + rdx], byte 0
      je .close
      inc rdx
      jmp .next_iter
    .close:
      mov rax, rdx
      pop rdx
      ret

section '.print_number' executable
  ; | input:
  ; rax = number
  print_number:
    push rax
    push rbx
    push rcx
    push rdx
    xor rcx, rcx
    .next_iter:
      mov rbx, 10
      xor rdx, rdx
      div rbx
      add rdx, '0'
      push rdx 
      inc rcx
      cmp rax, 0 
      je .print_iter
      jmp .next_iter
    .print_iter:
      cmp rcx, 0
      je .close
      pop rax
      call print_char
      dec rcx 
      jmp .print_iter
    .close:
      pop rdx
      pop rcx
      pop rbx
      pop rax
      ret
