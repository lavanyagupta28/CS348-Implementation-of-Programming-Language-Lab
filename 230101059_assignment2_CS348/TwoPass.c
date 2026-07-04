#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 100

struct SYMTAB
{
    char label[20];
    int addr;
} symtab[MAX];

struct OPTAB
{
    char mnemonic[10];
    char opcode[3];
} optab[MAX];

int symcount = 0, opcount = 0;
int startAddr = 0, progLen = 0;
int errorFlag = 0;

/* ------------ SEARCH FUNCTIONS ------------ */

int searchSym(char *label)
{
    for (int i = 0; i < symcount; i++)
        if (strcmp(symtab[i].label, label) == 0)
            return i;
    return -1;
}

int searchOp(char *mnemonic)
{
    for (int i = 0; i < opcount; i++)
        if (strcmp(optab[i].mnemonic, mnemonic) == 0)
            return i;
    return -1;
}

/* ------------ PASS 1 ------------ */

void pass1()
{
    FILE *fp = fopen("sample_input.txt", "r");
    FILE *inter = fopen("intermediate.txt", "w");

    if (!fp || !inter)
    {
        printf("File error\n");
        return;
    }

    char line[100], label[20], opcode[20], operand[50];
    int LOCCTR = 0;

    /* ---- Read First Line ---- */
    if (fgets(line, 100, fp))
    {
        sscanf(line, "%s %s %s", label, opcode, operand);

        if (strcmp(opcode, "START") == 0)
        {
            startAddr = (int)strtol(operand, NULL, 16);
            LOCCTR = startAddr;
            fprintf(inter, "%04X %s %s %s\n", LOCCTR, label, opcode, operand);
        }
        else
        {
            LOCCTR = 0;
            rewind(fp);
        }
    }

    /* ---- Process Remaining Lines ---- */
    while (fgets(line, 100, fp))
    {

        /* ---- If Comment Line ---- */
        if (line[0] == '.')
        {
            fprintf(inter, "%s", line); // print comment as it is
            continue;
        }

        if (line[0] == '\n')
            continue;

        char t1[20], t2[20], t3[20];
        int count = sscanf(line, "%s %s %s", t1, t2, t3);

        if (count == 3)
        {
            strcpy(label, t1);
            strcpy(opcode, t2);
            strcpy(operand, t3);
        }
        else if (count == 2)
        {
            if (searchOp(t1) != -1 ||
                strcmp(t1, "START") == 0 ||
                strcmp(t1, "END") == 0 ||
                strcmp(t1, "WORD") == 0 ||
                strcmp(t1, "RESW") == 0 ||
                strcmp(t1, "RESB") == 0 ||
                strcmp(t1, "BYTE") == 0)
            {
                strcpy(label, "-");
                strcpy(opcode, t1);
                strcpy(operand, t2);
            }
            else
            {
                strcpy(label, t1);
                strcpy(opcode, t2);
                strcpy(operand, "-");
            }
        }
        else if (count == 1)
        {
            strcpy(label, "-");
            strcpy(opcode, t1);
            strcpy(operand, "-");
        }

        fprintf(inter, "%04X %s %s %s\n", LOCCTR, label, opcode, operand);

        /* ---- Add to Symbol Table ---- */
        if (strcmp(label, "-") != 0)
        {
            if (searchSym(label) != -1)
            {
                printf("ERROR: Duplicate symbol '%s'\n", label);
                errorFlag = 1;
            }
            else
            {
                strcpy(symtab[symcount].label, label);
                symtab[symcount++].addr = LOCCTR;
            }
        }

        /* ---- Update LOCCTR ---- */
        if (searchOp(opcode) != -1)
            LOCCTR += 3;

        else if (strcmp(opcode, "WORD") == 0)
            LOCCTR += 3;

        else if (strcmp(opcode, "RESW") == 0)
            LOCCTR += 3 * atoi(operand);

        else if (strcmp(opcode, "RESB") == 0)
            LOCCTR += atoi(operand);

        else if (strcmp(opcode, "BYTE") == 0)
        {
            if (operand[0] == 'C')
                LOCCTR += strlen(operand) - 3;
            else if (operand[0] == 'X')
                LOCCTR += (strlen(operand) - 3) / 2;
        }

        else if (strcmp(opcode, "END") == 0)
            break;
        else
        {
            printf("ERROR: Invalid opcode '%s'\n", opcode);
            errorFlag = 1;
        }
    }
    if (errorFlag)
    {
        printf("Assembly failed due to errors.\n");
        exit(1);
    }
    progLen = LOCCTR - startAddr;

    fclose(fp);
    fclose(inter);
    printf("\n----- SYMBOL TABLE -----\n");
    printf("Label\tAddress\n");
    printf("------------------------\n");

    for (int i = 0; i < symcount; i++)
    {
        printf("%-10s %04X\n", symtab[i].label, symtab[i].addr);
    }
}

/* ------------ PASS 2 ------------ */

void pass2()
{
    FILE *inter = fopen("intermediate.txt", "r");
    FILE *out = fopen("output.txt", "w");

    char line[100], label[20], opcode[20], operand[50];
    int addr;

    char text[70] = "";
    int textStart = 0, textLen = 0;

    fgets(line, 100, inter);
    sscanf(line, "%X %s %s %s", &addr, label, opcode, operand);

    fprintf(out, "H%-6s%06X%06X\n", label, startAddr, progLen);

    while (fgets(line, 100, inter))
    {

        if (line[0] == '.') // skip comment lines in pass2
            continue;

        sscanf(line, "%X %s %s %s", &addr, label, opcode, operand);

        if (strcmp(opcode, "END") == 0)
            break;

        char obj[20] = "";
        int objBytes = 0;

        if (strcmp(opcode, "RSUB") == 0)
        {
            strcpy(obj, "4C0000");
            objBytes = 3;
        }

        else if (searchOp(opcode) != -1)
        {
            int opIdx = searchOp(opcode);
            int target = 0;  // stores address
            char tempOp[20];
            strcpy(tempOp, operand);

            if (strstr(tempOp, ",X"))
            {
                tempOp[strlen(tempOp) - 2] = '\0';
                target = 0x8000;
            }

            int s = searchSym(tempOp);
            if (s != -1)
                target += symtab[s].addr;

            sprintf(obj, "%s%04X", optab[opIdx].opcode, target);
            objBytes = 3;
        }

        else if (strcmp(opcode, "WORD") == 0)
        {
            sprintf(obj, "%06X", atoi(operand));
            objBytes = 3;
        }

        else if (strcmp(opcode, "BYTE") == 0)
        {
            if (operand[0] == 'C')
            {
                for (int i = 2; i < strlen(operand) - 1; i++)
                {
                    char t[3];
                    sprintf(t, "%02X", operand[i]);
                    strcat(obj, t);
                }
            }
            else if (operand[0] == 'X')
            {
                for (int i = 2; i < strlen(operand) - 1; i++)
                {
                    char t[2] = {operand[i], '\0'};
                    strcat(obj, t);
                }
            }
            objBytes = strlen(obj) / 2;
        }

        /* ---- Text Record Handling ---- */
        if (strcmp(opcode, "RESW") == 0 ||
            strcmp(opcode, "RESB") == 0 ||
            (textLen + objBytes > 30))
        {

            if (textLen > 0)
                fprintf(out, "T%06X%02X%s\n", textStart, textLen, text);

            text[0] = '\0';
            textLen = 0;

            if (strcmp(opcode, "RESW") == 0 ||
                strcmp(opcode, "RESB") == 0)
                continue;
        }

        if (textLen == 0)
            textStart = addr;

        strcat(text, obj);
        textLen += objBytes;
    }

    if (textLen > 0)
        fprintf(out, "T%06X%02X%s\n", textStart, textLen, text);

    fprintf(out, "E%06X\n", startAddr);

    fclose(inter);
    fclose(out);
}

/* ------------ MAIN ------------ */

int main()
{
    FILE *op = fopen("opcodes.txt", "r");

    if (!op)
    {
        printf("Error: opcodes.txt not found\n");
        return 1;
    }

    while (fscanf(op, "%s %s",
                  optab[opcount].mnemonic,
                  optab[opcount].opcode) != EOF)
        opcount++;

    fclose(op);

    pass1();
    pass2();

    printf("Assembly Completed. Check output.txt\n");
    return 0;
}
