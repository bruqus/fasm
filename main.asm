format ELF64
public _start

include "asmlib/fmt.inc"
include "asmlib/mth.inc"
include "asmlib/sys.inc"
include "asmlib/str.inc"

section '.text' executable
  _start:
    mov rax, 30
    mov rbx, 20
    call gcd 
    call print_number
    call print_line
    call exit
