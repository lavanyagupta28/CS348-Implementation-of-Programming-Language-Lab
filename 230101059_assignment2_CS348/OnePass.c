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

struct OBJCODE
{
    int addr;
    char code[10];
    char operand[20];
    int indexed;
    int needsBackpatch;
} objcodes[MAX];

int symcount = 0, opcount = 0, objcount = 0;
int startAddr = 0, progLen = 0;

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

void addSymbol(char *label, int addr)
{
    if (searchSym(label) == -1)
    {
        strcpy(symtab[symcount].label, label);
        symtab[symcount].addr = addr;
        symcount++;
    }
}

/* ------------ BACKPATCHING ------------ */

void backpatch()
{
    for (int i = 0; i < objcount; i++)
    {
        if (objcodes[i].needsBackpatch)
        {
            int symIdx = searchSym(objcodes[i].operand);
            if (symIdx != -1)
            {
                int addr = symtab[symIdx].addr;
                
                // Apply indexed addressing flag
                if (objcodes[i].indexed)
                    addr += 0x8000;
                
                // Update object code (keep opcode, update address)
                // first 2 bits are of opcode, next 4 bits of address in hexadecimal form
                sprintf(objcodes[i].code + 2, "%04X", addr); 
                objcodes[i].needsBackpatch = 0;
            }
        }
    }
}

/* ------------ ONE PASS ASSEMBLER ------------ */

void onePassAssembler()
{
    FILE *fp = fopen("sample_input.txt", "r");
    FILE *out = fopen("output.txt", "w");

    if (!fp || !out)
    {
        printf("File error\n");
        return;
    }

    char line[100], label[20], opcode[20], operand[50];
    int LOCCTR = 0;
    char progName[20] = "";

    /* ---- Read First Line ---- */
    if (fgets(line, 100, fp))
    {
        sscanf(line, "%s %s %s", label, opcode, operand);

        if (strcmp(opcode, "START") == 0)
        {
            strcpy(progName, label);
            startAddr = (int)strtol(operand, NULL, 16);
            LOCCTR = startAddr;
        }
        else
        {
            LOCCTR = 0;
            startAddr = 0;
            rewind(fp);
        }
    }

    /* ---- Process All Lines ---- */
    while (fgets(line, 100, fp))
    {
        /* ---- If Comment Line ---- */
        if (line[0] == '.')
            continue;

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
            if (searchOp(t1) != -1)
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

        /* ---- Check for END ---- */
        if (strcmp(opcode, "END") == 0)
            break;

        /* ---- Add Label to Symbol Table ---- */
        if (strcmp(label, "-") != 0)
        {
            addSymbol(label, LOCCTR);
        }

        char obj[20] = "";
        int objBytes = 0;
        int needsBackpatch = 0;

        /* ---- Generate Object Code ---- */
        if (searchOp(opcode) != -1)
        {
            int opIdx = searchOp(opcode);
            int target = 0;
            char tempOp[20];
            strcpy(tempOp, operand);
            int indexed = 0;

            if (strcmp(operand, "-") != 0)
            {
                // Check for indexed addressing
                char *commaPos = strchr(tempOp, ',');
                if (commaPos != NULL)
                {
                    *commaPos = '\0';  // Remove ,X part
                    indexed = 1;
                }

                int symIdx = searchSym(tempOp);
                if (symIdx != -1)
                {
                    // Symbol found
                    target = symtab[symIdx].addr;
                    if (indexed)
                        target += 0x8000;
                }
                else
                {
                    // Forward reference
                    needsBackpatch = 1;
                    target = 0;
                }
            }

            sprintf(obj, "%s%04X", optab[opIdx].opcode, target);
            objBytes = 3;

            // Store object code for potential backpatching
            objcodes[objcount].addr = LOCCTR;
            strcpy(objcodes[objcount].code, obj);
            strcpy(objcodes[objcount].operand, tempOp);
            objcodes[objcount].indexed = indexed;
            objcodes[objcount].needsBackpatch = needsBackpatch;
            objcount++;
        }
        else if (strcmp(opcode, "WORD") == 0)
        {
            sprintf(obj, "%06X", atoi(operand));
            objBytes = 3;

            objcodes[objcount].addr = LOCCTR;
            strcpy(objcodes[objcount].code, obj);
            objcodes[objcount].needsBackpatch = 0;
            objcodes[objcount].indexed = 0;
            objcount++;
        }
        else if (strcmp(opcode, "BYTE") == 0)
        {
            if (operand[0] == 'C')
            {
                for (int i = 2; i < strlen(operand) - 1; i++)
                {
                    char t[3];
                    sprintf(t, "%02X", (unsigned char)operand[i]);
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
            objBytes = strlen(obj) / 2; // since object code is stored in hexadecimal format

            objcodes[objcount].addr = LOCCTR;
            strcpy(objcodes[objcount].code, obj);
            objcodes[objcount].needsBackpatch = 0;
            objcodes[objcount].indexed = 0;
            objcount++;
        }

        /* ---- Update LOCCTR ---- */
        if (strcmp(opcode, "RESW") == 0)
            LOCCTR += 3 * atoi(operand);
        else if (strcmp(opcode, "RESB") == 0)
            LOCCTR += atoi(operand);
        else
            LOCCTR += objBytes;
    }

    progLen = LOCCTR - startAddr;

    /* ---- Backpatch Forward References ---- */
    backpatch();

    /* ---- Write Header Record ---- */
    fprintf(out, "H%-6s%06X%06X\n", progName, startAddr, progLen);

    /* ---- Write Text Records ---- */
    char text[70] = "";
    int textStart = 0, textLen = 0;

    for (int i = 0; i < objcount; i++)
    {
        int objBytes = strlen(objcodes[i].code) / 2;

        // Check if we need to start a new text record
        if (textLen + objBytes > 30 || 
            (textLen > 0 && objcodes[i].addr != textStart + textLen))
        {
            fprintf(out, "T%06X%02X%s\n", textStart, textLen, text);
            text[0] = '\0';
            textLen = 0;
        }

        if (textLen == 0)
            textStart = objcodes[i].addr;

        strcat(text, objcodes[i].code);
        textLen += objBytes;
    }

    /* ---- Write Last Text Record ---- */
    if (textLen > 0)
        fprintf(out, "T%06X%02X%s\n", textStart, textLen, text);

    /* ---- Write End Record ---- */
    fprintf(out, "E%06X\n", startAddr);

    fclose(fp);
    fclose(out);

    printf("\n========================================\n");
    printf("   ONE PASS ASSEMBLER COMPLETED\n");
    printf("========================================\n");
    printf("Program Name   : %s\n", progName);
    printf("Start Address  : %04X\n", startAddr);
    printf("Program Length : %04X (%d bytes)\n", progLen, progLen);

    printf("\n----- SYMBOL TABLE -----\n");
    printf("%-15s Address\n", "Label");
    printf("---------------------------\n");
    for (int i = 0; i < symcount; i++)
        printf("%-15s %04X\n", symtab[i].label, symtab[i].addr);

    printf("\n========================================\n");
    printf("Object code written to: output.txt\n");
    printf("========================================\n");
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

    /* ---- Load Opcode Table ---- */
    while (fscanf(op, "%s %s", optab[opcount].mnemonic, optab[opcount].opcode) != EOF)
        opcount++;

    fclose(op);

    onePassAssembler();

    return 0;
}