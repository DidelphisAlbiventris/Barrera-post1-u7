; Johan Barrera - Cod. 1152538
; Arquitectura de computadores - Unidad 7
; Compilar desde la raiz: nasm -f bin post1.asm -o post1.com
bits 16
cpu 8086
org 100h
jmp inicio
msg1 db 'Arquitectura de Computadores',13,10,'$'
msg2 db 'Unidad 7: Pantalla y Teclado',13,10,'$'
msg3 db 'Laboratorio POST-1',13,10,'$'
firma db 13,10,'Johan Barrera | Cod: 1152538',13,10
      db 'Asignatura: Arquitectura de computadores',13,10
      db 'Pulse una tecla para volver a DOS.',13,10,'$'
inicio:
    push cs
    pop ds
    cld
    mov ah, 09h
    mov dx, msg1
    int 21h
    mov ah, 09h
    mov dx, msg2
    int 21h
    mov ah, 09h
    mov dx, msg3
    int 21h
    mov ah, 09h
    mov dx, firma
    int 21h
cp_texto:
    jmp esperar_salir

%include "include/comun.inc"
