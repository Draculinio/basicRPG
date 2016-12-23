DIM SHARED escenario$(1 TO 80, 1 TO 20)

REM Variables del jugador
DIM SHARED playerx
DIM SHARED playery
DIM SHARED nombre$

playerx = 1
playery = 1

REM Nombrando al jugador
INPUT "Ingrese el nombre del jugador: ", nombre$

FOR x = 1 TO 80
    FOR y = 1 TO 20
        escenario$(x, y) = "0"
    NEXT
NEXT
escenario$(playerx, playery) = "X"
PRINT dibujarEscenario
flagSalida = 0
DO
    k$ = INKEY$
    flagSalida = recibirTecla(k$)
LOOP UNTIL flagSalida = 1


FUNCTION dibujarEscenario ()
CLS
linea$ = ""
FOR y = 1 TO 20
    FOR x = 1 TO 80
        linea$ = linea$ + escenario$(x, y)
    NEXT
    PRINT linea$
    linea$ = ""
NEXT
PRINT nombre$ + "(" + STR$(playerx) + "," + STR$(playery) + ")"
END FUNCTION

FUNCTION recibirTecla (tecla$)
retorno = 0
REM up
IF tecla$ = CHR$(0) + CHR$(72) THEN
    IF playery > 1 THEN
        escenario$(playerx, playery) = "0"
        playery = playery - 1
        escenario$(playerx, playery) = "X"
        PRINT dibujarEscenario
    END IF
END IF

REM down
IF tecla$ = CHR$(0) + CHR$(80) THEN
    IF playery < 20 THEN
        escenario$(playerx, playery) = "0"
        playery = playery + 1
        escenario$(playerx, playery) = "X"
        PRINT dibujarEscenario
    END IF
END IF

REM left
IF tecla$ = CHR$(0) + CHR$(75) THEN
    IF playerx > 1 THEN
        escenario$(playerx, playery) = "0"
        playerx = playerx - 1
        escenario$(playerx, playery) = "X"
        PRINT dibujarEscenario
    END IF
END IF

REM right
IF tecla$ = CHR$(0) + CHR$(77) THEN
    IF playery < 80 THEN
        escenario$(playerx, playery) = "0"
        playerx = playerx + 1
        escenario$(playerx, playery) = "X"
        PRINT dibujarEscenario
    END IF
END IF

IF tecla$ = CHR$(27) THEN
    retorno = 1
END IF
recibirTecla = retorno
END FUNCTION
