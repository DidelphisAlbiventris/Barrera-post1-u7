; Johan Barrera - Cod. 1152538
; Arquitectura de computadores - Unidad 7
; Compilar desde la raiz: nasm -f bin post2c.asm -o post2c.com
bits 16
cpu 8086
org 100h
jmp inicio
titulo db 'HOLA DESDE B800h',0
ayuda db 'POST2C - 2000 celdas, REP STOSW. Pulse una tecla.',0
inicio:
    push cs
    pop ds
    cld
    call iniciar_directo
    mov ax, 1720h
    xor di, di
    mov cx, 2000
    cld
    rep stosw
cp_relleno:
    ; 1Fh conserva fondo azul y usa blanco brillante.
    mov di, (12*80+30)*2
    mov si, titulo
    mov ah, 1Fh
    call cadena_directa
    mov bl, 1Bh
    call firma_directa
    mov si, ayuda
    mov di, (18*80+2)*2
    mov ah, 1Fh
    call cadena_directa
cp_mensaje:
    jmp esperar_salir

%include "include/comun.inc"
