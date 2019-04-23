
CONST size = 23
CONST height = 31
DIM mapa(size, height) AS STRING
OPEN "map.lvl" FOR INPUT AS 1
IF EOF(1) THEN
    PRINT "Fin de archivo"
END IF
'INPUT #1, elemento$
'PRINT elemento$
'INPUT #1, elemento$
'PRINT elemento$
FOR i = 1 TO size
    INPUT #1, elemento$
    'PRINT mid$(elemento$,1,1)
    FOR j = 1 TO height
        mapa(i, j) = MID$(elemento$, j, 1)
    NEXT
NEXT
CLOSE 1



'conversor
FOR i = 1 TO size
    FOR j = 1 TO height
        SELECT CASE mapa(i, j)
            CASE "0"
                PRINT ("Espacio vacio")
            CASE "1"
                PRINT ("Heroe")
            CASE "2"
                PRINT ("Murcielago")
            CASE "3"
                PRINT ("Perro")
            CASE "4"
                PRINT ("Mesa")
            CASE "5"
                PRINT ("Moneda")
            CASE ELSE
                PRINT ("----ERROR----")

        END SELECT
    NEXT
NEXT

