# IPLL (CS348)

A collection of laboratory assignments completed as part of the **Implementation of Programming Languages Laboratory (CS348)** at IIT Guwahati. The assignments introduce the core stages of programming language implementation, beginning with x86 assembly programming and progressing through assembler construction, lexical analysis, and syntax analysis for a subset of the C programming language (nanoC).

## Repository Overview

| Assignment | Topic | Technologies |
| :--- | :--- | :--- |
| **Assignment 1** | x86 Assembly Programming | NASM, Linux System Calls |
| **Assignment 2** | SIC Assembler | C |
| **Assignment 3** | Lexical Analyzer for nanoC | Flex (Lex), C |
| **Assignment 4** | Parser for nanoC | Flex, Bison (Yacc), C |

These assignments cover the initial phases of compiler construction:

1. Assembly Programming
2. Assembler Design
3. Lexical Analysis
4. Syntax Analysis

---

## Repository Structure

```text
CS348-Implementation-of-Programming-Language-Lab/
│
├── 230101059_assignment1_CS348/
│   ├── 230101059_seta_6.asm
│   ├── 230101059_setb_4.asm
│   ├── 230101059_setb_6.asm
│   ├── Assignment 1_SET A.pdf
│   ├── Assignment 1_SET B.pdf
│   ├── Makefile
│   └── readme.md
│
├── 230101059_assignment2_CS348/
│   ├── OnePass.c
│   ├── TwoPass.c
│   ├── Assignment 2.pdf
│   ├── opcodes.txt
│   ├── sample_input.txt
│   ├── sample_intermediate.txt
│   ├── sample_output.txt
│   └── README.md
│
├── 230101059_assignment3_CS348/
│   ├── a3_230101059.l
│   ├── a3_230101059_test.nc
│   ├── Assignment3.pdf
│   ├── Makefile
│   └── README.md
│
└── 230101059_assignment4_CS348/
    ├── a4_230101059.l
    ├── a4_230101059.y
    ├── a4_230101059_test.nc
    ├── Assignment4.pdf
    ├── Makefile
    └── README.md
```

---

## Assignment 1 – x86 Assembly Programming

Implements selected problems in **32-bit x86 assembly** using NASM and Linux system calls. The assignment provides hands-on experience with low-level programming, registers, memory operations, arithmetic, and system calls.

### Build

```bash
make
```

or

```bash
nasm -f elf32 <program>.asm -o program.o
ld -m elf_i386 -o program program.o
./program
```

---

## Assignment 2 – SIC Assembler

Implements **One-Pass** and **Two-Pass** assemblers for the Simplified Instructional Computer (SIC).

### One-Pass Assembler

- Generates object code in a single scan
- Builds the symbol table
- Handles forward references

### Two-Pass Assembler

- **Pass 1:** Computes addresses and constructs the symbol table
- **Pass 2:** Resolves symbols and generates object code

### Compile

```bash
gcc OnePass.c -o onepass
gcc TwoPass.c -o twopass
```

### Run

```bash
./onepass
```

or

```bash
./twopass
```

---

## Assignment 3 – Lexical Analyzer for nanoC

Implements a lexical analyzer for the nanoC language using **Flex**.

### Features

- Tokenizes nanoC source programs
- Recognizes keywords, identifiers, operators, literals, and delimiters
- Reports lexical errors

### Build

```bash
make
```

### Run

```bash
make run
```

---

## Assignment 4 – Parser for nanoC

Implements a parser for nanoC using **Flex** and **Bison**.

### Features

- Parses nanoC programs according to the specified grammar
- Validates program syntax
- Reports syntax errors

### Build

```bash
make
```

### Run

```bash
make run
```

---

## Prerequisites

Install the required tools on Linux/WSL:

```bash
sudo apt update
sudo apt install gcc make flex bison nasm
```

---

## Author

**Lavanya Gupta**  
Roll No. **230101059**  
B.Tech, Computer Science and Engineering (2023–2027)  
Indian Institute of Technology Guwahati
