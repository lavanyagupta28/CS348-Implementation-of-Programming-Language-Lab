section .data
    star db '*'
    space db ' '
    newline db 10
    prompt db "Enter n: ", 10
    prompt_len equ $ - prompt

section .bss
    input resd 1

section .text
    global _start

_start:
    ; ---------- Print prompt ----------
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; ---------- Read input ----------
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 10 ; can read upto 10 bytes
    int 0x80
    

    ; ---------- ASCII TO INTEGER ----------
    ; can use atoi c function or can implement atoi like this
    xor eax, eax     
    mov esi, input  

convert_loop:
    movzx ebx, byte [esi]
    cmp bl, 10        ; Check for newline (Enter key)
    je conversion_done
    cmp bl, 0         ; Check for null terminator
    je conversion_done
    
    sub bl, '0'       
    imul eax, 10      
    add eax, ebx      
    
    inc esi
    jmp convert_loop

conversion_done:
    mov [input], eax
    mov esi, eax      ; esi = n
    xor edi, edi      ; row index = 0

; ROW LOOP
outer_loop:
    cmp edi, esi
    je exit_program

    ; ---------- Print spaces (i spaces) ----------
    mov ebp, edi         ; ebp = space counter

space_loop:
    cmp ebp, 0
    je print_stars
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80
    dec ebp
    jmp space_loop

; ---------- Print stars (2*(n-i)-1) ----------
print_stars:
    mov eax, esi
    sub eax, edi
    shl eax, 1
    dec eax
    mov ebp, eax         ; ebp = star counter

star_loop:
    cmp ebp, 0
    je new_line
    mov eax, 4
    mov ebx, 1
    mov ecx, star
    mov edx, 1
    int 0x80
    dec ebp
    jmp star_loop

; ---------- New line ----------
new_line:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    inc edi
    jmp outer_loop

; ---------- Exit ----------
exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
