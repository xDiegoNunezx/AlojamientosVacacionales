/*
Proyecto 2. Alojamientos Vacacionales
Equipo:
- Aldo Yael NAVARRETE ZAMORA
- Daniel Eduardo JARQUIN LÓPEZ
- Diego Ignacio NÚÑEZ HERNÁNDEZ
- Uriel Quetzal TAVERA MARRTÍNEZ
*/

-- CREACION DE TABLAS
-- Tabla Personal Diego
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
    clvAlo CHAR(4) NOT NULL,

    CONSTRAINT personal_pk PRIMARY KEY (clavePersonal),
    CONSTRAINT personal_fk FOREIGN KEY (clvAlo) 
    REFERENCES alojamiento (clvAlo) ON DELETE CASCADE
);

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
    CONSTRAINT PK_Huesped PRIMARY KEY (claveHuesped),
)
--Tabla Alojamiento

--Tabla Habitación


--Tabla Reserva Aldo
CREATE TABLE Reserva(
    noHab CHAR(4),
    clvAlo CHAR(4),
    claveHuesped CHAR(4),
    inicioReserva DATE,
    finReserva DATE,
    CONSTRAINT PK_Reserva PRIMARY KEY (noHab, clvAlo, claveHuesped),
    CONSTRAINT FK_Reserva_Alojamiento FOREIGN KEY (clvAlo) REFERENCES alojamiento,
    CONSTRAINT FK_Reserva_Huesped FOREIGN KEY (claveHuesped) REFERENCES Huesped ON DELETE SET NULL,
    CONSTRAINT FK_Reserva_Habitacion FOREIGN KEY (noHab) REFERENCES Habitacion
)
