/*
Proyecto 2. Alojamientos Vacacionales
Equipo:
- Aldo Yael NAVARRETE ZAMORA
- Daniel Eduardo JARQUIN LÓPEZ
- Diego Ignacio NÚÑEZ HERNÁNDEZ
- Uriel Quetzal TAVERA MARRTÍNEZ
*/

/*
    Mostrar los alojamientos que se tienen, ubicación, actividades 
    que se realizan, el nivel de dificultad de éstas y el precio.
*/

CREATE OR REPLACE VIEW vwAlojamientos
AS
    SELECT nomAlo AS Alojamiento, calleAlo, CPAlo, paisAlo, nomAct, nivelAct
    FROM AlojaAct
    NATURAL JOIN (alojamiento)
    NATURAL JOIN (actividad);

/*
    Modificar el precio de las habitaciones del alojamiento dependiendo 
    del tipo de habitación y un porcentaje proporcionado.
*/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE spCambioPrecioHab(
    vPorcentaje IN NUMBER
)
IS
    CURSOR cursorHabs
    IS
        SELECT *
        FROM tipoHabitacion;
BEGIN
    FOR HabActual IN cursorHabs LOOP

        IF HabActual.tipoHab IN ('INDIVIDUAL','DOBLE','TRIPLE') THEN 
            HabActual.precioHab:= HabActual.precioHab*(1+(vPorcentaje/100));

            UPDATE tipoHabitacion
            SET precioHab = HabActual.precioHab
            WHERE tipoHab = HabActual.tipoHab;
            
            DBMS_OUTPUT.PUT_LINE('Precio de la habitacion '||HabActual.tipoHab||' aumentado un '||vPorcentaje||' %');
        ELSE
            DBMS_OUTPUT.PUT_LINE('No se cambio el precio de la habitacion tipo '||HabActual.tipoHab);
        END IF;
    END LOOP;

END spCambioPrecioHab;
/

/*
    Mostrar por cada alojamiento las actividades que se realizan y en 
    qué día de la semana.
*/


/*
    Calcular las vacaciones del personal para un año determinado 
    y almacenarlo en una tabla llamada VACACIONES, la cual tendrá 
    únicamente la clave del empleado y los días de vacaciones que 
    le corresponden. Las vacaciones serán calculadas con base en 
    el año en el que ingresaron los empleados, se les darán 8 días 
    al inicio y 2 días adicionales por año laborado.
*/

CREATE TABLE VACACIONES (
    clavePersonal CHAR(4),
    vacaciones NUMBER(10)
);

CREATE OR REPLACE FUNCTION diasVacacionales(
    vclvPersonal IN CHAR)
RETURN NUMBER
IS 
    vFechaIngreso DATE;
    vAntiguedad NUMBER(10);
    vVacaciones NUMBER(10);
BEGIN
	SELECT FECHAINGRESO
	INTO vFechaIngreso
	FROM PERSONAL
	WHERE clavePersonal=vclvPersonal;
	vAntiguedad := SYSDATE  - vFechaIngreso;
	vVacaciones := 8 + TRUNC((vAntiguedad/365))*2;
	RETURN vVacaciones;
END diasVacacionales;
/

CREATE OR REPLACE PROCEDURE spVacaciones
AS
	CURSOR regPer 
	IS
	SELECT * 
	FROM personal;
BEGIN
	FOR rPer IN regPer LOOP
	INSERT INTO vacaciones VALUES (rPer.clavePersonal,diasVacacionales(rPer.clavePersonal));
END LOOP;
END spVacaciones;
/


/*
    Guardar en una tabla llamada reporteReservaciones, las reservaciones 
    realizadas en una fecha proporcionada, mostrando los nombres de los 
    huéspedes y los alojamientos.
*/

/*
    En el momento en que una reservación es cancelada el estatus de la 
    habitación debe de regresar a su estado original.
*/
CREATE OR REPLACE VIEW vwReserva
AS
SELECT noHab, nomHues, inicioReserva, finReserva, estatusHab FROM RESERVA
JOIN HUESPED using (claveHuesped)
JOIN Habitacion using (noHab)


CREATE OR REPLACE TRIGGER tgReservacionCancelada
INSTEAD OF DELETE ON vwReserva --Opera en la vista
FOR EACH ROW
BEGIN
	UPDATE RESERVA SET status = 'DISPONIBLE'
	WHERE noHab = :OLD.numFact
    AND clvAlo = :OLD.clvAlo;
END tgReservacionCancelada;
/