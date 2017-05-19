REM ------------------------------BASIC RPG--------------------------

REM ----ENTORNO----
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
END TYPE

TYPE elemento
    nombre AS STRING * 20
    bloqueante AS STRING * 1
    posx as INTEGER
    posy as INTEGER
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

DIM SHARED enemigos(10) AS enemigo
DIM SHARED heroe AS personaje
DIM SHARED elementos(10) AS elemento
DIM SHARED escenario(1 TO 31, 1 TO 23) AS INTEGER
REM Variables del jugador
heroe.posx = 1
heroe.posy = 1
REM ----FIN DEL ENTORNO----
SCREEN 12
crearPersonaje
REM ---ESCENARIO---
inicializarEnemigos
crearEnemigo "Murcielago", 1, 30, 5
crearElemento "Mesa", 1, 10, 10
REM ---FIN ESCENARIO---
presentacion
REM ----CREACION DEL ESCENARIO----
FOR x = 1 TO 31
    FOR y = 1 TO 23
        escenario(x, y) = 0
    NEXT
NEXT
escenario(heroe.posx, heroe.posy) = 1000
escenario(enemigos(1).posx,enemigos(1).posy)=1
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

SUB crearPersonaje ()
DIM caracteristicas%(6) 'array de puntajes para asignar
DIM sumadorCaracteristica(4) 'array para meter cada caracteristica
INPUT "Ingrese el nombre del jugador: ", nombre$
heroe.nombre = nombre$
seleccionarRaza
seleccionarClase
FOR x = 1 TO 6
    caracteristica% = 0
    FOR y = 1 TO 4
        sumadorCaracteristica(y) = 0
        sumadorCaracteristica(y) = dado(6)
    NEXT
    'Ordeno el array
    FOR a = 1 TO 4
        FOR b = 1 TO 4
            IF sumadorCaracteristica(b) > sumadorCaracteristica(a) THEN SWAP sumadorCaracteristica(a), sumadorCaracteristica(b)
        NEXT
    NEXT
    REM PRINT sumadorCaracteristica(1)
    REM SLEEP
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
'Asigno caracter�sticas
SELECT CASE heroe.clase
    CASE "Barbaro"
        personaje.fuerza = caracteristicas%(1)
        personaje.destreza = caracteristicas%(2)
        personaje.constitucion = caracteristicas%(3)
        personaje.sabiduria = caracteristicas%(4)
        personaje.carisma = caracteristicas%(5)
        personaje.inteligencia = caracteristicas%(6)
        personaje.puntosGolpe = personaje.constitucion + 12
    CASE "Mago"
        personaje.inteligencia = caracteristicas%(1)
        personaje.sabiduria = caracteristicas%(2)
        personaje.destreza = caracteristicas%(3)
        personaje.constitucion = caracteristicas%(4)
        personaje.carisma = caracteristicas%(5)
        personaje.fuerza = caracteristicas%(6)
        personaje.puntosGolpe = personaje.constitucion + 4
    CASE "Guerrero"
        personaje.fuerza = caracteristicas%(1)
        personaje.destreza = caracteristicas%(2)
        personaje.constitucion = caracteristicas%(3)
        personaje.inteligencia = caracteristicas%(4)
        personaje.sabiduria = caracteristicas%(5)
        personaje.carisma = caracteristicas%(6)
        personaje.puntosGolpe = personaje.constitucion + 10
END SELECT

'Por �ltimo los modificadores de raza
SELECT CASE heroe.raza
    CASE "Elfo"
        personaje.destreza = personaje.destreza + 2
        personaje.constitucion = personaje.constitucion - 2
    CASE "Enano"
        personaje.constitucion = personaje.constitucion + 2
        personaje.carisma = personaje.carisma - 2
    CASE "Gnomo"
        personaje.constitucion = personaje.constitucion + 2
        personaje.fuerza = personaje.fuerza - 2
END SELECT

END SUB
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
END SELECT
END SUB

SUB inicializarEnemigos()
    FOR a = 1 TO 10
        crearEnemigo "Nulo",a,0,0
    NEXT
END SUB

SUB crearElemento (tipo$,posicion,posx,posy)
SELECT CASE tipo$
    CASE "Mesa"
        elementos(posicion).nombre = tipo$
        elementos(posicion).bloqueante = "S"
        elementos(posicion).posx = posx
        elementos(posicion).posy = posy
END SELECT
END SUB

FUNCTION recibirTecla (tecla$)
retorno = 0
REM up
IF tecla$ = CHR$(0) + CHR$(72) THEN
    IF heroe.posy > 1 THEN
        IF escenario(heroe.posx, heroe.posy - 1)= 0 THEN
            escenario(heroe.posx,heroe.posy)=0
            escenario(heroe.posx,heroe.posy-1)=1000    
            heroe.posy = heroe.posy - 1
            moverEnemigo
            dibujarEscenarioGrafico
        END IF
    END IF
END IF

REM down
IF tecla$ = CHR$(0) + CHR$(80) THEN
    IF heroe.posy < 23 THEN
        IF escenario(heroe.posx, heroe.posy + 1) = 0 THEN
            escenario(heroe.posx,heroe.posy)=0
            escenario(heroe.posx,heroe.posy+1)=1000
            heroe.posy = heroe.posy + 1
            moverEnemigo
            dibujarEscenarioGrafico
        END IF
    END IF
END IF

REM left
IF tecla$ = CHR$(0) + CHR$(75) THEN
    IF heroe.posx > 1 THEN
        IF escenario(heroe.posx - 1, heroe.posy)=0 THEN
            escenario(heroe.posx,heroe.posy)=0
            escenario(heroe.posx-1,heroe.posy)=1000
            heroe.posx = heroe.posx - 1
            moverEnemigo
            dibujarEscenarioGrafico
        END IF
    END IF
END IF

REM right
IF tecla$ = CHR$(0) + CHR$(77) THEN
    IF heroe.posx < 31 THEN
        IF escenario(heroe.posx + 1, heroe.posy)=0 THEN
            escenario(heroe.posx,heroe.posy)=0
            escenario(heroe.posx+1,heroe.posy)=1000
            heroe.posx = heroe.posx + 1
            moverEnemigo
            dibujarEscenarioGrafico
        END IF
    END IF
END IF

IF tecla$ = CHR$(27) THEN
    retorno = 1
END IF
recibirTecla = retorno
END FUNCTION

SUB moverEnemigo()
    FOR a = 1 TO 10
        IF RTRIM$(enemigos(a).nombre)<>"Nulo" THEN
            movimiento = dado(5)
            SELECT CASE movimiento
                CASE 1 'ARRIBA
                    IF enemigos(a).posy > 1 THEN
                        IF escenario(enemigos(a).posx, enemigos(a).posy - 1)= 0 THEN
                            escenario(enemigos(a).posx,enemigos(a).posy)=0
                            escenario(enemigos(a).posx,enemigos(a).posy-1)=a    
                            enemigos(a).posy = enemigos(a).posy - 1
                        END IF
                    END IF      
                CASE 2 'ABAJO
                    IF enemigos(a).posy < 23 THEN
                        IF escenario(enemigos(a).posx, enemigos(a).posy + 1) = 0 THEN
                            escenario(enemigos(a).posx,enemigos(a).posy)=0
                            escenario(enemigos(a).posx,enemigos(a).posy+1)=a
                            enemigos(a).posy = enemigos(a).posy + 1
                        END IF
                    END IF
                CASE 3 'DERECHA
                    IF enemigos(a).posx < 31 THEN
                        IF escenario(enemigos(a).posx + 1, enemigos(a).posy)=0 THEN
                            escenario(enemigos(a).posx,enemigos(a).posy)=0
                            escenario(enemigos(a).posx+1,enemigos(a).posy)=a
                            enemigos(a).posx = enemigos(a).posx + 1
                        END IF
                    END IF
                CASE 4 'IZQUIERDA
                    IF enemigos(a).posx > 1 THEN
                        IF escenario(enemigos(a).posx - 1, enemigos(a).posy)=0 THEN
                            escenario(enemigos(a).posx,enemigos(a).posy)=0
                            escenario(enemigos(a).posx-1,enemigos(a).posy)=a
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
LOCATE 18,40
PRINT "Version 0.0.5B"
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
                dibujarCosas x,y, RTRIM$(enemigos(escenario(x,y)).nombre)
            CASE 101 TO 110
                dibujarCosas x, y, RTRIM$(elementos(escenario(x,y)-100).nombre)
        END SELECT
    NEXT
NEXT
LOCATE 1, 1
PRINT nombre$ + "(" + STR$(heroe.posx) + "," + STR$(heroe.posy) + ")"
LOCATE 1, 20
PRINT heroe.clase + " " + heroe.raza
LOCATE 1, 40
PRINT "F: " + STR$(personaje.fuerza) + " D: " + STR$(personaje.destreza) + " C: " + STR$(personaje.constitucion) + " S: " + STR$(personaje.sabiduria) + " I: " + STR$(personaje.inteligencia) + " CM: " + STR$(personaje.carisma)
LINE (0, 15)-(640, 15)
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
    CASE "Mesa"
        RESTORE Mesa
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