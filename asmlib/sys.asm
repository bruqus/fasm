format ELF64

public exit
public time

section '.time' executable
  ; | ouput:
  ; rax = number
  time:
    push rbx
    mov rax, 13
    xor rbx, rbx
    int 0x80
    pop rbx	
    ret

section '.exit' executable
  exit:
    mov rax, 1
    xor rbx, rbx
    int 0x80
