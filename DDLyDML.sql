/*
Proyecto: Alojamientos Vacacionales
Equipo:
- Aldo Yael NAVARRETE ZAMORA
- Daniel Eduardo JARQUIN LÓPEZ
- Diego Ignacio NÚÑEZ HERNÁNDEZ
- Uriel Quetzal TAVERA MARRTÍNEZ
*/

-- CREACION DE TABLAS

-- Tabla Personal
CREATE TABLE personal(
    clavePersonal CHAR(4),
    nomPer VARCHAR2(30) NOT NULL,
    apPatPer VARCHAR2(30) NOT NULL,
    apMatPer VARCHAR2(30),
    callePer VARCHAR2(30) NOT NULL,
    CPPer NUMBER(5) NOT NULL,
    paisPer VARCHAR2(20) NOT NULL,
    fechaIngreso DATE DEFAULT SYSDATE,
    RFCPer CHAR(13) NOT NULL,
    clvAlo CHAR(4),
    CONSTRAINT personal_pk PRIMARY KEY (clavePersonal)
);

--Tabla Alojamiento

CREATE TABLE Alojamiento(
    clvAlo CHAR(4),
    nomAlo VARCHAR(30) NOT NULL,
    calleAlo VARCHAR(30) NOT NULL,
    CPAlo NUMBER(5) NOT NULL,
    paisAlo VARCHAR(20) NOT NULL,
    cantidadHab NUMBER(2) NOT NULL,
    telAlo NUMBER(10) NOT NULL,
    clavePersonal CHAR(4),
    CONSTRAINT PK_Alojamiento PRIMARY KEY (clvAlo),
    CONSTRAINT FK_Alojamiento_Personal FOREIGN KEY (clavePersonal) REFERENCES personal ON DELETE SET NULL
);

-- Modificacion para aniadir FK de alojamiento en personal

ALTER TABLE personal
ADD CONSTRAINT personal_fk 
FOREIGN KEY (clvAlo) 
REFERENCES alojamiento;

--Tabla Huesped Aldo
CREATE TABLE Huesped(
    claveHuesped CHAR(4),
    nomHues VARCHAR2(30) NOT NULL,
    apPatHuesped VARCHAR2(30) NOT NULL,
    apMatHuesped VARCHAR2(30),
    calleHues VARCHAR2(30) NOT NULL,
    CPHues NUMBER(5) NOT NULL,
    paisHues VARCHAR2(20) NOT NULL,
    telHues NUMBER(10) NOT NULL,
    CONSTRAINT PK_Huesped PRIMARY KEY (claveHuesped)
);

-- Tabla tipoHabitacion

CREATE TABLE tipoHabitacion (
    tipoHab VARCHAR(15),
    precioHab NUMBER(8,2) NOT NULL,
    CONSTRAINT PK_tipoHabitacion PRIMARY KEY (tipoHab),
    CONSTRAINT CK_tipoHab CHECK (tipoHab IN ('INDIVIDUAL','DOBLE','TRIPLE'))
);

--Tabla Habitación

CREATE TABLE Habitacion(
    noHab CHAR(4) NOT NULL,
    clvAlo CHAR(4) NOT NULL,
    tipoHab VARCHAR(15) NOT NULL,
    estatusHab VARCHAR(15) NOT NULL,
    CONSTRAINT PK_Habitacion PRIMARY KEY (noHab,clvAlo),
    CONSTRAINT FK_Habitacion_TipoHabitacion FOREIGN KEY (tipoHab) REFERENCES tipoHabitacion,
    CONSTRAINT FK_Habitacion_Alojamiento FOREIGN KEY (clvAlo) REFERENCES alojamiento ON DELETE CASCADE,
    CONSTRAINT CK_Habitacion_EstatusHab CHECK (estatusHab IN ('DISPONIBLE','OCUPADO'))
);

-- Tabla Actividad

CREATE TABLE Actividad(
    clvAct CHAR(4) NOT NULL,
    nomAct VARCHAR(30) NOT NULL,
    descAct VARCHAR(150) NOT NULL,
    nivelAct VARCHAR(10) NOT NULL,
    CONSTRAINT PK_Actividad PRIMARY KEY (clvAct),
    CONSTRAINT CK_NivelAct CHECK (nivelAct IN ('ALTO','MEDIO','BAJO'))
);

-- Tabla ALOJAACT
CREATE TABLE AlojaAct(
	clvAlo CHAR(4),
	clvAct CHAR(4), 
	fechaActividad VARCHAR(20) NOT NULL,
	horario VARCHAR(10) NOT NULL,
	CONSTRAINT pkAlojaAct PRIMARY KEY(clvAlo,clvAct),
	CONSTRAINT fkAlojaActAlojamiento FOREIGN KEY(clvAlo)
	REFERENCES alojamiento(clvAlo) ON DELETE CASCADE,
	CONSTRAINT fkAlojaActActividad FOREIGN KEY(clvAct)
	REFERENCES actividad(clvAct) ON DELETE SET NULL,
	CONSTRAINT ckAlojaAct CHECK(fechaActividad IN ('MARTES',
	'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO'))
);

-- Tabla Reserva
CREATE TABLE Reserva(
    noHab CHAR(4),
    clvAlo CHAR(4),
    claveHuesped CHAR(4),
    inicioReserva DATE,
    finReserva DATE,
    CONSTRAINT PK_Reserva PRIMARY KEY (noHab, clvAlo, claveHuesped),
    CONSTRAINT FK_Reserva_Huesped FOREIGN KEY (claveHuesped) REFERENCES Huesped ON DELETE SET NULL,
    CONSTRAINT FK_Reserva_Habitacion FOREIGN KEY (noHab,clvAlo) REFERENCES Habitacion
);
