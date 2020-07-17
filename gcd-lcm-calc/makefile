.PHONY: default run
run: 
	fasm gcd_lcm_calc.asm
	ld -m elf_i386 -s -o gcd_lcm_calc gcd_lcm_calc.o
	./gcd_lcm_calc
