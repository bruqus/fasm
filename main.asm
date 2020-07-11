format ELF64
public _start

include "asmlib/fmt.inc"
include "asmlib/mth.inc"
include "asmlib/sys.inc"
include "asmlib/str.inc"

section '.data' writable
array db 5, 4, 3, 2, 1
array_size equ 5

section '.text' executable
  _start:
    mov rax, array
    mov rbx, array_size
    call bubble_sort
    call print_bytes
    call print_line
    call exit
