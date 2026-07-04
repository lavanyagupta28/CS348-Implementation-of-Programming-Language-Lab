section .data
    msg_n       db "Enter N: ", 0
    len_n       equ $ - msg_n
    msg_elem    db "Enter element: ", 0
    len_elem    equ $ - msg_elem
    msg_res     db "Transposed Matrix:", 10, 0
    len_res     equ $ - msg_res
    newline     db 10
    space       db " "

section .bss
    n           resd 1
    matrix      resd 100    ; Max 10x10
    transposed  resd 100
    buffer      resb 16     ; For string/int conversion

section .text
    global _start

_start:
    ; Print "Enter N: "
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, msg_n
    mov edx, len_n
    int 0x80

    call read_int
    mov [n], eax
    
    imul eax, eax
    mov ecx, eax
    mov edi, 0

    ; Read Matrix Elements
read_i:
    cmp ecx, 0
    jle transpose_start
    
    push ecx
    push edi
    call read_int
    pop edi
    pop ecx
    mov [matrix + 4*edi], eax
    inc edi
    dec ecx
    jmp read_i

transpose_start:
    mov esi, 0
t_i:
    cmp esi, [n]
    jge print_start
    mov edi, 0
t_j:
    cmp edi, [n]
    jge next_t_row

    ; Load matrix[esi][edi]
    mov eax, esi
    mul dword [n]
    add eax, edi
    mov ebx, [matrix + eax*4]

    ; Store in transposed[edi][esi]
    mov eax, edi
    mul dword [n]
    add eax, esi
    mov [transposed + eax*4], ebx

    inc edi
    jmp t_j
next_t_row:
    inc esi
    jmp t_i

print_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_res
    mov edx, len_res
    int 0x80

    mov esi, 0
p_i:
    cmp esi, [n]
    jge exit
    mov edi, 0
p_j:
    cmp edi, [n]
    jge next_p_row

    mov eax, esi
    mul dword [n]
    add eax, edi
    mov eax, [transposed + eax*4]

    call write_int

    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80

    inc edi
    jmp p_j
next_p_row:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    inc esi
    jmp p_i

exit:
    mov eax, 1              ; sys_exit
    xor ebx, ebx
    int 0x80

; --- Helper: Read Integer from Stdin ---
read_int:
    mov eax, 3              ; sys_read
    mov ebx, 0              ; stdin
    mov ecx, buffer
    mov edx, 16             ; max bytes to read
    int 0x80

    mov ecx, eax            ; number of bytes read
    mov esi, buffer
    xor eax, eax            ; clear result
    xor ebx, ebx            ; clear digit
.loop:
    mov bl, [esi]
    cmp bl, 10              ; check newline
    je .done
    
    cmp bl, 0
    je .done
    
    cmp bl, ' '
    je .done
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    loop .loop
.done:
    ret

; --- Helper: Write Integer to Stdout ---
write_int:
    mov ecx, buffer + 15
    mov byte [ecx], 0
    mov ebx, 10
.loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .loop
    
    ; Print the number string
    push ecx
    mov eax, 4
    mov ebx, 1
    ; Calculate length
    mov edx, buffer + 15        ; ecx points to the start of the int   
    sub edx, ecx
    pop ecx                     ; we need to print the intege stored in ecx
    int 0x80
    ret