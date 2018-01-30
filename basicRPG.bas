'------------------------------BASIC RPG--------------------------

'---Written by Pablo Soifer---
'---youtube.com/draculinio---

'----------------------------ESTRUCTURAS---------------------------------------------

TYPE wearable
    nombre AS STRING * 20
    ataque AS INTEGER
    defensa AS INTEGER
END TYPE


TYPE personaje
    nombre AS STRING * 20
    bloqueante AS STRING * 1
    fuerza AS INTEGER
    destreza AS INTEGER
    constitucion AS INTEGER
    sabiduria AS INTEGER
    inteligencia AS INTEGER
    carisma AS INTEGER
    puntosGolpe AS INTEGER
    raza AS STRING * 20
    clase AS STRING * 20
    posx AS INTEGER
    posy AS INTEGER
    cabeza AS wearable
    pecho AS wearable
    manoizquierda AS wearable
    manoderecha AS wearable
    pantalon AS wearable
    botas AS wearable
END TYPE

TYPE elemento
    nombre AS STRING * 20
    bloqueante AS STRING * 1
    posx AS INTEGER
    posy AS INTEGER
END TYPE

TYPE enemigo
    nombre AS STRING * 20
    tamano AS STRING * 20
    dado AS INTEGER
    modificadorDado AS INTEGER
    velocidad AS INTEGER
    velocidad2 AS INTEGER
    posx AS INTEGER
    posy AS INTEGER
END TYPE



REM ----------------------------FIN ESTRUCTURAS---------------------------------------------

REM ----------------------MAIN------------------------------

'Variables globales de tipos que me sirven para usar en el programa, en serio QBasic no deja retornar types
DIM SHARED wear AS wearable

DIM SHARED enemigos(10) AS enemigo
DIM SHARED heroe AS personaje
DIM SHARED elementos(10) AS elemento
DIM SHARED escenario(1 TO 31, 1 TO 23) AS INTEGER

'Variables del jugador
heroe.posx = 1
heroe.posy = 1
FOR i = 1 TO 6 'Por las dudas vamos a inicializar todo el equipo del personaje con vacios
    darArma 0, i
NEXT

REM ----FIN DEL ENTORNO----
SCREEN 12
crearPersonaje
REM ---ESCENARIO---
inicializarEnemigos
crearEnemigo "Murcielago", 1, 30, 5
crearEnemigo "Perro", 2, 30, 10
crearElemento "Mesa", 1, 10, 10

REM ---FIN ESCENARIO---

presentacion
resumenHeroe

REM ----CREACION DEL ESCENARIO----
FOR x = 1 TO 31
    FOR y = 1 TO 23
        escenario(x, y) = 0
    NEXT
NEXT
escenario(heroe.posx, heroe.posy) = 1000
escenario(enemigos(1).posx, enemigos(1).posy) = 1
escenario(enemigos(2).posx, enemigos(2).posy) = 2
escenario(10, 10) = 101
REM ----FIN DE CREACION DE ESCENARIO----

REM ----LOOP PRINCIPAL----
dibujarEscenarioGrafico
flagSalida = 0
DO
    k$ = INKEY$
    flagSalida = recibirTecla(k$)

LOOP UNTIL flagSalida = 1
REM ----FIN LOOP PRINCIPAL

REM -------------------------FIN DEL MAIN-----------------------------------


REM -----------CREACION DE PERSONAJES-----------------------------
SUB crearPersonaje ()
DIM caracteristicas%(6) 'array de puntajes para asignar
DIM sumadorCaracteristica(4) 'array para meter cada caracteristica
COLOR 5
LOCATE 1, 30
PRINT "BASIC RPG"
LOCATE 2, 1
COLOR 15
INPUT "Ingrese el nombre del jugador: ", nombre$
heroe.nombre = nombre$
seleccionarRaza
seleccionarClase
FOR x = 1 TO 6
    caracteristica% = 0
    FOR y = 1 TO 4
        sumadorCaracteristica(y) = dado(6)
    NEXT
    'Ordeno el array
    FOR a = 1 TO 4
        FOR b = 1 TO 4
            IF sumadorCaracteristica(b) > sumadorCaracteristica(a) THEN SWAP sumadorCaracteristica(a), sumadorCaracteristica(b)
        NEXT
    NEXT
    'sumo los 3 mayores y los meto en caracterisiticas
    FOR a = 1 TO 3
        caracteristica% = caracteristica% + sumadorCaracteristica(a)
    NEXT
    caracteristicas%(x) = caracteristica%

NEXT
'ordeno el array de caracteristicas
FOR a = 1 TO 6
    FOR b = 1 TO 6
        IF caracteristicas%(b) < caracteristicas%(a) THEN SWAP caracteristicas%(a), caracteristicas%(b)
    NEXT

NEXT

'Asigno caracteristicas
SELECT CASE LTRIM$(RTRIM$(heroe.clase))
    CASE "Barbaro"
        heroe.fuerza% = caracteristicas%(1)
        heroe.destreza = caracteristicas%(2)
        heroe.constitucion = caracteristicas%(3)
        heroe.sabiduria = caracteristicas%(4)
        heroe.carisma = caracteristicas%(5)
        heroe.inteligencia = caracteristicas%(6)
        heroe.puntosGolpe = heroe.constitucion + 12
        darArma 4, 4
    CASE "Mago"
        heroe.inteligencia = caracteristicas%(1)
        heroe.sabiduria = caracteristicas%(2)
        heroe.destreza = caracteristicas%(3)
        heroe.constitucion = caracteristicas%(4)
        heroe.carisma = caracteristicas%(5)
        heroe.fuerza% = caracteristicas%(6)
        heroe.puntosGolpe = heroe.constitucion + 4
    CASE "Guerrero"
        PRINT caracteristicas%(1)
        heroe.fuerza% = caracteristicas%(1)
        heroe.destreza = caracteristicas%(2)
        heroe.constitucion = caracteristicas%(3)
        heroe.inteligencia = caracteristicas%(4)
        heroe.sabiduria = caracteristicas%(5)
        heroe.carisma = caracteristicas%(6)
        heroe.puntosGolpe = heroe.constitucion + 10
        darArma 1, 3
        darArma 4, 4
    CASE ELSE
        PRINT "Something went wrong..."
END SELECT

'Por ultimo los modificadores de raza
SELECT CASE LTRIM$(RTRIM$(heroe.raza))
    CASE "Elfo"
        heroe.destreza = heroe.destreza + 2
        heroe.constitucion = heroe.constitucion - 2
    CASE "Enano"
        heroe.constitucion = heroe.constitucion + 2
        heroe.carisma = heroe.carisma - 2
    CASE "Gnomo"
        heroe.constitucion = heroe.constitucion + 2
        heroe.fuerza% = heroe.fuerza% - 2
END SELECT
END SUB

REM Crea un enemigo, se le pasa por parametro:
REM tipo$ = nombre/codigo
REM posicion = lugar en el array de enemigos
REM posx = posicion en x
REM posy = posicion en y
SUB crearEnemigo (tipo$, posicion, posx, posy)
SELECT CASE tipo$
    CASE "Nulo"
        enemigos(posicion).nombre = tipo$
        enemigos(posicion).tamano = "Nulo"
        enemigos(posicion).dado = 0
        enemigos(posicion).modificadorDado = 0
        enemigos(posicion).velocidad = 0
        enemigos(posicion).velocidad2 = 0
        enemigos(posicion).posx = posx
        enemigos(posicion).posy = posy
    CASE "Murcielago"
        enemigos(posicion).nombre = tipo$
        enemigos(posicion).tamano = "Diminuto"
        enemigos(posicion).dado = 8
        enemigos(posicion).modificadorDado = 0.25
        enemigos(posicion).velocidad = 1
        enemigos(posicion).velocidad2 = 8
        enemigos(posicion).posx = posx
        enemigos(posicion).posy = posy
    CASE "Perro"
        enemigos(posicion).nombre = tipo$
        enemigos(posicion).tamano = "Medio"
        enemigos(posicion).dado = 16
        enemigos(posicion).modificadorDado = 4
        enemigos(posicion).velocidad = 1
        enemigos(posicion).velocidad2 = 8
        enemigos(posicion).posx = posx
        enemigos(posicion).posy = posy

END SELECT
END SUB

'Le da armas al heroe
'El lugar es numerico 1-Cabeza 2-Pecho 3-mano derecha 3-Mano izquierda 4-Pantalon 5-Botas
SUB darArma (codigo, posicion)
DIM arma AS wearable
SELECT CASE codigo
    CASE 0 'VACIO
        arma.nombre = ""
        arma.ataque = 0
        arma.defensa = 0
    CASE 1
        arma.nombre = "Espada Larga"
        arma.ataque = 8
        arma.defensa = 0
    CASE 2
        arma.nombre = "Gran Hacha"
        arma.ataque = 12
        arma.defensa = 0
    CASE 3
        arma.nombre = "Baston"
        arma.ataque = 6
        arma.defensa = 0
    CASE 4
        arma.nombre = "Rodela"
        arma.ataque = 0
        arma.defensa = 1
END SELECT
SELECT CASE posicion
    CASE 1
        heroe.cabeza = arma
    CASE 2
        heroe.pecho = arma
    CASE 3
        heroe.manoderecha = arma
    CASE 4
        heroe.manoizquierda = arma
    CASE 5
        heroe.pantalon = arma
    CASE 6
        heroe.botas = arma
END SELECT
END SUB


SUB inicializarEnemigos ()
FOR a = 1 TO 10
    crearEnemigo "Nulo", a, 0, 0
NEXT
END SUB

SUB crearElemento (tipo$, posicion, posx, posy)
SELECT CASE tipo$
    CASE "Mesa"
        elementos(posicion).nombre = tipo$
        elementos(posicion).bloqueante = "S"
        elementos(posicion).posx = posx
        elementos(posicion).posy = posy
END SELECT
END SUB

'Esta es la funcion que tiene toda la magia, recibe una tecla decide una accion por ello y retorna algo, si es 1 va a ser el fin del programa
FUNCTION recibirTecla (tecla$)
retorno = 0
IF tecla$ = CHR$(0) + CHR$(72) THEN 'arriba
    IF heroe.posy > 1 THEN
        IF escenario(heroe.posx, heroe.posy - 1) = 0 THEN
            escenario(heroe.posx, heroe.posy) = 0
            escenario(heroe.posx, heroe.posy - 1) = 1000
            heroe.posy = heroe.posy - 1
            moverEnemigo
            dibujarEscenarioGrafico
        END IF
    END IF
END IF
IF tecla$ = CHR$(0) + CHR$(80) THEN 'abajo
    IF heroe.posy < 23 THEN
        IF escenario(heroe.posx, heroe.posy + 1) = 0 THEN
            escenario(heroe.posx, heroe.posy) = 0
            escenario(heroe.posx, heroe.posy + 1) = 1000
            heroe.posy = heroe.posy + 1
            moverEnemigo
            dibujarEscenarioGrafico
        END IF
    END IF
END IF

IF tecla$ = CHR$(0) + CHR$(75) THEN 'izquierda
    IF heroe.posx > 1 THEN
        IF escenario(heroe.posx - 1, heroe.posy) = 0 THEN
            escenario(heroe.posx, heroe.posy) = 0
            escenario(heroe.posx - 1, heroe.posy) = 1000
            heroe.posx = heroe.posx - 1
            moverEnemigo
            dibujarEscenarioGrafico
        END IF
    END IF
END IF

IF tecla$ = CHR$(0) + CHR$(77) THEN 'derecha
    IF heroe.posx < 31 THEN
        IF escenario(heroe.posx + 1, heroe.posy) = 0 THEN
            escenario(heroe.posx, heroe.posy) = 0
            escenario(heroe.posx + 1, heroe.posy) = 1000
            heroe.posx = heroe.posx + 1
            moverEnemigo
            dibujarEscenarioGrafico
        END IF
    END IF
END IF

IF tecla$ = CHR$(27) THEN 'ESC = Salir del juego
    retorno = 1
END IF

IF tecla$ = "s" THEN 'Resumen del heroe
    resumenHeroe
    dibujarEscenarioGrafico
END IF

IF tecla$ = CHR$(0) + CHR$(59) THEN 'F1 = Comandos del juego
    mostrarComandos
    dibujarEscenarioGrafico
END IF
recibirTecla = retorno
END FUNCTION

REM Mueve los enemigos aleatoriamente
SUB moverEnemigo ()
FOR a = 1 TO 10
    IF RTRIM$(enemigos(a).nombre) <> "Nulo" THEN
        movimiento = dado(5)
        SELECT CASE movimiento
            CASE 1 'ARRIBA
                IF enemigos(a).posy > 1 THEN
                    IF escenario(enemigos(a).posx, enemigos(a).posy - 1) = 0 THEN
                        escenario(enemigos(a).posx, enemigos(a).posy) = 0
                        escenario(enemigos(a).posx, enemigos(a).posy - 1) = a
                        enemigos(a).posy = enemigos(a).posy - 1
                    END IF
                END IF
            CASE 2 'ABAJO
                IF enemigos(a).posy < 23 THEN
                    IF escenario(enemigos(a).posx, enemigos(a).posy + 1) = 0 THEN
                        escenario(enemigos(a).posx, enemigos(a).posy) = 0
                        escenario(enemigos(a).posx, enemigos(a).posy + 1) = a
                        enemigos(a).posy = enemigos(a).posy + 1
                    END IF
                END IF
            CASE 3 'DERECHA
                IF enemigos(a).posx < 31 THEN
                    IF escenario(enemigos(a).posx + 1, enemigos(a).posy) = 0 THEN
                        escenario(enemigos(a).posx, enemigos(a).posy) = 0
                        escenario(enemigos(a).posx + 1, enemigos(a).posy) = a
                        enemigos(a).posx = enemigos(a).posx + 1
                    END IF
                END IF
            CASE 4 'IZQUIERDA
                IF enemigos(a).posx > 1 THEN
                    IF escenario(enemigos(a).posx - 1, enemigos(a).posy) = 0 THEN
                        escenario(enemigos(a).posx, enemigos(a).posy) = 0
                        escenario(enemigos(a).posx - 1, enemigos(a).posy) = a
                        enemigos(a).posx = enemigos(a).posx - 1
                    END IF
                END IF
        END SELECT
    END IF
NEXT
END SUB

SUB seleccionarRaza ()
PRINT "Seleccione raza (h-Humano/e-Elfo/d-Enano/g-Gnomo): "
SLEEP
k$ = UCASE$(INKEY$)
SELECT CASE k$
    CASE "H"
        heroe.raza = "Humano"
    CASE "E"
        heroe.raza = "Elfo"
    CASE "D"
        heroe.raza = "Enano"
    CASE "G"
        heroe.raza = "Gnomo"
    CASE ELSE
        heroe.raza = "Humano"
END SELECT
END SUB

SUB seleccionarClase ()
k$ = ""
PRINT "Seleccione clase (g-GUERRERO/m-MAGO/b-BARBARO): "
SLEEP
k$ = UCASE$(INKEY$)
SELECT CASE k$
    CASE "G"
        heroe.clase = "Guerrero"
    CASE "M"
        heroe.clase = "Mago"
    CASE "B"
        heroe.clase = "Barbaro"
    CASE ELSE
        heroe.clase = "Guerrero"
END SELECT
END SUB

REM ---------------------------------------------FUNCIONES DE DIBUJO-----------------------------------

SUB presentacion
CLS
LOCATE 10, 10
PRINT "______   ___   _____  _____  _____  ______ ______  _____"
LOCATE 11, 10
PRINT "| ___ \ / _ \ /  ___||_   _|/  __ \ | ___ \| ___ \|  __ \"
LOCATE 12, 10
PRINT "| |_/ // /_\ \\ `--.   | |  | /  \/ | |_/ /| |_/ /| |  \/"
LOCATE 13, 10
PRINT "| ___ \|  _  | `--. \  | |  | |     |    / |  __/ | | __"
LOCATE 14, 10
PRINT "| |_/ /| | | |/\__/ / _| |_ | \__/\ | |\ \ | |    | |_\ \"
LOCATE 15, 10
PRINT "\____/ \_| |_/\____/  \___/  \____/ \_| \_|\_|     \____/"
LOCATE 18, 40
PRINT "Version 0.0.5E"
SLEEP
END SUB

SUB dibujarEscenarioGrafico ()
CLS
px = 0
py = 0
FOR y = 1 TO 23
    FOR x = 1 TO 31
        SELECT CASE escenario(x, y)
            CASE 1000
                dibujarCosas x, y, RTRIM$(heroe.clase)
            CASE 1 TO 10
                dibujarCosas x, y, RTRIM$(enemigos(escenario(x, y)).nombre)
            CASE 101 TO 110
                dibujarCosas x, y, RTRIM$(elementos(escenario(x, y) - 100).nombre)
        END SELECT
    NEXT
NEXT
LOCATE 1, 1
PRINT nombre$ + "(" + STR$(heroe.posx) + "," + STR$(heroe.posy) + ")"
LOCATE 1, 10
PRINT LTRIM$(RTRIM$(heroe.clase)) + " " + LTRIM$(RTRIM$(heroe.raza))
LOCATE 1, 40

PRINT "F: " + STR$(heroe.fuerza%) + " D: " + STR$(heroe.destreza) + " C: " + STR$(heroe.constitucion) + " S: " + STR$(heroe.sabiduria) + " I: " + STR$(heroe.inteligencia) + " CM: " + STR$(heroe.carisma)
LINE (0, 15)-(640, 15)
END SUB

'Muestra los comandos existentes
SUB mostrarComandos ()
CLS
LINE (5, 10)-(630, 11), 5
LINE (5, 470)-(630, 470), 5
LINE (5, 10)-(5, 470), 5
LINE (630, 11)-(630, 470), 5
LOCATE 5, 30
PRINT "COMANDOS"
LOCATE 7, 20
PRINT "F. Arriba: Arriba"
LOCATE 8, 20
PRINT "F. Abajo: Abajo"
LOCATE 9, 20
PRINT "F. Izquierda: Izquierda"
LOCATE 10, 20
PRINT "F. Derecha: Derecha"
LOCATE 11, 20
PRINT "s: Datos del jugador"
LOCATE 12, 20
PRINT "F1: Este Menu"
LOCATE 14, 20
PRINT "Esc: Salir del juego"

SLEEP
END SUB

SUB resumenHeroe ()
CLS
LINE (5, 10)-(630, 11), 5
LINE (5, 470)-(630, 470), 5
LINE (5, 10)-(5, 470), 5
LINE (630, 11)-(630, 470), 5
heroe$ = LTRIM$(RTRIM$(heroe.clase))
dibujarCosas 12, 5, heroe$
IF LTRIM$(RTRIM$(heroe.manoderecha.nombre)) <> "" THEN
    dibujarCosas 5, 5, LTRIM$(RTRIM$(heroe.manoderecha.nombre))
END IF
IF LTRIM$(RTRIM$(heroe.manoizquierda.nombre)) <> "" THEN
    dibujarCosas 24, 5, LTRIM$(RTRIM$(heroe.manoizquierda.nombre))
END IF
COLOR 5
LOCATE 2, 35
PRINT "CARACTERISTICAS"
COLOR 15
LOCATE 14, 25
PRINT "Nombre: " + heroe.nombre
LOCATE 15, 25
PRINT "Raza: " + heroe.raza
LOCATE 16, 25
PRINT "Clase: " + heroe.clase
LOCATE 17, 25
PRINT "Fuerza: " + STR$(heroe.fuerza%)
LOCATE 18, 25
PRINT "Destreza: " + STR$(heroe.destreza)
LOCATE 19, 25
PRINT "Constitucion: " + STR$(heroe.constitucion)
LOCATE 20, 25
PRINT "Sabiduria: " + STR$(heroe.sabiduria)
LOCATE 21, 25
PRINT "Inteligencia: " + STR$(heroe.inteligencia)
LOCATE 22, 25
PRINT "Carisma: " + STR$(heroe.carisma)
LOCATE 23, 25
PRINT "Puntos de Golpe: " + STR$(heroe.puntosGolpe)
LOCATE 24, 25
PRINT "Brazo Derecho: " + heroe.manoderecha.nombre
SLEEP
END SUB

SUB dibujarCosas (posx, posy, cosaADibujar$)
DIM cosa%(20, 20)
SELECT CASE cosaADibujar$
    CASE "Guerrero"
        RESTORE Guerrero
    CASE "Mago"
        RESTORE Mago
    CASE "Barbaro"
        RESTORE Barbaro
    CASE "Murcielago"
        RESTORE Murcielago
    CASE "Perro"
        RESTORE Perro
    CASE "Mesa"
        RESTORE Mesa
    CASE "Espada Larga"
        RESTORE EspadaLarga
    CASE "Rodela"
        RESTORE Rodela
END SELECT
FOR y = 1 TO 20
    FOR x = 1 TO 20
        READ cosa%(x, y)
    NEXT
NEXT
FOR y = 1 TO 20
    FOR x = 1 TO 20
        PSET (posx * 20 + x, posy * 20 + y), cosa%(x, y)
    NEXT
NEXT
Guerrero:
DATA 00,00,00,15,00,00,00,07,07,07,07,07,07,00,00,00,00,00,00,00
DATA 00,00,00,15,00,00,07,07,07,07,07,07,07,07,00,00,00,00,00,00
DATA 00,00,15,15,00,00,07,07,07,07,07,07,07,07,00,00,00,00,00,00
DATA 00,00,15,15,00,00,00,06,06,06,06,06,06,00,00,00,00,00,00,00
DATA 00,00,15,15,00,00,00,06,06,06,06,06,06,00,00,00,00,00,00,00
DATA 00,00,15,15,00,00,00,06,06,06,06,06,06,00,00,00,00,00,00,00
DATA 00,00,15,15,00,00,00,06,06,06,06,06,06,00,00,00,00,00,00,00
DATA 00,00,15,15,00,00,00,00,05,05,05,05,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,05,05,05,05,00,00,00,00,00,00,00,00
DATA 00,00,06,06,06,06,08,08,14,14,14,14,08,18,06,06,06,06,00,00
DATA 00,00,01,01,00,00,00,00,14,14,14,14,00,00,00,00,00,00,00,00
DATA 00,00,01,01,00,00,00,00,14,14,14,14,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,00,14,14,00,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,14,14,14,14,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,06,00,00,00,00,06,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,06,00,00,00,00,00,00,06,00,00,00,00,00,00
DATA 00,00,00,00,00,06,00,00,00,00,00,00,00,00,06,00,00,00,00,00
DATA 00,00,00,00,14,00,00,00,00,00,00,00,00,00,00,14,00,00,00,00
DATA 00,00,00,14,00,00,00,00,00,00,00,00,00,00,00,00,14,00,00,00
DATA 00,00,14,00,00,00,00,00,00,00,00,00,00,00,00,00,00,14,00,00
Mago:
DATA 00,00,00,00,00,00,00,00,05,05,05,05,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,05,05,05,05,05,05,05,05,00,00,00,00,00,00
DATA 00,00,00,00,05,05,05,05,05,05,05,05,05,05,05,00,00,00,00,00
DATA 00,00,00,00,00,00,00,06,06,06,06,06,06,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,06,06,06,06,06,06,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,06,06,06,06,06,06,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,09,06,06,06,06,06,06,09,00,00,00,00,00,00
DATA 00,00,00,00,00,00,09,09,05,05,05,05,09,09,00,00,00,00,00,00
DATA 00,00,00,00,00,00,09,09,05,05,05,05,09,09,00,00,00,00,00,00
DATA 00,00,05,05,05,05,05,05,05,05,05,05,05,05,05,05,05,05,00,00
DATA 00,00,00,00,09,09,09,09,05,05,05,05,09,09,09,09,00,00,00,00
DATA 00,00,00,00,09,09,09,09,05,05,05,05,09,09,09,09,00,00,00,00
DATA 00,00,00,00,09,09,09,09,00,05,05,09,09,09,09,09,00,00,00,00
DATA 00,00,00,00,09,09,09,09,05,05,05,05,09,09,09,09,00,00,00,00
DATA 00,00,00,09,09,09,09,05,09,09,09,00,05,09,09,09,09,00,00,00
DATA 00,00,00,09,09,09,05,09,09,09,09,09,09,05,09,09,09,00,00,00
DATA 00,00,00,09,09,05,09,09,09,09,09,09,09,09,05,00,09,00,00,00
DATA 00,00,00,09,05,09,09,09,09,09,09,09,09,09,09,05,09,00,00,00
DATA 00,00,00,05,09,09,09,09,09,09,09,09,09,09,09,09,05,00,00,00
DATA 00,00,05,09,09,09,09,09,09,09,09,09,09,09,09,09,09,05,00,00
Barbaro:
DATA 00,00,00,00,00,00,00,00,15,15,15,15,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,06,06,06,06,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,06,06,06,06,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,06,06,06,06,00,00,00,00,00,00,00,00
DATA 00,07,07,00,00,00,00,00,06,06,06,06,00,00,00,00,00,00,00,00
DATA 07,07,07,07,00,00,00,00,00,06,06,00,00,00,00,00,00,00,00,00
DATA 00,07,07,00,00,00,06,06,06,06,06,06,06,06,00,00,00,00,00,00
DATA 00,07,07,00,00,06,00,06,06,06,06,06,06,00,06,06,00,00,00,00
DATA 00,07,07,00,06,06,00,06,06,06,06,06,06,00,06,06,00,00,00,00
DATA 00,07,07,06,06,00,00,06,06,06,06,06,06,00,06,06,00,00,00,00
DATA 00,07,07,00,00,00,00,06,06,06,06,06,06,00,06,06,00,00,00,00
DATA 00,00,00,00,00,00,00,04,04,04,04,04,04,00,06,06,00,00,00,00
DATA 00,00,00,00,00,00,00,04,04,04,04,04,04,00,06,06,00,00,00,00
DATA 00,00,00,00,00,00,00,04,04,00,00,04,04,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,06,06,00,00,06,06,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,06,06,00,00,06,06,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,06,06,00,00,06,06,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,06,06,00,00,06,06,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,04,04,00,00,04,04,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,04,04,00,00,04,04,00,00,00,00,00,00,00
Murcielago:
DATA 00,00,00,00,00,00,00,01,01,00,00,01,01,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,01,01,00,00,01,01,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,01,01,01,01,01,01,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,01,01,01,01,01,01,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,01,00,01,01,00,01,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,01,01,01,01,01,01,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,01,01,01,01,01,01,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,01,01,01,01,01,01,01,01,00,00,00,00,00,00
DATA 00,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,00
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 00,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,00
DATA 00,00,00,00,00,00,01,01,01,01,01,01,01,01,01,00,00,00,00,00
DATA 00,00,00,00,00,00,00,01,01,00,00,00,01,01,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,01,01,00,00,00,01,01,00,00,00,00,00,00
DATA 00,00,00,00,00,00,01,01,01,01,00,01,01,01,01,00,00,00,00,00
Perro:
DATA 00,00,06,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,00,06,06,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,06,06,06,06,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,06,06,06,06,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,06,01,01,06,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 06,06,01,01,06,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 06,06,06,06,06,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,06,06,06,06,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,06,06,06,06,06,06,06,06,07,07,06,06,06,06,00,00,00,00,00
DATA 00,00,00,00,06,06,06,06,06,07,07,06,06,06,06,06,00,00,00,00
DATA 00,00,00,00,06,06,06,06,06,07,07,06,06,06,06,06,06,06,06,06
DATA 00,00,00,00,06,06,06,06,06,07,07,06,06,06,06,06,00,00,00,00
DATA 00,00,00,00,00,06,06,00,06,06,00,06,06,00,06,06,00,00,00,00
DATA 00,00,00,00,00,06,06,00,06,06,00,06,06,00,06,06,00,00,00,00
DATA 00,00,00,00,00,06,06,00,06,06,00,06,06,00,06,06,00,00,00,00
DATA 00,00,00,00,00,06,06,00,06,06,00,06,06,00,06,06,00,00,00,00
DATA 00,00,00,00,00,06,06,00,06,06,00,06,06,00,06,06,00,00,00,00
DATA 00,00,00,00,00,06,06,00,06,06,00,06,06,00,06,06,00,00,00,00
DATA 00,00,00,00,00,06,06,00,06,06,00,06,06,00,06,06,00,00,00,00
DATA 00,00,00,00,00,06,06,00,06,06,00,06,06,00,06,06,00,00,00,00

Mesa:
DATA 00,00,00,00,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06
DATA 00,00,00,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06
DATA 00,00,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,00,06
DATA 00,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,00,00,06
DATA 06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06
DATA 06,00,00,00,06,00,00,00,00,00,00,00,00,00,00,06,00,00,00,06

EspadaLarga:
DATA 00,00,00,00,00,00,00,00,00,07,07,00,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,07,07,07,07,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,07,07,07,08,07,07,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,07,07,07,08,07,07,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,07,07,07,08,07,07,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,07,07,07,08,07,07,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,07,07,07,08,07,07,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,07,07,07,08,07,07,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,07,07,07,08,07,07,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,07,07,07,08,07,07,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,07,07,07,08,07,07,00,00,00,00,00,00,00
DATA 00,00,00,06,06,00,00,07,07,07,08,07,07,00,00,06,06,00,00,00
DATA 00,00,00,06,06,06,06,06,06,06,06,06,06,06,06,06,06,00,00,00
DATA 00,00,00,06,06,06,06,06,06,06,06,06,06,06,06,06,00,00,00,00
DATA 00,00,00,00,06,06,06,06,06,06,06,06,06,06,06,00,00,00,00,00
DATA 00,00,00,00,00,00,06,06,06,06,06,06,06,06,00,00,00,00,00,00
DATA 00,00,00,00,00,00,06,06,06,06,06,06,06,06,00,00,00,00,00,00
DATA 00,00,00,00,00,00,04,04,04,04,04,04,04,04,00,00,00,00,00,00
DATA 00,00,00,00,00,06,06,06,06,06,06,06,06,06,06,00,00,00,00,00
DATA 00,00,00,00,00,06,06,06,06,06,06,06,06,06,06,00,00,00,00,00

Rodela:
DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,00,06,06,00,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,06,07,07,06,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,06,07,07,07,07,06,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,06,07,07,07,07,07,07,06,00,00,00,00,00,00
DATA 00,00,00,00,00,06,07,07,07,07,07,07,07,07,06,00,00,00,00,00
DATA 00,00,00,00,06,07,07,07,07,07,07,07,07,07,07,06,00,00,00,00
DATA 00,00,00,06,07,07,07,07,07,07,07,07,07,07,07,07,06,00,00,00
DATA 00,00,00,06,07,07,07,07,07,07,07,07,07,07,07,07,06,00,00,00
DATA 00,00,00,00,06,07,07,07,07,07,07,07,07,07,07,06,00,00,00,00
DATA 00,00,00,00,00,06,07,07,07,07,07,07,07,07,06,00,00,00,00,00
DATA 00,00,00,00,00,00,06,07,07,07,07,07,07,06,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,06,07,07,07,07,06,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,06,07,07,06,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,00,06,06,00,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

END SUB

REM -----------------------------------FIN FUNCIONES DE DIBUJO-------------------------------------

FUNCTION dado (caras AS INTEGER)
resultado% = INT(RND * caras) + 1
dado = resultado%
END FUNCTION

REM ----LEGACY, quizá algún día vuelvas-----
SUB seleccionarPantalla ()
INPUT "Seleccione modo de juego pantalla (1-640x480, 16 colores / 2-320x200 256 colores): ", modo
IF modo = 1 THEN
    SCREEN 12
ELSE
    SCREEN 13
END IF
END SUB
