/*
Proyecto 2. Alojamientos Vacacionales
Equipo:
- Aldo Yael NAVARRETE ZAMORA
- Daniel Eduardo JARQUIN LÓPEZ
- Diego Ignacio NÚÑEZ HERNÁNDEZ
- Uriel Quetzal TAVERA MARTÍNEZ
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
	ORDER BY clvAlo;

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

exec spVacaciones;

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

CREATE OR REPLACE PROCEDURE spMostrarReservaciones(
vFecha IN DATE)
IS
	CURSOR mostrar 
	IS 
		SELECT * FROM reporteReservaciones
		WHERE inicioReservaReporte = vFecha;
	vAuxiliar reporteReservaciones%ROWTYPE;
BEGIN
	OPEN mostrar;
	FETCH mostrar INTO vAuxiliar;
	WHILE mostrar%FOUND LOOP
		DBMS_OUTPUT.PUT_LINE(vAuxiliar.noHabReporte||'      '||vAuxiliar.clvAloReporte||'      '||
		vAuxiliar.claveHuespedReporte||'      '||vAuxiliar.nomHuesReporte||'      '||
		vAuxiliar.nomAloReporte||'      '||vAuxiliar.inicioReservaReporte);
		FETCH mostrar INTO vAuxiliar;
	END LOOP;
	CLOSE mostrar;
END spMostrarReservaciones;
/

/*
    En el momento en que una reservación es cancelada el estatus de la 
    habitación debe de regresar a su estado original.
*/
CREATE OR REPLACE VIEW vwReserva
AS
SELECT noHab, clvAlo, claveHuesped, nomHues, inicioReserva, finReserva FROM RESERVA
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

EXEC spAltaPersonal('Vicente','Sierra','Cruz','Av.Chapultepec',85453,'Mexico','13/04/2010','SICV840520QN4');
EXEC spAltaPersonal('Daniel','Jarquin','Lopez','2 de Marzo',56334,'Mexico','23/12/2005','JALD011030SG3');
EXEC spAltaPersonal('Aldo','Navarrete','Zamora','Genaro Nuñez 18',07120,'Mexico','7/06/2022','NAZA200301HD');
EXEC spAltaPersonal('Diego','Nuñez','Hernandez','Juarez 19',21312,'Mexico','9/07/2015','NHDI123124HS');
EXEC spAltaPersonal('Quetzal','Tavera','Martinez','Degollado 215',41236,'Mexico','12/12/2010','TAMQ010605H82');
EXEC spAltaPersonal('Ana','Fragoso','Islas','Constitucion 17',54879,'Mexico','17/06/1986','FAIA001218EM4');
EXEC spAltaPersonal('Edyth','Dunsford',NULL,'1416 Hamilton Street',12312,'Canada','18/09/2003','DUE001218Q710');
EXEC spAltaPersonal('Merle','Sauriol',NULL,'42 Place du Jeu de Paume',54321,'Francia','02/02/2001','SQME13412HDS');
EXEC spAltaPersonal('Freddie','Law',NULL,'213 Harvest Lane',12341,'Estados Unidos','01/01/1999','LFW23GF234ASD');

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
--Diego, Sur
EXEC spAsignaPersonalAlo('13','1'); 
--Quetzal, Oriente
EXEC spAsignaPersonalAlo('14','3'); 
--Dani, Norte
EXEC spAsignaPersonalAlo('11','2'); 

/*  
    PROCEDIMIENTO para Dar de Alta a Huesped
*/

CREATE SEQUENCE ID_HUES_SEQ
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE spAltaHuesped(
    nomHues IN VARCHAR,
    apPatHues IN VARCHAR,
    apMatHues IN VARCHAR,
    calleHues IN VARCHAR,
    CPHues IN NUMBER,
    paisHues IN VARCHAR,
    telHues IN NUMBER
)
AS
BEGIN
    INSERT INTO Huesped(claveHuesped,nomHues,apPatHuesped,apMatHuesped,calleHues,CPHues,paisHues,telHues) VALUES (ID_HUES_SEQ.NEXTVAL,nomHues,apPatHues,apMatHues,calleHues,CPHues,paisHues,telHues);
END spAltaHuesped;
/

EXEC spAltaHuesped('Hugo','Revilla','Gomez','Villaurrutia',54112,'Mexico',5575865145);
EXEC spAltaHuesped('Juana','Breacher','Hansen','68 Hagan Point',84959,'Brazil',2479321805);
EXEC spAltaHuesped('Riannon','Morrish','Murcott','872 West Trail',60348,'Argentina',9865918104);
EXEC spAltaHuesped('Ellswerth','Dacca','Fudger','3 Petterle Point',78518,'Venezuela',2318026033);
EXEC spAltaHuesped('Lilia','Dani','Sorrell','48 Starling Trail',38955,'Paraguay',3442187386);
EXEC spAltaHuesped('Ursala','Ortes','Dacca','42 Harbort Way',46693,'United States',6012190104);

/*  
    PROCEDIMIENTO para Crear un nuevo TIPO de Habitacion
*/

CREATE OR REPLACE PROCEDURE spAltaTipoHabitacion(
    tipoHab IN VARCHAR,
    precioHab IN NUMBER
)
AS
BEGIN 
    INSERT INTO tipoHabitacion VALUES (tipoHab,precioHab);
END spAltaTipoHabitacion;
/

EXEC spAltaTipoHabitacion('INDIVIDUAL',2400);
EXEC spAltaTipoHabitacion('DOBLE',4800);
EXEC spAltaTipoHabitacion('TRIPLE',7200);

/*  
    PROCEDIMIENTO dar de Alta Habitación
*/

CREATE OR REPLACE PROCEDURE spAltaHabitacion(
    noHab IN CHAR,
    clvAlo IN CHAR,
    tipoHab IN VARCHAR,
    estatusHab IN VARCHAR
)
AS 
BEGIN 
    INSERT INTO habitacion VALUES (noHab,clvAlo,tipoHab,estatusHab);
END;
/

-- Habitaciones Alojamiento Norte 
EXEC spALtaHabitacion('1','2','INDIVIDUAL','DISPONIBLE');
EXEC spALtaHabitacion('2','2','DOBLE','DISPONIBLE');
EXEC spALtaHabitacion('3','2','TRIPLE','DISPONIBLE');

-- Habitaciones Alojamiento Sur
EXEC spALtaHabitacion('1','1','INDIVIDUAL','DISPONIBLE');
EXEC spALtaHabitacion('2','1','DOBLE','DISPONIBLE');
EXEC spALtaHabitacion('3','1','TRIPLE','DISPONIBLE');

-- Habitaciones Alojamiento Oriente 
EXEC spALtaHabitacion('1','3','INDIVIDUAL','DISPONIBLE');
EXEC spALtaHabitacion('2','3','DOBLE','DISPONIBLE');
EXEC spALtaHabitacion('3','3','TRIPLE','DISPONIBLE');

/*  
    PROCEDIMIENTO para Crear una actividad
*/

CREATE SEQUENCE ID_ACT_SEQ
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE spAltaActividad(
    vNomAct IN VARCHAR,
    vdescAct IN VARCHAR,
    vnivelAct IN VARCHAR
)
AS
BEGIN
    INSERT INTO Actividad(clvAct,nomAct,descAct,nivelAct) VALUES(ID_ACT_SEQ.NEXTVAL,vnomAct,vdescAct,vnivelAct);
END;
/

EXEC spAltaActividad('Senderismo','Se realizará una caminata por el area natural mas cercana al alojamiento. Duracion promedio de 3 horas.','MEDIO');
EXEC spAltaActividad('Bicicleta de montania','Los ciclistas podran usar las bicicletas de uso rudo del alojamiento, y realizar recorridos por rutas complejas y empinadas.','ALTO');
EXEC spAltaActividad('Cabalgata','Los participantes montaran un caballo del establo con ayuda del personal del alojamiento, y daran un paseo por los alrededores.','BAJO');
EXEC spAltaActividad('Viaje en tranvia','Recorrido de los alrrededores de la ciudad, a bordo de un tranvia tematico.','BAJO');
EXEC spAltaActividad('Lanzamiento de tirolesa','El participante se lanzara desde la tirolesa, y se desplazara a alta velocidad mientras posee una vista completa de la ciudad','ALTO');

/*  
    PROCEDIMIENTO dar de Alta una Actividad en un Alojamiento
*/

CREATE OR REPLACE PROCEDURE spAltaAlojaAct(
    vClvAlo IN CHAR,
    vClvAct IN VARCHAR,
    vFechaActividad IN VARCHAR,
    vHorario IN VARCHAR
)
AS
BEGIN
    INSERT INTO alojaAct 
    VALUES(vClvAlo,vClvAct,vFechaActividad,vHorario);
END;
/

EXEC spAltaAlojaAct(1,3,'Martes','11am-6pm');
EXEC spAltaAlojaAct(1,1,'Jueves','8am-2pm');
EXEC spAltaAlojaAct(2,2,'Miercoles','1pm-7pm');
EXEC spAltaAlojaAct(2,5,'Jueves','10am-6pm');
EXEC spAltaAlojaAct(3,4,'Viernes','6pm-9pm');
EXEC spAltaAlojaAct(3,3,'Miercoles','6pm-9pm');

/*
    PROCEDIMIENTO para Hacer una Reserva 
*/
SET SERVEROUTPUT ON;

/* 
    DISPARADOR de Sustitución cuando se hace una reserva se cambia el status
    en la habitación y la agrega a la tabla reserva
*/
CREATE OR REPLACE TRIGGER tgReservacionCreada
INSTEAD OF INSERT ON vwReserva --Opera en la vista
FOR EACH ROW
DECLARE 
    vNomHuesped VARCHAR2(30);
    vNomAlo VARCHAR(30);
BEGIN
    SELECT NOMHUES
    INTO vNomHuesped 
    FROM HUESPED
    WHERE claveHuesped = :NEW.claveHuesped;

    SELECT nomAlo
    INTO vNomAlo
    FROM  Alojamiento
    WHERE clvAlo = :NEW.clvAlo; 

    INSERT INTO RESERVA VALUES (:NEW.noHab,:NEW.clvAlo,:NEW.claveHuesped,:NEW.inicioReserva,:NEW.finReserva);
    INSERT INTO reporteReservaciones VALUES (:NEW.noHab, :NEW.clvAlo, :NEW.claveHuesped, vNomHuesped, vnomAlo, :NEW.inicioReserva);

    --Actualiza el estado habitacion
    UPDATE HABITACION SET estatusHab = 'OCUPADO'
	WHERE noHab = :NEW.noHab
    AND clvAlo = :NEW.clvAlo;

END tgReservacionCreada;
/

CREATE OR REPLACE PROCEDURE spCreaReserva(
    vnoHab in CHAR,
    vclvAlo in CHAR,
    vclaveHuesped in CHAR,
    vinicioReserva in DATE,
    vfinReserva in DATE
)
AS
    vNomHuesped VARCHAR2(30);
    vNomAlo VARCHAR2(30);
    vEstatusHab2 VARCHAR2(15);
BEGIN
    SELECT estatusHab
    INTO vEstatusHab2
    FROM habitacion
    WHERE noHab = vnoHab
    AND clvAlo = vClvAlo;

    IF vEstatusHab2 = 'DISPONIBLE' THEN
        SELECT NOMHUES
        INTO vNomHuesped
        FROM HUESPED
        WHERE claveHuesped = vclaveHuesped;

        SELECT nomAlo
        INTO vNomAlo
        FROM  Alojamiento
        WHERE clvAlo = vclvAlo; 
        
        INSERT INTO vwReserva VALUES (vnoHab,vclvAlo,vclaveHuesped,vNomHuesped,vinicioReserva,vfinReserva);
        DBMS_OUTPUT.PUT_LINE(vNomHuesped || ' ha reservado exitosamente de '||vinicioReserva||' - '||vfinReserva|| ' en el alojamiento '|| vNomAlo);
    ELSE
        DBMS_OUTPUT.PUT_LINE('La habitacion seleccionada ya esta ocupada o no existe');
    END IF;
END spCreaReserva;
/

exec spCreaReserva('1','2','1',SYSDATE,SYSDATE+7);

/*
    PROCEDIMIENTO para Cancelar una Reserva 
*/

CREATE OR REPLACE PROCEDURE spCancelaReserva( 
    vNoHab IN CHAR,
    vClvAlo IN CHAR,
    vClaveHuesped IN CHAR
)
AS
BEGIN
    DELETE FROM vwReserva
    WHERE noHab = vNoHab
    AND clvAlo = vClvAlo
    AND ClaveHuesped = vClaveHuesped; 
END;
/

exec spCancelaReserva('1','2','1');

--- ************** TRIGGERS *****************

/* Comando para checar los triggers creados por el usuario */
SELECT
    trigger_name 
FROM 
    user_triggers
ORDER BY
    trigger_name ASC;
