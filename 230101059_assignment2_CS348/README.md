# SIC Assembler - One Pass & Two Pass
### Name: Lavanya Gupta
### Roll No: 230101059
## Description
Implementation of both **One Pass** and **Two Pass** Assemblers for SIC (Simplified Instructional Computer) that convert assembly code to object code.

## Files
- `230101059_onepass.c` - One pass assembler
- `230101059_twopass.c` - Two pass assembler
- `opcodes.txt` - Opcode definitions (required)
- `sample_input.txt` - Assembly source code

## How to Run

### One Pass Assembler
```bash
# Compile
gcc 230101059_onepass.c -o onepass

# Execute
./onepass
```

### Two Pass Assembler
```bash
# Compile
gcc 230101059_twopass.c -o twopass

# Execute
./twopass
```

## Output Files

### Both Assemblers Generate:
- `output.txt` - Object code in SIC format

### Two Pass Also Generates:
- `intermediate.txt` - Intermediate file with addresses

## Output Format
```
H - Header:  H<program_name><start_address><length>
T - Text:    T<start_address><length><object_code>
E - End:     E<start_address>
```

## Key Differences

| Feature | One Pass | Two Pass |
|---------|----------|----------|
| Passes | 1 | 2 |
| Forward references | Backpatching | Symbol lookup |
| Intermediate file | No | Yes |

## Features
- Forward reference resolution
- Indexed addressing (,X)
- Directives: START, END, BYTE, WORD, RESB, RESW
- Comment lines (start with '.')
