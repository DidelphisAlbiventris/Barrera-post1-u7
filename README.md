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



## Parte 2

### Decisión técnica 3 — BIOS frente a puerto 60h

El estudiante elige INT 16h porque permite trabajar con teclado desde una aplicación DOS sin apropiarse del controlador físico ni del manejo de sus interrupciones. 
AH=00h resulta adecuado cuando el programa debe esperar una nueva tecla, como el editor; el monitor de códigos emplea la variante ampliada AH=10h por la necesidad de 
F11/F12. No sirve como reemplazo de AH=02h dentro del monitor de modificadores: al bloquearse esperando una tecla registrada, dejaría de refrescar el estado y pulsar 
solamente Shift no garantiza que esa espera termine.

AH=01h permite consultar disponibilidad sin consumir el evento. Leer el puerto 60h elimina la llamada BIOS y puede ofrecer control más directo sobre los datos, pero no 
garantiza menor latencia en cualquier sistema. Una implementación correcta debe coordinar la disponibilidad indicada por el controlador, los prefijos, el conjunto de 
códigos, las transiciones make/break y, si usa IRQ1, el reconocimiento de interrupciones.

También debe evitar competir con el manejador BIOS que consume esos datos. Para este laboratorio se prefiere la interfaz BIOS. Un sistema operativo o controlador 
propio que gestione un teclado PS/2 sin esos servicios necesitaría controlar ese hardware; la afirmación no se generaliza sin cambios a teclados USB.

### Decisión técnica 4 — Estado BIOS frente a seguimiento manual

El estudiante utiliza AH=02h porque el BIOS ya mantiene el estado de los modificadores y permite consultarlo sin reconstruir todas las pulsaciones y liberaciones desde 
el inicio del programa. La consulta evita duplicar lógica de prefijos y de actualización de estados, y permite distinguir ambos Shift mediante los bits cero y uno. El 
seguimiento manual de códigos crudos exige recibir y procesar todos los eventos relevantes: si se pierde una liberación, puede quedar una variable indicando falsamente 
que la tecla continúa presionada.

Esto depende del manejo de interrupciones y de los búferes, no simplemente de que el programa esté ocupado un instante. Debe corregirse una premisa del enunciado: 
AH=00h y AH=01h no entregan normalmente el flujo crudo de make/break de Shift y Ctrl, por lo que no bastan para implementar esa alternativa. Haría falta otro nivel de 
captura, coordinado con el controlador y el manejador de teclado.

Para mostrar el estado actual, AH=02h sigue siendo la opción sencilla incluso al separar Shift izquierdo y derecho. La captura cruda tendría sentido si se necesitan 
eventos precisos de transición, una política de teclado propia o información que la interfaz BIOS no ofrece.

Para los indicadores del ejercicio se comprueban los bits 0 y 1 mediante la máscara 03h y Ctrl mediante 04h. Si se requieren indicadores separados, 01h identifica 
Shift derecho y 02h identifica Shift izquierdo. El BIOS actualiza su estado durante la atención de las interrupciones, aunque la aplicación no consulte continuamente.
