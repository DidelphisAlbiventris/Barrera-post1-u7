; Johan Barrera - Cod. 1152538
; Arquitectura de computadores - Unidad 7
; Compilar desde la raiz: nasm -f bin post2e.asm -o post2e.com
bits 16
cpu 8086
org 100h
jmp inicio
estado db 0
etiquetas db 'SHIFT:0 CTRL:0',0
cabecera db 'POST2E - Modificadores en tiempo real / ESC termina',0
ayuda db 'Mantenga SHIFT o CTRL. Al soltarlos, los indicadores vuelven a 0.',0
ayuda2 db 'SHIFT agrupa izquierdo y derecho: mascara 03h. CTRL: mascara 04h.',0
inicio:
    push cs
    pop ds
    cld
    call iniciar_directo
    mov ax, 0720h
    call rellenar
    mov bl, 0Bh
    call firma_directa
    mov si, etiquetas
    xor di, di
    mov ah, 0Fh
    call cadena_directa
    mov si, cabecera
    mov di, (2*80+2)*2
    mov ah, 0Fh
    call cadena_directa
    mov si, ayuda
    mov di, (4*80+2)*2
    mov ah, 07h
    call cadena_directa
    mov si, ayuda2
    mov di, (5*80+2)*2
    mov ah, 07h
    call cadena_directa
sondear:
    mov ah, 02h
    int 16h
    mov [estado], al
    mov bl, al
    mov cl, '0'
    test bl, 03h
    jz shift_listo
    mov cl, '1'
shift_listo:
    mov byte [es:12], cl
    mov byte [es:13], 0Ah
    mov cl, '0'
    test bl, 04h
    jz ctrl_listo
    mov cl, '1'
ctrl_listo:
    mov byte [es:26], cl
    mov byte [es:27], 0Ch
cp_estado:
    mov ah, 01h
    int 16h
    jz sondear
    xor ah, ah
    int 16h
    cmp ah, 01h
    jne sondear
    jmp salir

%include "include/comun.inc"
