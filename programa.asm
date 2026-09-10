section .data               ; Sección de datos inicializados (constantes, textos fijos)
    msg_inicio db "Calculando 3 + 4...", 0Ah ; 'db' define bytes (define byte). 0Ah es el salto de línea (\n) en hexadecimal.
    len_inicio equ $ - msg_inicio           ; 'equ' crea una constante estática. '$' representa la posición actual de memoria; al restarle el inicio, calcula la longitud exacta de forma automática.
    
    msg_res   db "El resultado es: "        ; Texto estético descriptivo
    len_res   equ $ - msg_res               ; Longitud automática del texto anterior

section .bss                ; Sección para datos no inicializados (espacios de memoria que se llenarán en tiempo de ejecución)
    resultado resb 2        ; 'resb' reserva bytes (reserve byte). Aquí reservamos 2 bytes seguidos: uno para el número y otro para el salto de línea.

section .text               ; Sección de código ejecutable (instrucciones que el CPU procesará)
    global _start           ; 'global' hace visible la etiqueta '_start' al enlazador (ld) para que sepa dónde arranca el programa.

_start:                     ; Etiqueta (label) que marca el punto de entrada lógico del código.
    
    ; --- Bloque 1: Imprimir mensaje inicial ---
    mov rax, 1              ; 'mov' copia el valor 1 a 'rax'. En Linux x86-64, rax=1 le indica al kernel que usaremos el syscall 'sys_write' (escribir).
    mov rdi, 1              ; 'rdi' especifica el destino o descriptor de archivo. 1 = salida estándar (stdout / la pantalla).
    mov rsi, msg_inicio     ; 'rsi' almacena el puntero (la dirección de memoria exacta) donde empieza el texto a mostrar.
    mov rdx, len_inicio     ; 'rdx' define cuántos bytes en total se van a leer y escribir.
    syscall                 ; Interrupción de software que salta al kernel de Linux para que ejecute la orden configurada.

    ; --- Bloque 2: Operación matemática ---
    mov rcx, 3              ; Cargamos el número literal 3 en el registro de propósito general 'rcx'.
    add rcx, 4              ; Instrucción 'add': suma 4 al contenido actual de 'rcx' (rcx ahora vale 7 en binario/decimal).

    ; --- Bloque 3: Conversión de número crudo a formato ASCII ---
    add rcx, 30h            ; ¡Truco clave! Los CPUs manejan números puros, pero la pantalla muestra caracteres ASCII. Sumar 30h (48 decimal) transforma el número 7 en el carácter gráfico '7' (cuyo código ASCII es 37h).
    mov [resultado], cl     ; '[ ]' indica desreferencia de memoria (escribir en la dirección de la variable). 'cl' es la parte baja (8 bits) del registro rcx. Guardamos el '7' ASCII ahí.
    mov byte [resultado + 1], 0Ah ; 'byte' especifica el tamaño de la operación. Guardamos un salto de línea en la segunda posición (resultado + 1) reservada en la sección .bss.

    ; --- Bloque 4: Imprimir texto descriptivo ---
    mov rax, 1              ; sys_write de nuevo
    mov rdi, 1              ; stdout (pantalla)
    mov rsi, msg_res        ; Puntero al texto "El resultado es: "
    mov rdx, len_res        ; Su longitud calculada con 'equ'
    syscall

    ; --- Bloque 5: Imprimir el resultado de la suma ---
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, resultado      ; Apuntamos a nuestra variable en .bss que ya contiene el dígito convertido y su salto de línea.
    mov rdx, 2              ; Indicamos que imprima exactamente 2 bytes (el carácter '7' + el salto de línea).
    syscall

    ; --- Bloque 6: Salida limpia del programa ---
    mov rax, 60             ; sys_exit: el número 60 en el registro rax le ordena al sistema operativo terminar este proceso.
    mov rdi, 0              ; Código de salida 0 (indica al sistema operativo que el programa finalizó correctamente sin errores).
    syscall                 ; Última llamada al sistema que mata el proceso limpiamente.