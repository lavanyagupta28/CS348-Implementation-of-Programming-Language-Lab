# Assignment 3 – nanoC Lexer
**Name:** Lavanya Gupta    
**Roll Number:** 230101059

---

## Files Submitted

| File | Description |
|---|---|
| `a3_230101059.l` | Flex specification for the nanoC lexer |
| `Makefile` | Build system |
| `a3_230101059_test.nc` | Test input covering all lexical rules |
| `README.md` | This file |

**Generated on execution:**

| File | Description |
|---|---|
| `a3_230101059_token.txt` | Token stream with line numbers |
| `a3_230101059_st.txt` | Symbol table of identifiers |

---

## How to Build and Run

```bash
# Build the lexer
make

# Run on the provided test file
make run

# Or run manually on any nanoC source
./a3_230101059 <inputfile.nc>

# Clean generated files
make clean
```

Manual build (without make):
```bash
flex a3_230101059.l
gcc -o a3_230101059 lex.yy.c -lfl
./a3_230101059 a3_230101059_test.nc
```

---

## Lexical Rules Implemented

### Keywords (21 total)
`break`, `case`, `char`, `continue`, `default`, `do`, `double`, `else`,
`float`, `for`, `if`, `int`, `long`, `return`, `short`, `signed`,
`static`, `unsigned`, `void`, `while`, `_Bool`

### Identifiers
Starts with a letter or underscore, followed by letters, digits, or
underscores. Inserted into the symbol table on first occurrence.

### Integer Constants
- `0` (zero)
- Non-zero digit followed by any digits (no leading zeros allowed)

### Floating-point Constants
- `digit-sequence . digit-sequence` (e.g., `3.14`)
- `. digit-sequence` (e.g., `.75`)
- `digit-sequence .` (e.g., `3.`)

### Character Constants
Single-quoted characters including escape sequences:
`\'`, `\"`, `\?`, `\\`, `\a`, `\b`, `\f`, `\n`, `\r`, `\t`, `\v`

### String Literals
Double-quoted sequences of source characters and escape sequences.

### Punctuators (all from spec)
`[`, `]`, `(`, `)`, `{`, `}`, `.`, `->`, `++`, `--`, `&`, `*`, `+`,
`-`, `~`, `!`, `/`, `%`, `<<`, `>>`, `<`, `>`, `<=`, `>=`, `==`,
`!=`, `^`, `|`, `&&`, `||`, `?`, `:`, `;`, `...`, `=`, `*=`, `/=`,
`%=`, `+=`, `-=`, `<<=`, `>>=`, `&=`, `^=`, `|=`, `,`, `#`

### Comments
- Block comments: `/* ... */` (non-nesting)
- Line comments: `// ...` (until end of line)

---

## Error Cases Handled

| Error | Example | Message |
|---|---|---|
| Unterminated block comment | `/* no close` | `Lexical Error: Unterminated block comment` |
| Leading zeros in integer | `007` | `Lexical Error: Invalid integer constant (leading zeros)` |
| Malformed float (multiple dots) | `1.2.3` | `Lexical Error: Malformed float constant` |
| Digit-starting token | `3abc` | `Lexical Error: Invalid token (identifier cannot start with digit)` |
| Unterminated char constant | `'a` (no close) | `Lexical Error: Unterminated character constant` |
| Empty char constant | `''` | `Lexical Error: Empty character constant` |
| Unterminated string (newline) | `"hello` + newline | `Lexical Error: Unterminated string literal (newline)` |
| Unterminated string (EOF) | `"hello` at EOF | `Lexical Error: Unterminated string literal (EOF)` |
| Unknown character | `@`, `` ` ``, `$` | `Lexical Error: Unknown character` |

---

## Design Notes

- **Rule ordering:** Longer tokens are listed before their shorter prefixes
  (e.g., `<<=` before `<<` before `<`) to ensure correct maximal-munch matching.
- **Float before Int:** `FLOATCONST` rules precede `INTCONST` so that `3.`
  is correctly tokenised as a float, not integer `3` followed by `.`.
- **Malformed float detection:** A dedicated rule catches patterns like
  `1.2.3` before the valid float rule can partially match.
- **Symbol table:** Uses a flat array with linear-search deduplication.
  Only identifiers (not keywords) are inserted.
