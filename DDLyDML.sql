/*
Proyecto 2. Alojamientos Vacacionales
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
    clvAlo CHAR(4) NOT NULL,

    CONSTRAINT personal_pk PRIMARY KEY (clavePersonal),
    CONSTRAINT personal_fk FOREIGN KEY (clvAlo) 
    REFERENCES alojamiento (clvAlo) ON DELETE CASCADE
);