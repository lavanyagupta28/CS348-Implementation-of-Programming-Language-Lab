# Assignment 4: Parser for nanoC

**Name:** Lavanya Gupta  
**Roll No:** 230101059

---

## Files Included

1. `a4_230101059.l` - Flex specification for the lexical analysis of nanoC.
2. `a4_230101059.y` - Bison specification for the syntax analysis (phrase structure grammar) of nanoC.
3. `a4_230101059_test.nc` - A test file containing valid nanoC code to evaluate all grammar rules.
4. `Makefile` - Script to automate the compilation and build process.
5. `README.md` - This documentation file.

---

## Compilation and Execution

A `Makefile` is provided to make the build process easy.

**1. Compile the lexer and parser:**
Open your terminal in the directory containing the files and run:
```bash
make
```
This executes the flex and yacc commands and compiles the generated C files into an executable named `a.out`.

**2. Test the parser:**
Run the executable and pass the test file as input:
```bash
./a.out < a4_230101059_test.nc
```
Expected output on success:
```
Parsing Completed Successfully. No syntax errors found.
```

**3. Clean up generated files:**
To remove the compiled binaries and generated C files, run:
```bash
make clean
```


