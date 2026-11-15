; Johan Barrera - Cod. 1152538
; Arquitectura de computadores - Unidad 7
; Compilar desde la raiz: nasm -f bin post2d.asm -o post2d.com
bits 16
cpu 8086
org 100h
jmp inicio
columna dw 0
caracter db 0
cabecera db 'POST2D - MINI EDITOR / UNA LINEA',0
ayuda db 'Escriba en fila 12. Retroceso borra. ENTER o ESC termina.',0
limite db '80 columnas: al llegar al borde vuelve al inicio.',0
inicio:
    push cs
    pop ds
    cld
    call iniciar_directo
    mov ax, 0720h
    call rellenar
    mov bl, 0Bh
    call firma_directa
    mov si, cabecera
    mov di, (2*80+2)*2
    mov ah, 0Fh
    call cadena_directa
    mov si, ayuda
    mov di, (4*80+2)*2
    mov ah, 07h
    call cadena_directa
    mov si, limite
    mov di, (5*80+2)*2
    mov ah, 07h
    call cadena_directa
    call marcar_cursor
leer_editor:
    xor ah, ah
    int 16h
    cmp ah, 01h
    je terminar_editor
    cmp al, 0Dh
    je terminar_editor
    cmp al, 08h
    je retroceso
    ; Ignorar teclas especiales y controles; aceptar ASCII imprimible.
    cmp al, 20h
    jb leer_editor
    cmp al, 7Eh
    ja leer_editor
    mov [caracter], al        ; conservar la PRIMERA y UNICA lectura
    call direccion_columna
    mov al, [caracter]
    mov ah, 0Fh
    mov [es:di], ax
    inc word [columna]
    cmp word [columna], 80
    jb avanzar_editor
    mov word [columna], 0
avanzar_editor:
    call marcar_cursor
cp_editor:
    jmp leer_editor
retroceso:
    cmp word [columna], 0
    je leer_editor
    call direccion_columna
    mov byte [es:di+1], 0Fh
    dec word [columna]
    call direccion_columna
    mov word [es:di], 0F20h
    call marcar_cursor
    jmp leer_editor
terminar_editor:
    call direccion_columna
    mov byte [es:di+1], 0Fh
    jmp salir
; DI=(12*80+columna)*2. No altera AL, no usa IMUL ni MOVZX.
direccion_columna:
    mov di, [columna]
    shl di, 1
    add di, 1920
    ret
marcar_cursor:
    call direccion_columna
    mov byte [es:di+1], 70h   ; cursor software: celda con atributo inverso
    ret

%include "include/comun.inc"
