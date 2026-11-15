# Unidad 7 — Pantalla y teclado en NASM

**Estudiante:** Johan Barrera  
**Código:** 1152538  
**Asignatura:** Arquitectura de computadores  
**Universidad:** UFPS — Cúcuta  
**Repositorio:** `barrera-post1-u7`

## Parte 1

### Decisión técnica 1 — INT 21h frente a INT 10h

El estudiante utiliza INT 21h/AH=09h para los mensajes de texto plano, como las tres líneas de post1 y los rótulos del monitor de teclado. Esta función permite enviar 
una cadena completa terminada en dólar con una sola llamada, de modo que evita programar un recorrido manual y facilita mantener el contenido. No recibe un atributo de 
color ni permite seleccionar una celda mediante parámetros propios.

Para A amarilla sobre azul, el título verde y la celda Z con atributo conocido, el estudiante utiliza INT 10h: la combinación de AH=02h y AH=09h proporciona el control 
explícito que requiere la actividad. El costo es escribir más código, gestionar la página y actualizar el cursor por carácter. En esta parte del laboratorio, esa ruta 
depende de un modo de video compatible con los atributos de texto utilizados.

La ruta DOS abstrae la salida estándar y no obliga al programa a conocer el formato de la memoria de video; incluso puede redirigirse. Eso no significa que toda salida 
DOS tenga idéntica apariencia en cualquier dispositivo o modo. La elección responde al grado de control requerido, no a que un servicio sea universalmente superior.

En concreto, AH=02h de INT 10h recibe la fila en DH, la columna en DL y la página en BH. AH=09h recibe el carácter en AL, el atributo en BL y las repeticiones en CX; 
esta última función no avanza el cursor. Esa separación explica el trabajo adicional requerido por una cadena coloreada.

### Decisión técnica 2 — Consultar y releer frente a asumir

El estudiante consulta el modo de video antes de trabajar con una disposición específica de pantalla porque el programa anterior pudo dejar otro modo, otro ancho o una 
página distinta. Utilizar sin comprobación las coordenadas y atributos previstos para texto color puede producir resultados incorrectos o invisibles. AH=0Fh informa 
del modo, las columnas y la página activa, pero no certifica por sí sola todas las dimensiones: por eso esta implementación establece después el modo estándar 03h y 
verifica sus resultados.

Releer con AH=08h permite comprobar que la celda concreta conserva el carácter y el atributo esperados. En un editor, esta comprobación ayuda a descubrir una dirección 
o página equivocada, o una modificación inesperada, aunque una lectura aislada no elimina todas las posibles condiciones de carrera. La interfaz BIOS evita que el 
programa calcule la organización física del adaptador; no implica que todos los modos gráficos ofrezcan exactamente la misma semántica de carácter y atributo.

En contraste, B800h permite acceso directo eficiente al texto color, pero obliga a conocer el modo, la página, los límites y el formato de dos bytes por celda.

La relectura de una Z con atributo 2Fh debe devolver AL=5Ah y AH=2Fh en la celda seleccionada. AH=0Fh no informa del número de filas: el establecimiento explícito del 
modo 03h estándar evita deducir erróneamente una pantalla de 25 filas solo a partir del número de modo.
