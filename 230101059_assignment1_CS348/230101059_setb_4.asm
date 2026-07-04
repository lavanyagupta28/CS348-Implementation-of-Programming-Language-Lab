section .data
    prompt db "Enter input string:", 10
    plen   equ $ - prompt

section .bss
    input  resb 100
    output resb 100

section .text
    global _start

_start:
    ; Print Prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, plen
    int 0x80

    ; Read Input
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 100
    int 0x80

    mov esi, input
    mov edi, output
    mov ecx, eax        ; Number of bytes read

process_loop:
    cmp ecx, 0      
    jle print          
    
    mov al, [esi]

    ; 1. Preserve Newline
    cmp al, 10
    je store_char

    ; 2. Catch everything below 'A' (includes @, 0-9, space)
    cmp al, 'A'
    jb set_A

    ; 3. Handle >= 'z' (122) rule
    cmp al, 122
    jae set_A

    ; 4. Handle >= 'Z' and < 'a' rule
    cmp al, 90
    jb do_inc           ; It's A-Y, so just increment
    cmp al, 97
    jb set_a            ; It's between Z and a, set to 'a'

do_inc:
    inc al
    jmp store_char

set_A:
    mov al, 'A'
    jmp store_char

set_a:
    mov al, 'a'

store_char:
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jmp process_loop

print:
    ; Calculate final length based on how many chars we stored in edi
    mov edx, edi
    sub edx, output
    
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80