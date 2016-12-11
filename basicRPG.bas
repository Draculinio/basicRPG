DIM escenario$(1 TO 80, 1 TO 20)
DIM linea$
FOR x = 1 TO 80
    FOR y = 1 TO 20
        escenario$(x, y) = "0"
    NEXT
NEXT
escenario$(1, 1) = "X"
FOR y = 1 TO 20
    FOR x = 1 TO 80
        linea$ = linea$ + escenario$(x, y)
    NEXT
    PRINT linea$
    linea$ = ""
NEXT

