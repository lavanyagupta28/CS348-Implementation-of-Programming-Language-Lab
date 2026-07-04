# README

## Name
Lavanya Gupta

## Roll Number
230101059

## Question Number
- Set-A: 6  
- Set-B: 4
- Set-B: 6  

## Important Points & Assumptions
- The program is written in **32-bit x86 NASM assembly** and is intended to run on **Linux**.
- Linux system calls are invoked using **`int 0x80`**.
- The program terminates gracefully using the `exit` system call.
### Set-A : Question 6 (Star Pattern)

- The input value `n` is assumed to be a **positive integer** entered in **ASCII format**, followed by the Enter key.
- User input is read as a string and converted to an integer using a **custom ASCII-to-integer conversion routine**.
- A maximum of **10 bytes** is read for input, which is sufficient for standard integer values.
- The program prints an **inverted pyramid star pattern**:
  - Total number of rows = `n`
  - For row `i` (starting from 0):
    - `i` leading spaces are printed
    - `2 × (n − i) − 1` stars are printed
- Output is written to **standard output (stdout)** using the `write` system call.
- The program does **not perform input validation** for negative or non-numeric inputs.

### Set-B : Question 4 

- Each character of the input string is processed **individually** based on its ASCII value.
- For **alphabetic characters**, replacement is **case-sensitive**:
  - Uppercase letters from `A` to `Y` are replaced by their next ASCII character.
  - Lowercase letters from `a` to `y` are replaced by their next ASCII character.
- **Special replacement rules** are applied at boundary ranges:
  - The character `Z` is replaced with `a`.
  - The character `z` is replaced with `A`.
  - **Characters with ASCII values between `Z` (90) and `a` (97)** are replaced with `a`.
- Characters with ASCII values **less than `A`** or **greater than `z`** are replaced with `A`.
- The **newline character (`\n`) is preserved** and not modified.
- All transformations are performed strictly using **ASCII comparisons**, with no additional input validation.

### Set-B : Question 6 (Transpose of N × N Matrix)
- The matrix size `N` is taken as **user input** and is assumed to be a **positive integer**.
- The maximum supported matrix size is **10 × 10**, as storage is statically allocated for **100 elements**.
- All matrix elements are taken as **integer inputs** from the user.
- Matrix elements should be entered one by one. The read_int routine expects a delimiter (like a newline) after each integer.
- Matrix elements are stored in **row-major order** in linear memory.
- The transpose of the matrix is computed by swapping indices:
  - `transposed[j][i] = matrix[i][j]`
- A separate memory space is used to store the **transposed matrix**.
- Input integers are read using a **custom integer input routine** (`read_int`).
- Output integers are printed using a **custom integer output routine** (`write_int`).
- No validation is performed for:
  - Negative values of `N`
  - Matrix sizes exceeding `10 × 10`
  - Non-numeric input
- Output is printed to **standard output (stdout)** with proper spacing and newlines.

## Commands to Compile, Execute, and Clean

### Compile
```bash
make
```
### Execute Set A: 6
```bash
make run_seta
```
- Enter the input value n


### Execute Set B: 6
```bash
make run_setb_6
```
- Enter the size of matrix (N)
- Enter N*N elements one at a time 

### Execute Set B: 4
```bash
make run_setb_4
```
- Enter input string s
