format ELF64
public _start

include "asmlib/fmt.inc"
include "asmlib/mth.inc"
include "asmlib/sys.inc"
include "asmlib/str.inc"

section '.text' executable
  _start:
    call time
    call srand

    call rand 
    call print_number
    call print_line

    call exit
