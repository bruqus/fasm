format ELF64
public _start

include "asmlib/fmt.inc"
include "asmlib/mth.inc"
include "asmlib/sys.inc"
include "asmlib/str.inc"

section '.data' writable
  fmt db "[%c + %s + %% + %d]", 0
  msg db "hello", 0
  msg2 db "World", 0

section '.text' executable
  _start:
    push 0x16
    push msg
    push 'c'
    mov rax, fmt
    call printf
    call print_line
    call exit
