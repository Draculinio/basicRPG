REM ------------------------------BASIC RPG--------------------------

REM ----ENTORNO----
REM Todo elemento es una variable de tipo elemento
TYPE elemento
    nombre AS STRING * 20
    bloqueante AS STRING * 1
END TYPE

DIM SHARED elementoBase AS elemento
elementoBase.nombre = "Vacio"
elementoBase.bloqueante = "N"

DIM SHARED mapa(1 TO 31, 1 TO 23) AS STRING
DIM SHARED escenario(1 TO 31, 1 TO 23) AS elemento
REM Variables del jugador
DIM SHARED playerx
DIM SHARED playery
DIM SHARED nombre$
DIM SHARED clase$
DIM SHARED raza$
playerx = 1
playery = 1
REM ----FIN DEL ENTORNO----

seleccionarPantalla
crearPersonaje

REM ----CREACION DEL ESCENARIO----
FOR x = 1 TO 31
    FOR y = 1 TO 23
        popular "0"
        escenario(x, y) = elementoBase
    NEXT
NEXT
popular "X"
escenario(playerx, playery) = elementoBase
popular "M"
escenario(10, 10) = elementoBase
PRINT escenario(1, 1).nombre
REM ----FIN DE CREACION DE ESCENARIO----

dibujarEscenarioGrafico

flagSalida = 0
DO
    k$ = INKEY$
    flagSalida = recibirTecla(k$)
LOOP UNTIL flagSalida = 1

SUB crearPersonaje ()
INPUT "Ingrese el nombre del jugador: ", nombre$
seleccionarRaza
seleccionarClase
END SUB

SUB seleccionarPantalla ()
INPUT "Seleccione modo de juego pantalla (1-640x480, 16 colores / 2-320x200 256 colores): ", modo
IF modo = 1 THEN
    SCREEN 12
ELSE
    SCREEN 13
END IF
END SUB

SUB dibujarEscenarioGrafico ()
CLS
px = 0
py = 0
LOCATE 5, 5
PRINT escenario(1, 1).nombre
FOR y = 1 TO 23
    FOR x = 1 TO 31
        SELECT CASE RTRIM$(escenario(x, y).nombre)
            CASE nombre$
                dibujarPersonaje x, y
            CASE "Mesa"
                dibujarObjeto x, y, escenario(x, y).nombre
        END SELECT
    NEXT
NEXT
LOCATE 1, 1
PRINT nombre$ + "(" + STR$(playerx) + "," + STR$(playery) + ")"
LOCATE 1, 40
PRINT clase$ + " " + raza$
LINE (0, 15)-(640, 15)

END SUB

FUNCTION recibirTecla (tecla$)
retorno = 0
REM up
IF tecla$ = CHR$(0) + CHR$(72) THEN
    IF playery > 1 THEN
        popular "0"
        escenario(playerx, playery) = elementoBase
        playery = playery - 1
        popular "X"
        escenario(playerx, playery) = elementoBase
        dibujarEscenarioGrafico
    END IF
END IF

REM down
IF tecla$ = CHR$(0) + CHR$(80) THEN
    IF playery < 23 THEN
        popular "0"
        escenario(playerx, playery) = elementoBase
        playery = playery + 1
        popular "X"
        escenario(playerx, playery) = elementoBase
        dibujarEscenarioGrafico
    END IF
END IF

REM left
IF tecla$ = CHR$(0) + CHR$(75) THEN
    IF playerx > 1 THEN
        popular "0"
        escenario(playerx, playery) = elementoBase
        playerx = playerx - 1
        popular "X"
        escenario(playerx, playery) = elementoBase
        dibujarEscenarioGrafico
    END IF
END IF

REM right
IF tecla$ = CHR$(0) + CHR$(77) THEN
    IF playerx < 31 THEN
        popular "0"
        escenario(playerx, playery) = elementoBase
        playerx = playerx + 1
        popular "X"
        escenario(playerx, playery) = elementoBase
        dibujarEscenarioGrafico
    END IF
END IF

IF tecla$ = CHR$(27) THEN
    retorno = 1
END IF
recibirTecla = retorno
END FUNCTION

SUB seleccionarRaza ()
PRINT "Seleccione raza (h-Humano/e-Elfo): "
SLEEP
k$ = UCASE$(INKEY$)
SELECT CASE k$
    CASE "H"
        raza$ = "Humano"
    CASE "E"
        raza$ = "Elfo"
    CASE ELSE
        raza$ = "Humano"
END SELECT
END SUB

SUB seleccionarClase ()
k$ = ""
PRINT "Seleccione clase (g-Guerrero/m-Mago): "
SLEEP
k$ = UCASE$(INKEY$)
SELECT CASE k$
    CASE "G"
        clase$ = "Guerrero"
    CASE "M"
        clase$ = "Mago"
    CASE ELSE
        clase$ = "Guerrero"
END SELECT
END SUB


REM *******************PERSONAJE**********************
SUB dibujarPersonaje (posx, posy)
color_personaje = 0
SELECT CASE clase$
    CASE "Guerrero"
        color_personaje = color_personaje + 1
    CASE "Mago"
        color_personaje = color_personaje + 2
END SELECT
SELECT CASE raza$
    CASE "Humano"
        color_personaje = color_personaje + 3
    CASE "Mago"
        color_personaje = color_personaje + 4
END SELECT
LINE (posx * 20, posy * 20)-(posx * 20 + 20, posy * 20 + 20), color_personaje, BF
END SUB

SUB dibujarObjeto (posx, posy, nombre$)
SELECT CASE nombre$
    CASE "Mesa"
        LINE (posx * 20, posy * 20)-(posx * 20 + 20, posy * 20 + 20), 2, BF
END SELECT
END SUB

SUB popular (simbolo$)
SELECT CASE simbolo$
    CASE "0"
        elementoBase.nombre = "Suelo"
        elementoBase.bloqueante = "N"
    CASE "X"
        elementoBase.nombre = nombre$
        elementoBase.bloqueante = "S"
    CASE "M"
        elementoBase.nombre = "Mesa"
        elementoBase.bloqueante = "S"
END SELECT
END SUB
