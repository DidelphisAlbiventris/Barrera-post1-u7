; Johan Barrera - Cod. 1152538
; Arquitectura de computadores - Unidad 7
; Compilar desde la raiz: nasm -f bin post2a.asm -o post2a.com
bits 16
cpu 8086
org 100h
jmp inicio
ultimo_scan db 0
ultimo_ascii db 0
ultimo_raw db 0
prompt db 'Johan Barrera | Cod: 1152538',13,10
       db 'Arquitectura de computadores | Unidad 7',13,10
       db 'POST2A - Pulse letras, F1-F12 o flechas. ESC termina.',13,10,'$'
msg_scan db 'Scan: $'
msg_ascii db 'h  ASCII: $'
fin_linea db 'h',13,10,'$'
inicio:
    push cs
    pop ds
    cld
    mov dx, prompt
    mov ah, 09h
    int 21h
leer_tecla:
    ; Servicio ampliado: permite F11/F12 ademas de teclas clasicas.
    mov ah, 10h
    int 16h
    mov [ultimo_scan], ah
    mov [ultimo_raw], al
    ; E0h es marcador ampliado, no un caracter ASCII imprimible.
    cmp al, 0E0h
    jne guardar_ascii
    xor al, al
guardar_ascii:
    mov [ultimo_ascii], al
cp_tecla:
    mov ah, 09h
    mov dx, msg_scan
    int 21h
    mov al, [ultimo_scan]
    call hex_dos
    mov ah, 09h
    mov dx, msg_ascii
    int 21h
    mov al, [ultimo_ascii]
    call hex_dos
    mov ah, 09h
    mov dx, fin_linea
    int 21h
    cmp byte [ultimo_scan], 01h
    jne leer_tecla
    jmp salir

%include "include/comun.inc"
