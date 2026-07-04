/* ============================================================
   a3_230101059_test.nc
   Test file for nanoC Lexer – CS348 Assignment 3
   Tests: keywords, identifiers, integer/float/char/string constants,
          all punctuators, comments, and lexical error cases.
   ============================================================ */

// ── 1. All keywords ──────────────────────────────────────────
break case char continue default do double else float for
if int long return short signed static unsigned void while _Bool

// ── 2. Valid identifiers ─────────────────────────────────────
main foo _bar x1 _Bool2 myVariable UPPER_CASE a

// ── 3. Integer constants ─────────────────────────────────────
0
1
42
1000
9999

// ── 4. Floating-point constants ──────────────────────────────
3.14
0.5
.75
100.
3.0
0.0

// ── 5. Character constants ───────────────────────────────────
'a'
'Z'
'0'
' '
'\n'
'\t'
'\\'
'\''
'\"'
'\?'
'\a'
'\b'
'\f'
'\r'
'\v'

// ── 6. String literals ───────────────────────────────────────
"hello world"
"escape: \n \t \\ \""
"empty string follows:"
""
"mix 123 !@#"

// ── 7. Ellipsis punctuator (often missed) ───────────────────
// The ... punctuator:
// void f(int x, ...) { }

// ── 8. All punctuators ───────────────────────────────────────
int arr[10];
int *ptr;
int a2 = (3 + 4) * 2 - 1;
int b2 = a2 / 2 % 3;
int c2 = ~a2 & b2 | 7 ^ 3;
int d2 = a2 << 1;
int e2 = a2 >> 1;

// Compound assignment operators
int x2 = 0;
x2 += 5;
x2 -= 2;
x2 *= 3;
x2 /= 4;
x2 %= 2;
x2 &= 0xFF;
x2 |= 0x01;
x2 ^= 0x10;
x2 <<= 1;
x2 >>= 1;

// Comparison and logical
int cmp;
cmp = (x2 == 0);
cmp = (x2 != 0);
cmp = (x2 < 5);
cmp = (x2 > 5);
cmp = (x2 <= 5);
cmp = (x2 >= 5);
cmp = (cmp && 1);
cmp = (cmp || 0);

// Increment / decrement
x2++;
x2--;
++x2;
--x2;

// Ternary, colon, semicolon, comma
int y2 = (x2 > 0) ? x2 : 0;

// Struct/pointer operators (-> and .)
// struct S { int v; } s, *sp;
// s.v = 1;
// sp->v = 2;

// Hash (preprocessor, treated as punctuator in nanoC)
#

// Ellipsis
...

// ── 9. Multi-line comment ────────────────────────────────────
/*
   This is a
   multi-line comment.
*/

// ── 10. ERROR CASES ─────────────────────────────────────────

// 10a. Leading-zero integers (invalid)
007
042
00

// 10b. Malformed float (multiple dots)
1.2.3
0..5

// 10c. Digit-starting invalid token (not a valid id or int)
3abc
12xyz

// 10d. Unterminated character constant (newline inside)
'a
// (the above line intentionally has no closing quote before newline)

// 10e. Empty character constant
''

// 10f. Unterminated string literal (newline inside)
"unterminated string
// (the above line intentionally has no closing quote)

// 10g. Unknown / illegal character
@
`
$

// 10h. Unterminated block comment (must be last, terminates scanning)
/* this comment is never closed
