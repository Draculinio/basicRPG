
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
SCREEN 12
'seleccionarPantalla
crearPersonaje
presentacion
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
LOCATE 1, 60
LINE (0, 15)-(640, 15)

END SUB

FUNCTION recibirTecla (tecla$)
retorno = 0
REM up
IF tecla$ = CHR$(0) + CHR$(72) THEN
    IF playery > 1 THEN
        IF escenario(playerx, playery - 1).bloqueante = "N" THEN
            popular "0"
            escenario(playerx, playery) = elementoBase
            playery = playery - 1
            popular "X"
            escenario(playerx, playery) = elementoBase
            dibujarEscenarioGrafico
        END IF
    END IF
END IF

REM down
IF tecla$ = CHR$(0) + CHR$(80) THEN
    IF playery < 23 THEN
        IF escenario(playerx, playery + 1).bloqueante = "N" THEN
            popular "0"
            escenario(playerx, playery) = elementoBase
            playery = playery + 1
            popular "X"
            escenario(playerx, playery) = elementoBase
            dibujarEscenarioGrafico
        END IF
    END IF
END IF

REM left
IF tecla$ = CHR$(0) + CHR$(75) THEN
    IF playerx > 1 THEN
        IF escenario(playerx - 1, playery).bloqueante = "N" THEN
            popular "0"
            escenario(playerx, playery) = elementoBase
            playerx = playerx - 1
            popular "X"
            escenario(playerx, playery) = elementoBase
            dibujarEscenarioGrafico
        END IF
    END IF
END IF

REM right
IF tecla$ = CHR$(0) + CHR$(77) THEN
    IF playerx < 31 THEN
        IF escenario(playerx + 1, playery).bloqueante = "N" THEN
            popular "0"
            escenario(playerx, playery) = elementoBase
            playerx = playerx + 1
            popular "X"
            escenario(playerx, playery) = elementoBase
            dibujarEscenarioGrafico
        END IF
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
DIM personaje%(20, 20)
SELECT CASE clase$
    CASE "Guerrero"
        RESTORE personaG
        FOR y = 1 TO 20
            FOR x = 1 TO 20
                READ personaje%(x, y)
            NEXT
        NEXT
        FOR y = 1 TO 20
            FOR x = 1 TO 20
                PSET (posx * 20 + x, posy * 20 + y), personaje%(x, y)
            NEXT
        NEXT
    CASE "Mago"
        RESTORE personaM
        FOR y = 1 TO 20
            FOR x = 1 TO 20
                READ personaje%(x, y)
            NEXT
        NEXT
        FOR y = 1 TO 20
            FOR x = 1 TO 20
                PSET (posx * 20 + x, posy * 20 + y), personaje%(x, y)
            NEXT
        NEXT
        RESTORE

END SELECT
personaG:
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
personaM:
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

END SUB

SUB dibujarObjeto (posx, posy, nombre$)
DIM cosa%(20, 20)
SELECT CASE RTRIM$(nombre$)
    CASE "Mesa"
        RESTORE mesa
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

END SELECT
mesa:
DATA 00,00,00,00,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06
DATA 00,00,00,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,00,06
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
SLEEP
END SUB
