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

CREATE OR REPLACE VIEW vwActividadAlojamiento
AS
	SELECT clvAlo, nomAlo, nomAct, fechaActividad
	FROM alojamiento
	NATURAL JOIN alojaAct
	NATURAL JOIN actividad
	ORDER BY clvAlo
;


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

CREATE TABLE reporteReservaciones(
	noHabReporte CHAR(4) NOT NULL,
	clvAloReporte CHAR(4) NOT NULL,
	claveHuespedReporte CHAR(4) NOT NULL,
	nomHuesReporte VARCHAR2(30) NOT NULL,
	nomAloReporte VARCHAR(30) NOT NULL,
	inicioReservaReporte DATE
);

CREATE OR REPLACE TRIGGER tgRegistraReserva
AFTER
	INSERT 
	ON reserva
	FOR EACH ROW
DECLARE
	vnomHues VARCHAR2(30);
	vnomAlo VARCHAR(30);
BEGIN
	SELECT nomHues, nomAlo
	INTO vnomHues, vnomAlo
	FROM reserva
	NATURAL JOIN huesped
	NATURAL JOIN alojamiento;

	INSERT INTO reporteReservaciones
	VALUES (:NEW.noHab, :NEW.clvAlo, :NEW.claveHuesped, vnomHues, 
	vnomAlo, :NEW.inicioReserva);
END tgRegistraReserva;
/

/*
    En el momento en que una reservación es cancelada el estatus de la 
    habitación debe de regresar a su estado original.
*/
CREATE OR REPLACE VIEW vwReserva
AS
SELECT noHab, clvAlo, nomHues, inicioReserva, finReserva, estatusHab FROM RESERVA
NATURAL JOIN Huesped
NATURAL JOIN HABITACION;


CREATE OR REPLACE TRIGGER tgReservacionCancelada
INSTEAD OF DELETE ON vwReserva --Opera en la vista
FOR EACH ROW
BEGIN
	UPDATE HABITACION SET estatusHab = 'DISPONIBLE'
	WHERE noHab = :OLD.noHab
    AND clvAlo = :OLD.clvAlo;
END tgReservacionCancelada;
/

-- ************** PROCEDIMIENTOS ***************



/*  
    PROCEDIMIENTO para crear alojamientos
*/

CREATE SEQUENCE ID_ALO_SEQ
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE spAltaAlojamiento(
   nomAlo IN VARCHAR,
   calleAlo IN VARCHAR,
   CPAlo IN NUMBER,
   paisAlo IN VARCHAR,
   cantidadHab IN NUMBER,
   telAlo IN NUMBER
)
AS
BEGIN
   INSERT INTO Alojamiento(clvAlo,nomAlo,calleAlo,CPAlo,paisAlo,cantidadHab,telAlo) VALUES (ID_ALO_SEQ.NEXTVAL,nomAlo,calleAlo,CPAlo,paisAlo,cantidadHab,telAlo);
END spAltaAlojamiento;
/

EXEC spAltaAlojamiento('INN SUR','Calzada del Hueso',85453,'Mexico',50,5513451239);
EXEC spAltaAlojamiento('INN NORTE','Av. Acueducto',11452,'Mexico',40,5582561158);
EXEC spAltaAlojamiento('INN ORIENTE','Mario de la Cueva',22356,'Mexico',70,5574951724);


/* 
    PROCEDIMIENTO para dar de alta un personal
*/

CREATE SEQUENCE ID_PER_SEQ
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE spAltaPersonal(
   nomPer IN VARCHAR,
   apPatPer IN VARCHAR,
   apMatPer IN VARCHAR,
   callePer IN VARCHAR,
   CPPer IN NUMBER,
   paisPer IN VARCHAR,
   fechaIngreso IN DATE,
   RFCPer IN CHAR
)
AS
BEGIN
   INSERT INTO Personal(clavePersonal,nomPer,apPatPer,apMatPer,callePer,CPPer,paisPer,fechaIngreso,RFCPer) VALUES (ID_PER_SEQ.NEXTVAL,nomPer,apPatPer,apMatPer,callePer,CPPer,paisPer,fechaIngreso,RFCPer);
END spAltaPersonal;
/

EXEC spAltaPersonal('Vicente','Sierra','Cruz','Av.Chapultepec',85453,'Mexico',SYSDATE-6,'SICV840520QN4');
EXEC spAltaPersonal('Daniel','Jarquin','Lopez','2 de Marzo',56334,'Mexico',SYSDATE-12,'JALD011030SG3');
EXEC spAltaPersonal('Aldo','Navarrete','Zamora','Genaro Nuñez 18',07120,'Mexico',SYSDATE-8,'NAZA200301HD');
EXEC spAltaPersonal('Diego','Nuñez','Hernandez','Juarez 19',21312,'Mexico',SYSDATE-9,'NHDI123124HS');
EXEC spAltaPersonal('Quetzal','Tavera','Martinez','Degollado 215',41236,'Mexico',SYSDATE-4,'TAMQ010605H82');
EXEC spAltaPersonal('Ana','Fragoso','Islas','Constitucion 17',54879,'Mexico',SYSDATE-34,'FAIA001218EM4');
EXEC spAltaPersonal('Edyth','Dunsford',NULL,'1416 Hamilton Street',12312,'Canada',SYSDATE-3,'DUE001218Q710');
EXEC spAltaPersonal('Merle','Sauriol',NULL,'42 Place du Jeu de Paume',54321,'Francia',SYSDATE-4,'SQME13412HDS');
EXEC spAltaPersonal('Freddie','Law',NULL,'213 Harvest Lane',12341,'Estados Unidos',SYSDATE-1,'LFW23GF234ASD');

/* 
    PROCEDIMIENTO Para Asignar un Personal a Alojamiento 
*/

CREATE OR REPLACE PROCEDURE spAsignaPersonalAlo(
    vclvPersonal IN CHAR,
    vclvAlo IN CHAR
)
AS
BEGIN
    UPDATE Alojamiento
    SET clavePersonal = vclvPersonal
    WHERE clvAlo = vclvAlo;
    
    UPDATE Personal
    SET clvAlo = vclvAlo
    WHERE clavePersonal = vclvPersonal;
END;
/


EXEC spAsignaPersonalAlo('9','6'); --Diego, Sur
EXEC spAsignaPersonalAlo('10','8');--Quetzal, Oriente
EXEC spAsignaPersonalAlo('7','7'); --Dani, Norte

CREATE OR REPLACE PROCEDURE spAltaHuesped(
   nomHues IN VARCHAR,
   apPatHues IN VARCHAR,
   apMatHues IN VARCHAR,
   calleHues IN VARCHAR,
   CPHues IN NUMBER,
   paisHues IN VARCHAR,
   fechaIngreso IN DATE,
   RFCPer IN CHAR
)
AS
BEGIN
   INSERT INTO Personal(clavePersonal,nomPer,apPatPer,apMatPer,callePer,CPPer,paisPer,fechaIngreso,RFCPer) VALUES (ID_PER_SEQ.NEXTVAL,nomPer,apPatPer,apMatPer,callePer,CPPer,paisPer,fechaIngreso,RFCPer);
END spAltaPersonal;
/