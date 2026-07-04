# Variables for files
ASM_FILES = 230101059_seta.asm 230101059_setb.asm 230101059_setb_4.asm
OBJ_FILES = 230101059_seta.o 230101059_setb.o 230101059_setb_4.o
EXEC_FILES = 230101059_seta 230101059_setb 230101059_setb_4

# Default target
all: $(EXEC_FILES)

# Rule to assemble .asm to .o (32-bit)
%.o: %.asm
	nasm -f elf32 $< -o $@

# Rule to link .o to executable (32-bit emulation)
%: %.o
	ld -m elf_i386 $< -o $@

# Run commands
run_seta: 230101059_seta
	./230101059_seta

run_setb_6: 230101059_setb
	./230101059_setb

run_setb_4: 230101059_setb_4
	./230101059_setb_4

# Clean up build files
clean:
	rm -f $(OBJ_FILES) $(EXEC_FILES)