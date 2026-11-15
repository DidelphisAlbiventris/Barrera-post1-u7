; Johan Barrera - Cod. 1152538
; Arquitectura de computadores - Unidad 7
; Compilar desde la raiz: nasm -f bin post1c.asm -o post1c.com
bits 16
cpu 8086
org 100h
jmp inicio
titulo db 'UNIDAD 7 - PANTALLA Y TECLADO',0
ayuda db 'POST1C - Fila 5, columna 25, atributo 0Ah. Pulse una tecla.',0
inicio:
    push cs
    pop ds
    cld
    call iniciar_bios
    mov si, ayuda
    mov dx, 1202h
    mov bl, 07h
    call cadena_bios
    mov si, titulo
    mov dx, 0519h             ; 19h=25 decimal
    mov bl, 0Ah
    call cadena_bios          ; bucle con AH=02h + AH=09h por caracter
cp_titulo:
    jmp esperar_salir

%include "include/comun.inc"
