; Johan Barrera - Cod. 1152538
; Arquitectura de computadores - Unidad 7
; Compilar desde la raiz: nasm -f bin post2b.asm -o post2b.com
bits 16
cpu 8086
org 100h
jmp inicio
titulo db 'POST2B - Escritura directa en B800h',0
ayuda db 'H O L A: filas 10 a 13, columna 35. Pulse una tecla.',0
inicio:
    push cs
    pop ds
    cld
    call iniciar_directo
    mov ax, 0720h
    call rellenar
    mov bl, 0Bh
    call firma_directa
    mov si, titulo
    mov di, (2*80+2)*2
    mov ah, 0Fh
    call cadena_directa
    mov si, ayuda
    mov di, (18*80+2)*2
    mov ah, 07h
    call cadena_directa
    ; Celdas escritas mediante MOV, sin llamadas de video para dibujar.
    mov di, 1670
    mov byte [es:di], 'H'
    mov byte [es:di+1], 0Fh
    mov di, 1830
    mov byte [es:di], 'O'
    mov byte [es:di+1], 0Eh
    mov di, 1990
    mov byte [es:di], 'L'
    mov byte [es:di+1], 0Ah
    mov di, 2150
    mov byte [es:di], 'A'
    mov byte [es:di+1], 0Ch
cp_hola:
    jmp esperar_salir

%include "include/comun.inc"
