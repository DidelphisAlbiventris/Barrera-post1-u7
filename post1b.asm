; Johan Barrera - Cod. 1152538
; Arquitectura de computadores - Unidad 7
; Compilar desde la raiz: nasm -f bin post1b.asm -o post1b.com
bits 16
cpu 8086
org 100h
jmp inicio
ayuda db 'POST1B - Cursor y atributos. Pulse una tecla para salir.',0
inicio:
    push cs
    pop ds
    cld
    call iniciar_bios
    mov si, ayuda
    mov dx, 1202h
    mov bl, 07h
    call cadena_bios
    ; A amarilla sobre fondo azul: fila 2, columna 10.
    mov ah, 02h
    xor bh, bh
    mov dx, 020Ah
    int 10h
    mov ah, 09h
    mov al, 'A'
    xor bh, bh
    mov bl, 1Eh
    mov cx, 1
    int 10h
    ; U7 roja clara: fila 3, columnas 10 y 11.
    mov ah, 02h
    xor bh, bh
    mov dx, 030Ah
    int 10h
    mov ah, 09h
    mov al, 'U'
    xor bh, bh
    mov bl, 0Ch
    mov cx, 1
    int 10h
    mov ah, 02h
    xor bh, bh
    mov dx, 030Bh
    int 10h
    mov ah, 09h
    mov al, '7'
    xor bh, bh
    mov bl, 0Ch
    mov cx, 1
    int 10h
cp_color:
    jmp esperar_salir

%include "include/comun.inc"
