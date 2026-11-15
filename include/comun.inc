; Rutinas compartidas. Todas las cadenas de estas rutinas terminan en cero.
; Johan Barrera - 1152538 - Arquitectura de computadores.

; Preparacion BIOS: modo 03h, pagina 0, 80x25 y limpieza con scroll.
iniciar_bios:
    mov ax, 0003h
    int 10h
    mov ax, 0600h
    mov bh, 07h
    xor cx, cx
    mov dx, 184Fh
    int 10h
    mov si, identidad
    mov dx, 1402h             ; fila 20, columna 2
    mov bl, 0Bh
    call cadena_bios
    mov si, asignatura
    mov dx, 1502h
    mov bl, 07h
    call cadena_bios
    ret

; DS:SI cadena, DH fila, DL columna, BL atributo. Pagina cero.
; AH=09h no avanza el cursor: se actualiza DL explicitamente.
cadena_bios:
    push ax
    push bx
    push cx
    push dx
    push si
    cld
.siguiente:
    lodsb
    test al, al
    jz .fin
    push ax                  ; AH=02h no debe destruir el caracter pendiente
    mov ah, 02h
    xor bh, bh
    int 10h
    pop ax
    mov ah, 09h
    xor bh, bh
    mov cx, 1
    int 10h
    inc dl
    jmp .siguiente
.fin:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Solo la PREPARACION usa BIOS. El dibujo posterior usa exclusivamente B800h.
iniciar_directo:
    mov ax, 0003h            ; establecer formato conocido antes de B800h
    int 10h
    mov ah, 02h
    xor bh, bh
    mov dx, 1700h           ; cursor de hardware fuera de la zona de trabajo
    int 10h
    mov ax, 0B800h
    mov es, ax
    cld
    ret

; AX=atributo:espacio. 2000 palabras = 4000 bytes, sin salir de pagina 0.
rellenar:
    xor di, di
    mov cx, 2000
    cld
    rep stosw
    ret

; DS:SI texto, ES:DI destino, AH atributo; no toca el cursor del BIOS.
cadena_directa:
    cld
.otro:
    lodsb
    test al, al
    jz .fin
    stosw
    jmp .otro
.fin:
    ret

; BL=atributo del pie; ES apunta a B800h.
firma_directa:
    mov ah, bl
    mov di, (20*80+2)*2
    mov si, identidad
    call cadena_directa
    mov ah, bl
    mov di, (21*80+2)*2
    mov si, asignatura
    call cadena_directa
    ret

; Imprime AL en dos digitos hexadecimales mediante DOS; preserva registros.
hex_dos:
    push ax
    push bx
    push cx
    push dx
    mov bl, al
    mov cl, 4
    shr al, cl
    call nibble_ascii
    mov dl, al
    mov ah, 02h
    int 21h
    mov al, bl
    and al, 0Fh
    call nibble_ascii
    mov dl, al
    mov ah, 02h
    int 21h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
nibble_ascii:
    and al, 0Fh
    cmp al, 9
    jbe .decimal
    add al, 'A'-10
    ret
.decimal:
    add al, '0'
    ret

esperar_salir:
    mov ah, 07h
    int 21h
salir:
    mov ax, 4C00h
    int 21h

identidad db 'Johan Barrera | Cod: 1152538',0
asignatura db 'Arquitectura de computadores | Unidad 7',0
