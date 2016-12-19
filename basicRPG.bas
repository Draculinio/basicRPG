DIM SHARED escenario$(1 TO 80, 1 TO 20)

playerx = 1
playery = 1

FOR x = 1 TO 80
    FOR y = 1 TO 20
        escenario$(x, y) = "0"
    NEXT
NEXT
escenario$(playerx, playery) = "X"
PRINT dibujarEscenario
DO
    k$ = INKEY$
    REM up
    IF k$ = CHR$(0) + CHR$(72) THEN
        IF playery > 1 THEN
            escenario$(playerx, playery) = "0"
            playery = playery - 1
            escenario$(playerx, playery) = "X"
            PRINT dibujarEscenario
        END IF
    END IF

    REM down
    IF k$ = CHR$(0) + CHR$(80) THEN
        IF playery < 20 THEN
            escenario$(playerx, playery) = "0"
            playery = playery + 1
            escenario$(playerx, playery) = "X"
            PRINT dibujarEscenario
        END IF
    END IF

    REM left
    IF k$ = CHR$(0) + CHR$(75) THEN
        IF playerx > 1 THEN
            escenario$(playerx, playery) = "0"
            playerx = playerx - 1
            escenario$(playerx, playery) = "X"
            PRINT dibujarEscenario
        END IF
    END IF

    REM right
    IF k$ = CHR$(0) + CHR$(77) THEN
        IF playery < 80 THEN
            escenario$(playerx, playery) = "0"
            playerx = playerx + 1
            escenario$(playerx, playery) = "X"
            PRINT dibujarEscenario
        END IF
    END IF

LOOP UNTIL k$ = CHR$(27)


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
END FUNCTION


