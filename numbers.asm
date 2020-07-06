format ELF64
public _start

section '.bss' writable
  bss_char rb 1

section '.text' executable
  _start:
    mov rax, 'A' 
    call print_char
    call print_char32
    call print_line
    mov rax, 'B' 
    call print_char
    call print_char32
    call print_line
    mov rax, 'C' 
    call print_char
    call print_char32
    call print_line
    mov rax, 'D' 
    call print_char
    call print_char32
    call print_line
    call numbers
    call exit

section '.numbers' executable
  numbers:
    push rax
    push rbx

    mov rax, 571
    mov rbx, 139
    add rax, rbx
    call print_number
    call print_line

    mov rax, 20
    mov rbx, 3
    imul rax, rbx
    call print_number
    call print_line

    mov rax, 10
    mov rbx, 4
    mul rbx
    call print_number
    call print_line

    mov rax, 100
    mov rbx, 10
    div rbx
    call print_number
    call print_line

    mov rax, 125
    mov rbx, 55
    sub rax, rbx
    call print_number
    call print_line
    
    mov rax, 10
    call print_number
    mov rax, '*'
    call print_char32
    mov rax, 77
    call print_number
    mov rax, '='
    call print_char32
    mov rbx, 77
    mov rax, 10
    mul rbx
    call print_number
    call print_line

    mov rax, 0
    call print_number
    call print_line

    pop rbx
    pop rax
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
      call print_char32
      dec rcx 
      jmp .print_iter
    .close:
      pop rdx
      pop rcx
      pop rbx
      pop rax
      ret

section '.print_char' executable ; x64
  ; | input:
  ; rax = char
  print_char:
    push rax
    push rdi
    push rsi
    push rdx

    push rax

    mov rax, 1 ; write
    mov rdi, 1 ; stdout
    mov rsi, rsp
    mov rdx, 1
    syscall

    pop rax

    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

section '.print_char32' executable ; x32
  print_char32:
    push rax
    push rbx
    push rcx
    push rdx
    mov [bss_char], al               ; rax = 32|eax = 16|ax = ah|al

    mov rax, 4
    mov rbx, 1
    mov rcx, bss_char 
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
