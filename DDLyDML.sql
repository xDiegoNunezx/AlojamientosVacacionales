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

insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('x998', 'Loren', 'Pidcock', '8564 Fremont Alley', 77163, 'China', '4202764245');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('o352', 'Teddy', 'Sandham', '2 Melvin Circle', 34773, 'Russia', '2181887567');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('p737', 'Tybalt', 'MacFaul', '592 Sycamore Street', 17037, 'Russia', '3952420000');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('a626', 'Erinna', 'Forsard', '04 Grim Avenue', 30023, 'Argentina', '7455893160');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('l101', 'Dode', 'De la croix', '50 Lakewood Road', 5572, 'Philippines', '3604402634');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('l564', 'Ellswerth', 'Dacca', '3 Petterle Point', 78518, 'Venezuela', '2318026033');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('e070', 'Wylie', 'Roughsedge', '19 Gulseth Plaza', 71664, 'Russia', '1114497999');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('q751', 'Elfrieda', 'Gerhardt', '125 Charing Cross Parkway', 24733, 'China', '6725196946');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('x055', 'Ollie', 'Reye', '0195 Clyde Gallagher Lane', 11505, 'Greece', '4918076501');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('f364', 'Herb', 'Sager', '134 Alpine Road', 15818, 'Philippines', '1115803403');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('p240', 'Grannie', 'Poytheras', '5 Helena Court', 12854, 'China', '9838164287');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('t446', 'Juana', 'Breacher', '68 Hagan Point', 84959, 'Brazil', '2479321805');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('w751', 'Nerta', 'Baldelli', '512 Prentice Avenue', 35667, 'China', '9463385275');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('x863', 'Nyssa', 'Luby', '5543 Petterle Court', 70188, 'Mauritius', '9045256011');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('o031', 'Dominique', 'Britten', '49 Fuller Parkway', 33783, 'Vietnam', '9104817030');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('y274', 'Rosa', 'Hryniewicz', '5347 Marcy Way', 64541, 'Thailand', '4941087554');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('o160', 'Lonna', 'Mulder', '1513 Old Shore Junction', 60717, 'North Korea', '4942858653');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('k681', 'Juliann', 'Sorrell', '1 Maple Wood Circle', 96047, 'Brazil', '9714154048');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('u520', 'Lyndsie', 'Melluish', '00191 Bluejay Place', 36654, 'Sweden', '8952880228');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('v478', 'Husain', 'Vandenhoff', '2093 Rutledge Drive', 18036, 'China', '6694413973');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('c714', 'Joana', 'Thorneywork', '53171 Oak Parkway', 14262, 'Brazil', '5897961221');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('k271', 'Dedie', 'Loude', '21 Hallows Alley', 50846, 'Belarus', '2717567777');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('i180', 'Harriette', 'Kebbell', '5 Eastwood Lane', 31307, 'Mexico', '6822500526');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('l552', 'Giuseppe', 'McIlwaine', '262 Ramsey Circle', 15332, 'China', '7797459803');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('u069', 'Izaak', 'Clitsome', '52852 Crescent Oaks Court', 66948, 'China', '6724004280');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('o842', 'Burty', 'Fudger', '49848 Arrowood Way', 53670, 'Czech Republic', '3754807659');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('r021', 'Fina', 'Handover', '28050 Holmberg Circle', 55364, 'Equatorial Guinea', '3441515623');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('e545', 'Lilia', 'Dani', '48 Starling Trail', 38955, 'Paraguay', '3442187386');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('k760', 'Rochette', 'MacCourt', '1 Michigan Street', 11306, 'China', '8502259171');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('t414', 'Anna', 'Bayldon', '74 Petterle Hill', 95004, 'Nigeria', '8787167042');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('g408', 'Floria', 'Parres', '4 High Crossing Road', 68390, 'Indonesia', '6691458428');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('n807', 'Pyotr', 'Dobbings', '184 Summerview Place', 45254, 'China', '6607700657');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('k546', 'Ashli', 'Cursey', '38864 Hollow Ridge Circle', 23462, 'Philippines', '4624357857');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('j730', 'Saxe', 'Cowdrey', '74829 Sheridan Park', 68316, 'Vietnam', '3491744551');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('q063', 'Flossi', 'Murcott', '71521 Talmadge Plaza', 10993, 'Poland', '8831168124');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('k567', 'Ella', 'Dumbreck', '9066 Hoffman Terrace', 67794, 'France', '8747648473');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('w443', 'Hillary', 'Tease', '426 Elka Plaza', 81544, 'China', '9086605163');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('u695', 'Brodie', 'Strasse', '99 Mallory Place', 1280, 'China', '1485252912');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('d319', 'Barr', 'Chattoe', '06 Esch Plaza', 60887, 'China', '8047237304');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('u816', 'Riannon', 'Morrish', '872 West Trail', 60348, 'Argentina', '9865918104');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('z879', 'Arlin', 'Chubb', '722 Monterey Parkway', 97862, 'Venezuela', '1378993018');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('g558', 'Suzi', 'Hansen', '82 Farragut Point', 98486, 'Indonesia', '6864808336');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('e256', 'Keeley', 'Dudden', '6936 Valley Edge Alley', 90254, 'Sweden', '8311302100');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('z839', 'Fannie', 'McFeat', '7 Messerschmidt Junction', 947, 'China', '7017949899');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('h397', 'Abraham', 'Pipet', '366 Saint Paul Circle', 72130, 'France', '8536026893');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('v128', 'Ursala', 'Ortes', '42 Harbort Way', 46693, 'United States', '6012190104');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('t476', 'Lu', 'Machon', '37124 Declaration Drive', 53719, 'Slovenia', '9273708875');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('s875', 'Maxie', 'Jakoub', '73 Swallow Parkway', 3178, 'South Africa', '8392951701');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('e909', 'Fonsie', 'Leythley', '8572 Killdeer Pass', 98727, 'China', '8417885767');
insert into Huesped (claveHuesped, apPatHuesped, apMatHuesped, calleHues, CPHues, paisHues, telHues) values ('x551', 'Oneida', 'Glentworth', '78 Homewood Alley', 51001, 'China', '9277560167');


--Tabla Alojamiento

--Tabla Habitación Dani

CREATE TABLE Habitacion(
    noHab CHAR(4) NOT NULL,
    clvAlo CHAR(4) NOT NULL,
    tipoHab VARCHAR(15) NOT NULL,
    estatusHab VARCHAR(15) NOT NULL,
    precioHab NUMBER(8,2) NOT NULL,
    CONSTRAINT PK_Habitacion PRIMARY KEY (noHab,clvAlo),
    CONSTRAINT FK_Habitacion_Alojamiento FOREIGN KEY (clvAlo) REFERENCES alojamiento ON DELETE CASCADE,
    CONSTRAINT CK_Habitacion_TipoHab CHECK (tipoHab IN ('INDIVIDUAL','DOBLE','TRIPLE')),
    CONSTRAINT CK_Habitacion_EstatusHab CHECK (estatusHab IN ('DISPONIBLE','OCUPADO'))
);

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
