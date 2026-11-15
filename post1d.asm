; Johan Barrera - Cod. 1152538
; Arquitectura de computadores - Unidad 7
; Compilar desde la raiz: nasm -f bin post1d.asm -o post1d.com
bits 16
cpu 8086
org 100h
jmp inicio
modo_entrada db 0
columnas_entrada db 0
pagina_entrada db 0
modo_trabajo db 0
columnas_trabajo db 0
pagina_trabajo db 0
celda_leida dw 0
msg_entrada db 'Modo inicial: $'
msg_col db 'h  Columnas: $'
msg_pag db 'h  Pagina: $'
msg_fin db 'h',13,10,'$'
msg_normal db 'Modo de trabajo: 03h, 80x25, pagina 0.',13,10,'$'
msg_ok db 'Verificacion OK: caracter Z y atributo 2Fh coinciden.',0
msg_bad db 'ERROR: la celda releida no coincide.',0
msg_pause db 'POST1D - Z en fila 8, columna 10. Pulse una tecla para salir.',0
inicio:
    push cs
    pop ds
    cld
    ; Guardar los tres resultados ANTES de usar DX para imprimir mensajes.
    mov ah, 0Fh
    int 10h
    and al, 7Fh
    mov [modo_entrada], al
    mov [columnas_entrada], ah
    mov [pagina_entrada], bh
    ; Se establece modo 03h: garantiza 25 filas, no inferibles solo de AH=0Fh.
    call iniciar_bios
    mov ah, 0Fh
    int 10h
    and al, 7Fh
    mov [modo_trabajo], al
    mov [columnas_trabajo], ah
    mov [pagina_trabajo], bh
    mov ah, 02h
    xor bh, bh
    xor dx, dx
    int 10h
    mov ah, 09h
    mov dx, msg_entrada
    int 21h
    mov al, [modo_entrada]
    call hex_dos
    mov ah, 09h
    mov dx, msg_col
    int 21h
    mov al, [columnas_entrada]
    call hex_dos
    mov ah, 09h
    mov dx, msg_pag
    int 21h
    mov al, [pagina_entrada]
    call hex_dos
    mov ah, 09h
    mov dx, msg_fin
    int 21h
    cmp byte [modo_trabajo], 3
    jne error_video
    cmp byte [columnas_trabajo], 80
    jne error_video
    cmp byte [pagina_trabajo], 0
    jne error_video
    mov ah, 09h
    mov dx, msg_normal
    int 21h
    mov ah, 02h
    xor bh, bh
    mov dx, 080Ah
    int 10h
    mov ah, 09h
    mov al, 'Z'
    xor bh, bh
    mov bl, 2Fh
    mov cx, 1
    int 10h
    mov ah, 02h
    xor bh, bh
    mov dx, 080Ah
    int 10h
    mov ah, 08h
    xor bh, bh
    int 10h
    mov [celda_leida], ax
cp_relectura:
    cmp ax, 2F5Ah             ; AH=2Fh, AL=5Ah ('Z')
    jne error_video
    mov si, msg_ok
    mov bl, 0Ah
    jmp informar
error_video:
    mov si, msg_bad
    mov bl, 0Ch
informar:
    mov dx, 0B02h
    call cadena_bios
    mov si, msg_pause
    mov dx, 1202h
    mov bl, 07h
    call cadena_bios
    jmp esperar_salir

%include "include/comun.inc"
