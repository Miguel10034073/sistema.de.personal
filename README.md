# Expediente laboral

Aplicación de una sola página para llevar el expediente del personal: hoja de vida, vacaciones, dotación, primas, cesantías e intereses, afiliaciones, documentos pendientes y soportes de cada trabajador.

Es **un solo archivo HTML**. Funciona sin internet y sin instalar nada: se abre con doble clic en Microsoft Edge o Google Chrome. Sirve para varias compañías, cada una con sus propias copias de seguridad.

## Organización

```
007. Sistema de personal\
    Expediente laboral\          ← este repositorio: la página y lo que necesita para usarse
        index.html
        README.md
        .gitignore
        Crear copia desde carpetas.ps1 / .bat
    Copias de seguridad\         ← los datos: una subcarpeta por compañía. NO va al repositorio
        Mindala\
        Sindi Por Do Sol SAS\
    Diseños\                     ← versiones de diseño 01, 02 y 03, solo de referencia
```

La página y los datos están en carpetas separadas: el repositorio no tiene ningún dato personal, y las copias se quedan en el equipo y en OneDrive.

## Cómo se usa

La página tiene arriba una barra azul con el buscador de trabajadores (también se abre con **Ctrl+K**, o **⌘K** en Mac), los botones Deshacer y Rehacer y el estado de la copia. Debajo está el menú con cada sección y, al lado de cada una, cuántos pendientes tiene (en rojo, en Panel, las alertas prioritarias).

Todo vive en la carpeta `Copias de seguridad`, que tiene **una subcarpeta por compañía** (`Mindala`, `Sindi Por Do Sol SAS`…). En cada subcarpeta están:

- las copias `.json` de esa compañía, con las hojas de vida, los ajustes y el índice de documentos (pocos MB cada una), y
- la carpeta **`Documentos`**, con cada documento como un archivo suelto. El archivo se llama con el código del documento (por ejemplo `c20261016104509-12.pdf`); el nombre que se ve en la página (por ejemplo «Prima de 2025 - primer semestre.pdf») y su carpeta están en el `.json`.

1. Abra `Expediente laboral\index.html` en Edge o Chrome.
2. La primera vez pulse **Elegir carpeta** y elija `007. Sistema de personal\Copias de seguridad` (la carpeta de arriba, no la de una compañía). El navegador pide permiso: elija **Permitir** y, si aparece, **Permitir en cada visita**.
3. La página abre la última compañía usada con su copia `.json` más reciente. Abre en segundos: lee solo el `.json`, y cada documento se lee de `Documentos` cuando se abre.
4. Trabaje normalmente. **No hay que exportar nada**:
   - Cada cambio queda guardado al instante en el navegador, también los documentos que adjunte.
   - Dos minutos después del último cambio, o al salir de la pestaña, la página escribe sola la copia de esa hora `Expediente <Compañía> AAAA-MM-DD HHh.json` en la subcarpeta de la compañía: hay **una copia por cada día y hora** en que hubo cambios, y los cambios de la misma hora actualizan esa copia. Solo pasa a `Documentos` los documentos **nuevos**, y borra de ahí los que ya no usa nadie (ver «Copias de seguridad» más abajo). Tarda unos segundos. La barra azul de arriba muestra el avance y luego «Copia al día» con la hora. Si tiene prisa, use **Guardar copia**.
5. Para terminar, cierre la pestaña. Si la copia no está al día, la página se encarga de hacerla antes (tarda unos segundos):
   - **Al actualizar con F5 o Ctrl+R (⌘R en Mac):** primero escribe la copia, con una barra de avance, y luego se actualiza sola.
   - **Al cerrar la pestaña o usar el botón de actualizar del navegador:** el navegador pregunta si desea salir. Elija **Cancelar** (quedarse): la página escribe la copia enseguida y avisa «✓ Copia al día. Puede cerrar la pestaña». Los navegadores no dejan que una página demore su cierre, por eso hace falta quedarse esos segundos.
   - Si de todos modos sale, los cambios no se pierden: siguen en el navegador y la copia se escribe la próxima vez que abra la página.
   - Si la copia no se puede escribir (por ejemplo, porque el navegador perdió el permiso sobre la carpeta), la página lo dice y ofrece **Reintentar**.

Las siguientes veces la página abre directamente (o con el botón **Abrir el expediente** si el navegador vuelve a pedir permiso) y sigue donde quedó, sin volver a cargar la copia.

```
007. Sistema de personal\Copias de seguridad\
    Inversiones Mindala SAS\
        Expediente Inversiones Mindala SAS 2026-10-21 15h.json   ← copia de las 3 p. m. (pocos MB): la actualizan los cambios de esa hora
        Expediente Inversiones Mindala SAS 2026-10-21 09h.json   ← una copia por cada día y hora en que hubo cambios
        Expediente Inversiones Mindala SAS 2026-10-20 11h.json   ← se conservan todas las de los 7 días más recientes con copias
        Expediente Mindala 2026-10-16 inicial.json               ← las copias con otro nombre no se borran solas
        Documentos\                                              ← todos los adjuntos de la compañía, cada uno una sola vez
            c0.csv
            c20261016104509-12.pdf
            …
    Sindi Por Do Sol SAS\
        Expediente Sindi Por Do Sol SAS 2026-10-20 09h.json
        Documentos\
    Dora Helena Mejia Alzate\
        Expediente Dora Helena Mejia Alzate 2026-10-20 10h.json
        Documentos\
```

### Copias de seguridad

- **Solo se copia lo nuevo.** Un documento nunca cambia: al reemplazarlo, la versión nueva es otro archivo con otro código. Por eso, en cada copia la página compara la lista del `.json` con lo que ya hay en `Documentos` y solo escribe lo que falta. El `.json` se escribe al final, cuando ya están todos sus documentos: si la copia se corta, no se daña nada.
- **Se borra lo que ya nadie usa.** Después de cada copia se borran de `Documentos` los archivos que no usa ninguna copia `.json` de la carpeta (las de cada día y hora y las que tienen otro nombre), ni la papelera, ni el historial de Deshacer. Así un documento eliminado se puede seguir recuperando con Deshacer, con la Papelera o con **Abrir otra copia** de un día u hora anterior. Si alguna copia `.json` de la carpeta no se puede leer, no se borra nada.
- **No cambie ni borre a mano los archivos de `Documentos`**: la página los encuentra por su nombre. Para cambiar un documento use los botones de la página (Renombrar, Reemplazar, Mover, Eliminar).
- **Copias antiguas** (las de antes de este cambio, con todos los documentos dentro del `.json`, de unos 950 MB): se siguen abriendo. La primera vez que la página abre una compañía en el formato antiguo, pasa sus documentos a `Documentos` (tarda cerca de un minuto) y escribe la copia de esa hora en el formato nuevo. Las copias diarias antiguas (`… AAAA-MM-DD.json`) se borran solas cuando su día sale de los 7 más recientes; las de otro nombre (por ejemplo la «inicial») se pueden borrar a mano cuando ya no se necesiten.
- **Cuántas se conservan:** todas las copias por hora de los 7 días más recientes que tienen copias. Las de días más viejos se borran solas; las de otro nombre no se borran nunca.
- Para llevar la copia a otro equipo, copie la subcarpeta completa de la compañía (el `.json` solo no basta).
- **Ajustes › Copias de seguridad**: **Guardar copia ahora**, **Abrir otra copia** (para volver a una copia anterior de la misma compañía; si después hace cambios, se guardan en la copia de la hora en que los haga), **Cambiar de compañía** y **Cambiar carpeta de copias**. Ahí también se ve cuántos archivos hay en `Documentos`.

### Compañías

- La compañía abierta aparece arriba a la izquierda, en la barra azul. Al hacer clic en su nombre (**Cambiar de compañía**) se abre la lista de compañías, con cuántas copias tiene cada una y la fecha de la más reciente. Pulse **Abrir** en la que quiere usar.
- Si la compañía abierta tiene cambios sin copiar, primero se escribe su copia (tarda unos segundos) y luego se abre la otra. Si la copia no se puede escribir, no cambia de compañía, para no dejar cambios por fuera.
- Cada compañía tiene sus propios datos: trabajadores, ajustes (razón social, NIT, logo, quien firma), papelera e historial de Deshacer. Nada se mezcla entre compañías.
- **Nueva compañía**: en la misma ventana, escriba el nombre y pulse **Crear**. Se crea su subcarpeta en `Copias de seguridad` y empieza con un expediente vacío, con las áreas `001. Personal`, `002. Aprendiz SENA` y `003. Trabajadores por servicio`. Complete su razón social y demás datos en **Ajustes**.
- Una compañía sin copias (por ejemplo, recién creada desde el explorador de archivos) muestra **Empezar el expediente de…**.
- La próxima vez que abra la página, se abre la última compañía usada.
- Cada compañía ocupa en OneDrive lo que pesan sus documentos (en Mindala, cerca de 720 MB) más unos pocos MB por cada copia `.json`. Cada copia sube a la nube solo el `.json` del día y los documentos nuevos.

### Número de contrato

- Cada contrato tiene un número: es la **cédula** del trabajador. Si la misma persona tiene varios contratos (la misma cédula en varios expedientes, por ejemplo uno en Retirados y otro en Activos), se numeran por fecha de ingreso: `cédula-1` para el primero, `cédula-2` para el siguiente, y así.
- Aparece en el encabezado de la ficha («Contrato No.»), en las listas cuando no es solo la cédula, en la búsqueda y en los documentos impresos (constancia, liquidación, comunicación de vacaciones, acta de dotación y hoja de vida).
- Si un contrato necesita otro número, escríbalo en **Hoja de vida › Número de contrato**; vacío, se calcula solo.

### Sustitución patronal

- Cuando un trabajador viene de otra empresa (arts. 67 a 70 CST), en **Hoja de vida › Sustitución patronal** marque **Sí** y escriba la empresa anterior, su NIT y la fecha de ingreso a esa empresa.
- En **Las prestaciones se cuentan desde** elija:
  - **El ingreso a la empresa anterior (continúa el contrato)**: cesantías, intereses, primas, dotación, vacaciones, antigüedad, indemnización y liquidación se calculan desde esa fecha.
  - **El ingreso a esta empresa**: se calculan desde la fecha de ingreso de la hoja de vida, como cualquier otro trabajador.
- La fecha de ingreso de la hoja de vida sigue siendo la de esta empresa. La ficha muestra «Sustitución patronal de…» y, con continuidad, desde cuándo se cuentan las prestaciones; las pestañas de vacaciones, dotación, primas y cesantías lo recuerdan en una nota.
- Con continuidad, la constancia laboral menciona la sustitución patronal y la liquidación trae la empresa anterior y su fecha de ingreso.

### Préstamos y descuentos

- En la ficha de cada trabajador, la pestaña **Préstamos** lleva sus préstamos y descuentos (libranzas, anticipos, embargos, fondo de empleados…). Con **+ Nuevo préstamo o descuento** se indica:
  - **Valor total** (vacío si es un descuento sin tope, que se repite hasta que se quite).
  - **Frecuencia**: **quincenal** (se descuenta los días 15 y el último del mes) o **mensual** (el último día del mes).
  - **Cuotas fijas** (el mismo valor cada vez: la página arma el calendario y muestra cuántas cuotas son y cuándo termina) o **variables** (el valor cambia cada vez).
  - Primer descuento, soporte en el expediente (por ejemplo la autorización firmada) y una nota.
- Cada vez que se descuente en la nómina, use **Registrar descuento**: propone la fecha y el valor de la cuota que sigue. La página lleva lo descontado, el saldo y el próximo descuento, y en **Descuentos** se ven los registrados y el calendario de cuotas.
- Si una cuota fija ya venció y no se registró, el préstamo queda **Atrasado** y aparece en los pendientes. A un retirado con saldo se le muestra **Saldo al retiro**.
- En el menú, **Préstamos** muestra los préstamos y descuentos vigentes de todos los trabajadores y cuánto hay que descontar en la próxima nómina (cuotas fijas de los activos, incluidas las atrasadas). Se puede descargar para Excel.
- La **liquidación del contrato** descuenta sola el saldo de los préstamos (se puede elegir «No descontarlo»). Después de pagarla, registre ese descuento en la pestaña Préstamos.
- **Imprimir estado** (en la pestaña Préstamos, o en **Imprimir documentos**) saca el estado de préstamos del trabajador; **Imprimir estados**, en el control de Préstamos, saca una hoja por cada trabajador de la lista. Ver «Documentos para imprimir».

### Llamados de atención y descargos

- En la ficha de cada trabajador con contrato laboral, la pestaña **Llamados y descargos** lleva el seguimiento de cada problema disciplinario:
  - **+ Llamado de atención**: fecha, fecha de los hechos, hechos y falta o norma incumplida. Se imprime, se hace firmar y se adjunta firmado. Queda «Falta soporte firmado» hasta que se adjunte.
  - **+ Proceso de descargos**: además de lo anterior, la **citación** (fecha, hora y lugar de la diligencia), **cómo fue la diligencia** (rindió descargos o no asistió), los acompañantes, el **resumen de los descargos** y la **decisión** (archivo sin sanción, llamado de atención escrito, suspensión, terminación con justa causa u otra) con su fecha y motivo.
- Cada seguimiento muestra sus pasos (citación → descargos → decisión) y su estado: por citar, citado, registrar la diligencia, por decidir o cerrado.
- **Anexos**: con **Adjuntar anexo** (en la tabla o dentro de la ventana del seguimiento) se suben la citación, el acta de descargos, las pruebas, la decisión u otros documentos. El primer anexo crea la subcarpeta del seguimiento dentro de `07. Llamados de atención` y los siguientes quedan en la misma. La página propone el documento que falta y su fecha.
- **Imprimir** (en cada seguimiento): llamado de atención por escrito; citación a descargos (con los hechos, la fecha, la hora, el lugar y los derechos del trabajador); acta de diligencia de descargos (con el resumen registrado o con renglones para escribir a mano); y comunicación de la decisión. Cada uno tiene «Adjuntar firmado». **Imprimir historial** saca todos los llamados y procesos del trabajador.
- Una **suspensión** se registra sola en «Licencias no remuneradas y suspensiones» de Vacaciones, así que esos días no cuentan para las vacaciones. La ventana recuerda el límite (8 días por la primera falta, 2 meses si reincide) y avisa si han pasado más de 30 días desde los hechos.
- **Soportes sin seguimiento registrado**: los archivos que ya estaban en `07. Llamados de atención` aparecen aparte, con **Registrar seguimiento** para crear el seguimiento con esos archivos como anexos.
- **Alertas**: proceso sin citar (prioritaria si pasaron más de 15 días desde los hechos), diligencia sin registrar, proceso sin decisión (prioritaria a los 15 días de los descargos) y llamado de atención sin soporte firmado.
- En el menú, **Llamados** muestra los seguimientos de todos los trabajadores (primero los procesos abiertos) y se puede descargar para Excel.

### Documentos

- Al hacer clic en el nombre de un documento, se abre en una ventana emergente dentro de la página, con botones para abrirlo en otra pestaña, descargarlo, cambiarle el nombre, reemplazarlo, moverlo o eliminarlo. Los mismos botones aparecen en cada documento de las listas.
- **Renombrar** cambia el nombre del documento; sigue en la misma carpeta y conserva su extensión (`.pdf`, `.jpg`…). Si ya hay otro documento con ese nombre en la carpeta, avisa y no cambia nada. Ojo: el sistema reconoce los soportes por su nombre, así que si cambia el tipo, el año o el mes (por ejemplo «Prima de 2025» a «Prima de 2026»), el documento pasa a otra casilla de los controles. Para cambiarlo de tipo o de carpeta es mejor **Mover**. Se puede deshacer.
- **Reemplazar** cambia el archivo por otro (por ejemplo, el escaneo firmado) y conserva el nombre y la carpeta. Si el archivo nuevo es de otro tipo, por ejemplo una foto `.jpg` en lugar de un `.pdf`, solo cambia la extensión. La versión anterior queda en la **Papelera**.
- **Mover** pasa un soporte que quedó mal clasificado a donde corresponde: a otro tipo (por ejemplo de Vacaciones a Dotación) o a otro periodo (por ejemplo de Vacaciones de 2022 a 2025). Se elige el tipo y el periodo como al adjuntar, y el nombre y la carpeta se ponen solos. Si ya hay un documento con ese nombre, el movido queda como «(2)».
- **Eliminar** quita el documento del expediente y lo deja en la **Papelera**.

#### Papelera

- Guarda durante **30 días** los documentos eliminados y la versión anterior de los documentos reemplazados. Está en **Ajustes › Papelera** (la de todos) y al final de la pestaña **Soportes** de cada trabajador (solo la de ese trabajador, cuando tiene algo).
- **Ver** abre el documento; **Restaurar** lo vuelve a poner en su carpeta original. Si ya hay otro documento con ese nombre (por ejemplo el que lo reemplazó), el restaurado queda como «(2)».
- A diferencia de **Deshacer**, restaurar **no deshace los cambios que se hicieron después**: sirve para recuperar algo que se eliminó hace varios pasos o días.
- **Vaciar** quita todo lo de la papelera (en la ficha del trabajador, solo lo de ese trabajador).
- Restaurar y vaciar también se pueden deshacer con **Deshacer**.
- Los documentos de la papelera se quedan en `Documentos` y están en el índice de la copia `.json`, así que no se pierden al abrir la copia en otro momento o en otro equipo. Pasados 30 días se quitan solos al abrir la página (para que la copia no crezca sin límite); después de eso solo quedan en las copias de los días anteriores que se conserven.

### Deshacer y rehacer

- En la barra azul de arriba, **Deshacer** (flecha hacia atrás) devuelve el expediente a como estaba antes del último cambio, y **Rehacer** (flecha hacia adelante) vuelve a aplicarlo. Al pasar el mouse por encima, el botón dice qué cambio va a deshacer (por ejemplo «Eliminar «Contrato de trabajo firmado.pdf»»).
- También funcionan con el teclado: **Ctrl+Z** y **Ctrl+Y** (en Mac, **⌘Z** y **⌘⇧Z** o **⌘Y**). Dentro de un campo de texto, esas teclas deshacen lo escrito en el campo, como siempre.
- Sirve para todo: documentos eliminados, reemplazados, movidos o adjuntados; datos de la hoja de vida; vacaciones, novedades y pendientes; casillas de control; retiros y reactivaciones; liquidaciones y ajustes.
- Después de eliminar, reemplazar o mover un documento, o de registrar un retiro, aparece un aviso con el enlace **Deshacer** para arreglarlo enseguida.
- Va paso a paso: para llegar a un cambio de hace varios pasos se deshacen también los posteriores. Si después de deshacer se hace un cambio nuevo, ya no se puede rehacer lo deshecho. Para recuperar un documento eliminado o reemplazado sin deshacer lo posterior, use la **Papelera**.
- Se guardan los últimos 40 cambios de la copia abierta, también si se cierra la pestaña. Al abrir otra copia (**Abrir otra copia**) el historial empieza de nuevo; para cambios más antiguos están las copias de los días anteriores.

## Documentos para imprimir

En la ficha de cada trabajador, el botón **Imprimir documentos** genera, listos para firmar o guardar como PDF:

Todos tienen el mismo formato: tamaño carta; encabezado con el logo, la razón social, el NIT, la dirección y el teléfono de la empresa y la fecha de expedición; título destacado; tablas con los datos del trabajador; firmas alineadas; y pie con la empresa, la fecha y hora en que se generó y el número de página («Página 1 de 2»). Si la ventana de impresión muestra además la fecha y la dirección del navegador arriba y abajo, desmarque **Encabezados y pies de página** en «Más opciones».

- **Hoja de vida**: datos principales con la foto, datos personales, contacto, información laboral (con la sustitución patronal, si hay), seguridad social, dotación y vacaciones, y firmas del trabajador y del empleador.
- **Constancia laboral**, o de prestación de servicios en el caso de los contratistas. Incluye el salario o los honorarios si se marca la opción.
- **Estado de vacaciones**: consolidado con corte a hoy. Trae el resumen (días causados, disfrutados, compensados, disponibles con su valor estimado, y periodos vencidos), el detalle de cada periodo (vigencia, días laborados, causados, disfrutados, compensados, saldo y estado, con totales), las vacaciones tomadas y compensadas con sus fechas de salida, último día y regreso, las licencias no remuneradas y suspensiones, y una nota con las reglas de cálculo (arts. 186, 189 y 190 CST). También se imprime con **Imprimir estado**, en la pestaña Vacaciones del trabajador.
- **Comunicación de vacaciones** a partir de un registro de vacaciones, o **acuerdo de compensación en dinero** (art. 189 CST). También se imprime desde el enlace "imprimir" del historial de vacaciones. Si las vacaciones no tienen fechas registradas (o el periodo solo tiene el soporte en la carpeta), la comunicación sale con espacios en blanco para escribir a mano el primer día, el último y el regreso.

**Registro de vacaciones compensadas en dinero:** se piden los **días compensados**, el **valor pagado** y la **fecha de pago**. La ventana muestra los días disponibles del periodo antes de la compensación y cuántos le quedan después; como referencia, propone el valor con el salario actual. No deja compensar más días de los disponibles, y avisa si pasan de la mitad del periodo (art. 189 CST). En el historial, en el estado de vacaciones y en el acuerdo de compensación aparecen los días, el valor pagado y la fecha de pago. (Si algún registro compensado quedó guardado sin días, compensa lo que le quede pendiente al periodo; al editarlo se le pueden poner los días.)
- **Acta de entrega de dotación**, con las tallas de la hoja de vida y un espacio para la huella. En *Controles › Dotación*, el botón **Imprimir actas de entrega** saca una hoja por trabajador.
- **Estado de préstamos y descuentos**: se elige si van **todos** (también los ya pagados) o **solo los activos**, y si se incluye el **detalle de cada cuota**. Trae un resumen (valor, descontado, saldo y estado de cada uno, con totales) y, con el detalle, el calendario de cuotas con su **fecha de descuento**, el valor, si ya se descontó (y cuándo), si está pendiente o vencida, y el saldo que queda después de cada cuota. En los de cuotas variables, la lista de descuentos registrados. Tiene espacio para la firma del empleador y del trabajador («Recibí copia»).
- **Historial de llamados de atención y descargos**: todos los llamados y procesos del trabajador con su decisión. El llamado por escrito, la citación, el acta y la decisión de cada proceso se imprimen desde la pestaña Llamados y descargos.
- **Liquidación del contrato**: salario pendiente, cesantías, intereses, prima, vacaciones e indemnización (art. 64 CST), con el neto en letras. Descuenta el saldo de préstamos y descuentos. Los campos vacíos se calculan solos y la liquidación queda guardada en el expediente.

Los datos de la empresa, de quien firma, el logo y el auxilio de transporte por año se configuran en **Ajustes**.

## Exportar la carpeta de un trabajador

En la ficha de cada trabajador, el botón **Exportar ZIP** guarda en un archivo `.zip` toda su carpeta: las subcarpetas (`00. Documentos personales`, `01. Vacaciones`…) y cada documento con el nombre que tiene en la página. Primero pregunta dónde guardarlo y propone el nombre `<NOMBRE DEL TRABAJADOR> - expediente AAAA-MM-DD.zip`. Si algún documento no se encuentra (por ejemplo, porque OneDrive aún no lo ha bajado), el ZIP trae un archivo `DOCUMENTOS QUE NO SE ENCONTRARON.txt` con la lista. El ZIP se abre con el Explorador de Windows sin instalar nada.

## Contenido de la carpeta

Fuera de este repositorio, en `007. Sistema de personal`, están `Copias de seguridad\` (los datos de cada compañía, donde trabaja la página) y `Diseños\` (las versiones de diseño 01 a 03, solo de referencia: no abra dos versiones a la vez, porque comparten los datos del navegador y escribirían la misma copia).

| Archivo | Para qué sirve |
|---|---|
| `index.html` | La aplicación completa (estilos y código incluidos). Se llama así porque GitHub Pages abre `index.html` al entrar a la dirección del sitio. |
| `README.md` | Este manual. |
| `.gitignore` | Impide que se suban copias `.json` u otros archivos con datos. |
| `Crear copia desde carpetas.ps1` / `.bat` | Arma una copia `.json` a partir de carpetas de trabajadores (`001. Palma`, `002. Aprendiz SENA`…). Solo se necesita si alguna vez hay que empezar desde carpetas. Pregunta a qué compañía pertenece (o el nombre de una nueva) y guarda la copia en su subcarpeta de `..\Copias de seguridad`, en el formato de la página: el `.json` y cada documento copiado en `Documentos`. Pide elegir la carpeta que contiene los grupos de trabajadores, muestra qué va a copiar (marca con `?` las carpetas que no parecen grupos de trabajadores) y solo escribe la copia si se responde **S**. |

## Cómo reconoce los soportes

En la página (y en el índice de la copia), cada documento queda en la subcarpeta del trabajador según su tipo, y el nombre indica el periodo. **Cada espacio tiene su carpeta; no hay carpeta de «Otros documentos».** Las carpetas de un trabajador con contrato laboral son:

`00. Documentos personales` · `01. Vacaciones` · `02. Dotación` · `03. Primas` · `04. Intereses de cesantías` · `05. Incapacidades` · `06. Contrato` (contrato, otrosíes, manual de funciones, examen de ingreso, constancias) · `07. Llamados de atención` · `08. Seguridad social` · `09. Retiro de cesantías` · `10. Liquidación y retiro` · `11. Préstamos y descuentos` · `12. Colillas de pago`

(Aprendices SENA y contratistas tienen menos carpetas, también con la suya de préstamos y descuentos.) Las carpetas «Otros documentos» que ya existían siguen viéndose con sus archivos; se pueden pasar a su carpeta con **Mover**.

Al adjuntar desde la aplicación, el nombre se pone solo:

- `03. Primas/Prima de 2026 - segundo semestre.pdf`
- `02. Dotación/Dotación de 2026 - agosto.pdf`
- `04. Intereses de cesantías/Intereses de cesantías de 2025.pdf`
- `01. Vacaciones/Vacaciones de 2025.pdf`
- `08. Seguridad social/Afiliación EPS.pdf`, `Registro RUAF.pdf`
- `06. Contrato/Constancia laboral del 15 de octubre de 2026.pdf`
- `07. Llamados de atención/01. Proceso de descargos del 16 de octubre de 2026/Citación a descargos del 16 de octubre de 2026.pdf`
- `11. Préstamos y descuentos/Autorización de libranza del 5 de octubre de 2026.pdf`
- `12. Colillas de pago/Colilla de pago 2026-10 octubre - primera quincena.pdf`

### Adjuntar sin ir a Documentos

Donde un dato necesita un archivo, al lado está el botón **Adjuntar**:

- **Hoja de vida**: en cada sección se ve qué documento la respalda (cédula, hoja de vida, RUT, contrato, examen de ingreso, renuncia, liquidación, certificado bancario), con **Ver** si ya está o **Adjuntar** si falta.
- **Foto**: clic en la foto (o en las iniciales) de la ficha.
- **Préstamos**: en la ventana del préstamo, junto a «Soporte en el expediente», y en cada préstamo sin soporte («Adjuntar soporte»). El archivo toma el concepto y la fecha del préstamo.
- **Vacaciones**: en el registro de vacaciones, junto a «Soporte en la carpeta».
- **Llamados y descargos**: «Adjuntar anexo» en cada seguimiento y dentro de su ventana; «Adjuntar firmado» al imprimir. Si se adjunta desde la ventana del seguimiento, al terminar vuelve a ella.
- **Imprimir documentos**: «Adjuntar firmado» al lado de cada documento, para subir el escaneo ya firmado.
- En las casillas de los controles (primas, dotación, cesantías, planillas), en afiliaciones y en documentos ya estaba **Adjuntar soporte**.

Al adjuntar desde un formulario, el archivo queda elegido en ese campo y no se pierde lo que ya se había escrito (también si se cancela).

## Reglas de cálculo

- **Desde el ingreso de cada trabajador:** no hay una fecha general de inicio. Cada trabajador se revisa desde su propia fecha de ingreso (o la de la empresa anterior, si viene por sustitución patronal con continuidad): se listan todos sus periodos de vacaciones, dotación, primas y cesantías. Cada uno queda **Soportado** (hay archivo), **Registrado** (pagado o entregado, marcado a mano en la casilla) o **Pendiente**, con su alerta, si no hay ni soporte ni pago registrado.

- **Vacaciones:** 15 días hábiles por cada 360 días laborados (meses comerciales de 30 días), por periodos de aniversario ("Periodo 2024-2025"). Las licencias no remuneradas y suspensiones corren el final del periodo. Los días hábiles excluyen domingos y festivos de Colombia (el sábado es configurable).
- **Dotación:** entregas del 30 de abril, el 31 de agosto y el 20 de diciembre, para quienes devengan hasta 2 SMMLV.
- **Primas:** hasta el 30 de junio y el 20 de diciembre.
- **Cesantías:** intereses hasta el 31 de enero y consignación al fondo hasta el 14 de febrero.

## Privacidad

Las copias de seguridad contienen datos personales y sensibles: documentos de identidad, salarios, cuentas bancarias, incapacidades e historias clínicas. Guárdelas solo en el equipo y en OneDrive, en `007. Sistema de personal\Copias de seguridad`, fuera de la carpeta del repositorio. Mientras se trabaja, los datos abiertos y los documentos que aún no están en la copia también quedan en el almacenamiento del navegador de este equipo. Las copias `.json` y la carpeta `Copias de seguridad` (con sus `Documentos`) están excluidas en `.gitignore`.
