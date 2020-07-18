format ELF
public _start

section '.bss' writable
         byte_for_symb rb 1

         num_buf_length equ 4
         num_buffer rb num_buf_length

         array_size equ 10
         array rb array_size

section '.data' writable
         ZERO_CODE = 48

         enter_line db 0xA, 0
         space_line db 0x20, 0

         end_input equ "To finish typing press 'Enter' twice", 0xA, 0
         enternum_msg db "Please enter no more than 10 numbers in the range [0, 255]", 0xA, end_input
         len_enternum = $ - enternum_msg

         youentered_msg db "You entered: ", 0xA, 0
         len_youentered = $ - youentered_msg

         lcm_msg db "Least common multiple of entered numbers ", 0xA, 0
         len_lcm = $ - lcm_msg

         gcd_msg db "Greatest common divisor of entered numbers ", 0xA, 0
         len_gcd = $ - gcd_msg

section '.main' executable
_start:
         mov ecx, enternum_msg
         mov edx, len_enternum
         call print_str

         mov eax, array
         mov ebx, array_size
         mov ecx, num_buffer
         mov edx, num_buf_length
         call input_nums

         mov eax, array
         mov ebx, esi
         call print_array
         mov eax, 0

         mov ecx, gcd_msg
         mov edx, len_gcd
         call print_str
         mov ecx, array
         mov edx, esi
         call gcd_array
         call print_num
         call newline

         call lcm_array
         mov ecx, lcm_msg
         mov edx, len_lcm 
         call print_str
         call print_num
         call newline

.exit:   mov eax, 1
         mov ebx, 0
         int 0x80

section '.print_array' executable
print_array:
         pushad
         mov ecx, youentered_msg
         mov edx, len_youentered
         call print_str
         mov ecx, eax
         mov eax, 0
.loop:   cmp ebx, 0
         je .end
         mov al, byte [ecx]
         call print_num
         push ecx
         push edx
         mov ecx, space_line
         mov edx, 2
         call print_str
         pop edx
         pop ecx
         inc ecx
         dec ebx
         jmp .loop
.end:    call newline
         popad
         ret

section '.newline' executable
newline:
         push ecx
         push edx
         mov ecx, enter_line
         mov edx, 2
         call print_str
         pop edx
         pop ecx
         ret

section '.gcd_array' executable
gcd_array:
         push ebx
         push edx
         push ecx
         push esi
         dec edx
         mov esi, 0
         cmp [ecx], byte 0
         je .end
         mov al, byte [ecx]
.loop:   cmp edx, 0
         je .end
         dec edx
         inc esi
         mov bl, byte [ecx+esi]
         call gcd
         jmp .loop
.end:    pop esi
         pop ecx
         pop edx
         pop ebx
         ret

section '.lcm_array' executable
lcm_array:
         push ebx
         push edx
         push ecx
         push esi
         dec edx
         mov esi, 0
         cmp [ecx], byte 0
         je .end
         mov al, byte [ecx]
.loop:   cmp edx, 0
         je .end
         dec edx
         inc esi
         mov bl, byte [ecx+esi]
         call lcm
         jmp .loop
.end:    pop esi
         pop ecx
         pop edx
         pop ebx
         ret

section '.lcm' executable
lcm:
         push ebx
         push ecx
         push edx
         mov edx, 0
         mov ecx, eax
         imul ecx, ebx
         call gcd
         xchg eax, ecx
         div ecx
         pop edx
         pop ecx
         pop ebx
         ret

section '.gcd' executable
gcd:
         push ebx
         push ecx
         push edx
.loop:   cmp ebx, 0
         je .end
         mov edx, 0
         div ebx
         mov ecx, ebx
         mov ebx, edx
         xchg eax, ecx
         jmp .loop
.end:    pop edx
         pop ecx
         pop ebx
         ret

section '.input_nums' executable
input_nums:
         push edi
         mov esi, 0
         mov edi, eax
.loop1:  cmp ebx, esi
         je .return
         push ebx
         mov eax, 3 ; read
         mov ebx, 2 ; stdin
         int 0x80
         pop ebx
         mov [eax + ecx - 1], byte 0
         cmp [ecx], byte 0
         je .return
         mov eax, ecx
         push ebx
         push ecx
         push edx
         mov ebx, 0
         mov ecx, 0
.loop2:  cmp [eax+ebx], byte 0
         je .loop3
         mov cl, [eax+ebx]
         sub cl, ZERO_CODE
         push ecx
         inc ebx
         jmp .loop2
.loop3:  mov ecx, 1
         mov eax, 0
.to_num: cmp ebx, 0
         je .end
         pop edx
         imul edx, ecx
         imul ecx, 10
         add eax, edx
         dec ebx
         jmp .to_num
.end:    pop edx
         pop ecx
         pop ebx
         mov [edi+esi], al
         inc esi
         jmp .loop1
.return: pop edi
         ret

section '.print_num' executable
print_num:
         pushad
         mov ecx, 0
.loop:   mov edx, 0
         mov ebx, 10
         div ebx
         add edx, ZERO_CODE
         push edx
         inc ecx
         cmp eax, 0
         je .print
         jmp .loop
.print:  cmp ecx, 0
         je .end
         pop eax
         pushad
         mov [byte_for_symb], al
         mov eax, 4
         mov ebx, 1
         mov ecx, byte_for_symb
         mov edx, 1
         int 0x80
         popad
         dec ecx
         jmp .print
.end:    popad
         ret

section '.print_str' executable
print_str:
         pushad
         mov eax, 4
         mov ebx, 1
         int 0x80
         popad
         ret
