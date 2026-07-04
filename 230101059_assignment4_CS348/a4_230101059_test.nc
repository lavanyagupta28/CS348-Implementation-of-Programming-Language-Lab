/* a4_230101059_test.nc - Comprehensive nanoC test file */

/* --- Global declarations --- */
long x = 100;
short y = 20;
float z = 3.14;
_Bool flag = 1;
long arr[10];
long bit_val = 8;
/* --- Helper function --- */
int add(int a, int b) {
    return a + b;
}

/* --- Variadic function --- */
int my_printf(char *fmt, ...) {
    return 0;
}

/* --- Pointer parameter --- */
void set_val(int *p, int val) {
    *p = val;
}

/* --- Main function: tests all statements --- */
int main(void) {

    /* selection statements */
    if (x >= y && flag) {
        x += 5;
    } else {
        y -= 2;
    }

    /* while loop */
    while (x > 0) {
        x--;
        if (x == 50) {
            continue;
        }
    }

    /* do-while */
    do {
        y *= 2;
    } while (y < 100);

    /* for loop with declaration */
    for (short i = 0; i < 10; i++) {
        arr[i] = i * 2;
    }

    /* for loop expression form */
    for (x = 0; x < 5; x++) {
        arr[x] = x;
    }

    /* for loop empty form */
    for (;;) {
        break;
    }

    /* bitwise and shift */
    bit_val = bit_val << 2;
    bit_val ^= 15;
    bit_val &= 255;
    bit_val |= 1;
    bit_val >>= 1;

    /* all assignment operators */
    x = 10;
    x += 1;
    x -= 1;
    x *= 2;
    x /= 2;
    x %= 3;
    x <<= 1;
    x >>= 1;
    x &= 7;
    x ^= 3;
    x |= 1;

    /* unary operators */
    x = -x;
    x = +x;
    x = ~x;
    flag = !flag;

    /* conditional expression */
    x = (x > 0) ? x : -x;

    /* comma expression */
    x = (x = 1, y = 2, x + y);

    /* function call */
    x = add(3, 4);

    /* pointer use */
    int *p;
    set_val(p, 42);

    /* array subscript */
    arr[0] = arr[1] + arr[2];

    /* post-increment / decrement */
    x++;
    x--;

    /* pre-increment / decrement */
    ++x;
    --x;

    /* labeled statements */
    loop_start:
        x = 0;

    case 1:
        x = 10;

    default:
        x = 0;

    /* nested if-else (dangling-else) */
    if (x > 0)
        if (y > 0)
            x = 1;
        else
            x = -1;

    /* logical operators */
    flag = (x > 0 && y > 0);
    flag = (x > 0 || y < 0);

    /* equality / relational */
    flag = (x == y);
    flag = (x != y);
    flag = (x < y);
    flag = (x > y);
    flag = (x <= y);
    flag = (x >= y);

    /* compound statement (nested block) */
    {
        int local = 5;
        local *= 2;
    }

    /* empty statement */
    ;

    /* declaration with brace initializer */
    int vec[3] = {1, 2, 3};

    /* designated initializer */
    int des[5] = {[2] = 99};

    /* string literal */
    char *msg = "hello";

    /* char constant */
    char ch = 'A';

    /* multiple declarators */
    int a, b, c;
    a = b = c = 0;

    return 0;
}
