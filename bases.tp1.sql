/*
drop table InfraccionVehiculoPersona ;
drop table AccidenteVehiculoPersona;
drop table HabilitacionConduccion;
drop table Peritaje;
drop table Testigo;
drop table Calle;
drop table Ruta;
drop table Vehiculo;
drop table Licencia;
drop table Persona;
drop table Accidente;
drop table Infraccion;
drop table Lugar;
drop table Modalidad;
*/

/*
Lugar(idLugar, nombre, tipoPavimento, longitud, velocidaMaxima, tipo)
PK = CK = {idLugar}
*/
CREATE TABLE Lugar
(
    idLugar   int,
	nombre		varchar(128),
	tipoPavimento varchar(256), 
	longitud	int, 
	velocidaMaxima int,
	tipo		varchar(16),
	PRIMARY KEY (idLugar)
);

/*
Calle(idLugar, provincia, ciudad)
PK = CK = FK ={idLugar}
*/
CREATE TABLE Calle
(
    idLugar 	int,
    provincia	varchar(128),
	ciudad		varchar(128),
	PRIMARY KEY (idLugar),
	FOREIGN KEY (idLugar) REFERENCES Lugar(idLugar)
);

/*
Ruta(idLugar, esNacional)
PK = CK = FK ={idLugar}
*/
CREATE TABLE Ruta
(
    idLugar 		int, 
    esNacional  	bit, /*Provincial/Nacional*/
	PRIMARY KEY (idLugar),
	FOREIGN KEY (idLugar) REFERENCES Lugar(idLugar)
);

/*
	Persona(dni, nombre, apellido, nacionalidad, fechaNacimiento, domicilio)
	PK = CK = {dni}
*/
CREATE TABLE Persona
(
    dni		int,
	nombre	varchar(128), 
	apellido varchar(128), 
	nacionalidad varchar(128), 
	fechaNacimiento date, 
	domicilio varchar(256),
	PRIMARY KEY (dni)
);

/*
Vehiculo(patente, anio, categoria, titular, aseguradora, tipoCobertura, vigenciaSeguro)
PK = CK = {patente}
FK = {dniDuenio}
*/
CREATE TABLE Vehiculo
(
    patente   	    CHAR(6),
    marca           VARCHAR(48), 
    modelo          VARCHAR(48), 
	anio			smallint,
	categoria	    varchar(128),
	titular 		int, /*dniPersona*/
	aseguradora		varchar(128),
	tipoCobertura	varchar(128),
	vigenciaSeguro		date, 		
	PRIMARY KEY (patente),
	FOREIGN KEY (titular) REFERENCES Persona(dni) 
);

/*
    Modalidad(idModalidad, descripcion)
    PK = CK = {idModalidad}
*/
CREATE TABLE Modalidad
(
    idModalidad  int,
    descripcion varchar(32)
);

/*
	Accidente(idAccidente, fecha, idLugar, altura, fechaDenuncia, comisaria, oficial, idModalidad)
	PK = CK = {idAccidente}
	FK = {idLugar, idModalida}
*/
CREATE TABLE Accidente
(
    idAccidente		int, 
	fecha			date, 
	idLugar			int,
	altura		 	int,
	fechaDenuncia	date,	 
	comisaria		varchar(256), 
	oficial			varchar(256),
	idModalidad     int,
	PRIMARY KEY (idAccidente), 
	FOREIGN KEY (idLugar) REFERENCES Lugar(idLugar),
	FOREIGN KEY (idModalidad) REFERENCES Modalidad(idModalidad)
);

/*
	Infraccion(idInfraccion, fecha, idLugar, altura, tipo, oficial)
	PK = CK = {idInfraccion}
	FK = {idLugar}
*/
CREATE TABLE Infraccion
(
    idInfraccion int,
    fecha	 	 date,
    idLugar		 int,
	altura		 int,
    tipo	     varchar(256),
	oficial		 varchar(256),
	PRIMARY KEY (idInfraccion), 
	FOREIGN KEY (idLugar) REFERENCES Lugar(idLugar)
);

/*
	Licencia(numero, dni, clases, otorgamiento, vencimiento)
	PK = CK = {numero, dni}
	FK = {dni}
*/
/*
Se asume:
    *Solo es necesario mantener los datos de la ultima renovacion de licencia
    *Agregar una nueva clase implica renovar la licencia
*/
CREATE TABLE Licencia
(
    numero          int, 
    dni 		    int,
    clases          varchar(256),
    otorgamiento    date, 
    vencimiento     date,
    PRIMARY KEY (numero, dni),
	FOREIGN KEY (dni) REFERENCES Persona(dni) 
);

/*
	HabilitacionConduccion(dni, patente)
	PK = CK = {(dni, patente)}
	FK = {dni, patente}
*/
CREATE TABLE HabilitacionConduccion
(
    dni			int,
    patente		CHAR(6), 
	PRIMARY KEY (dni, patente),
    FOREIGN KEY (dni) REFERENCES Persona (dni), 
	FOREIGN KEY (patente) REFERENCES Vehiculo (patente)
);

/*
	Testigo(idAccidente, dni)
	PK = CK = {(idAccidente, dni)}
	FK = {idAccidente, dni}
*/
CREATE TABLE Testigo
(
    idAccidente int,
    dni 		int,
    PRIMARY KEY (idAccidente, dni),
    FOREIGN KEY (idAccidente) REFERENCES Accidente(idAccidente),
    FOREIGN KEY (dni) REFERENCES Persona (dni)
);

/*
	InfraccionVehiculoPersona(idInfraccion, dni, patente)
	CK = {(idInfraccion, dni), (idInfraccion, patente)}
	PK = {(idInfraccion, dni)}
	FK = {idInfraccion, dni, patente}
*/
CREATE TABLE InfraccionVehiculoPersona
(
    idInfraccion    int,
    dni             int,
    patente         CHAR(6),
    PRIMARY KEY (idInfraccion, dni),
    FOREIGN KEY (idInfraccion) REFERENCES Infraccion(idInfraccion),
    FOREIGN KEY (patente) REFERENCES Vehiculo (patente),
    FOREIGN KEY (dni) REFERENCES Persona (dni)
);

/*
	AccidenteVehiculoPersona(idAccidente, dni, patente)
	CK = {(idAccidente, dni), (idAccidente, patente)}
	PK = {(idAccidente, dni)}
	FK = {idAccidente, dni, patente}
	
* Para un accidente debe existir almenos una persona con rol Conductor
*/
CREATE TABLE AccidenteVehiculoPersona
(
    idAccidente int,
    dni			int,
    patente 	CHAR(6),
	rolPersona	varchar(128),
    PRIMARY KEY (idAccidente, dni),
    FOREIGN KEY (idAccidente) REFERENCES Accidente (idAccidente),
    FOREIGN KEY (patente) REFERENCES Vehiculo (patente),
    FOREIGN KEY (dni) REFERENCES Persona (dni)
);

/*
	Peritaje(idPeritaje, idAccidente, perito, fecha, motivo, resultado)
	PK = CK = {idPeritaje, idAccidente}
	FK = {idAccidente}
*/
CREATE TABLE Peritaje
(
    idPeritaje int, 
    idAccidente int,
	perito		varchar(128), 
	fecha		datetime, 
	motivo		varchar(512), 
	resultado	varchar(8000),
    PRIMARY KEY (idAccidente, idPeritaje),
    FOREIGN KEY (idAccidente) REFERENCES Accidente (idAccidente)
);


/*********************************************************************************/

/*
SELECT 'INSERT INTO ' 
        + name 
        + '('
        + substring( (
                Select ', '+name  AS [text()]
                From sys.columns c where c.object_id = t.object_id
                For XML PATH ('')
          ), 2, 1000) 
        +' ) VALUES ' 
from sys.tables t
*/

INSERT INTO Lugar(  idLugar, nombre, tipoPavimento, longitud, velocidaMaxima ) VALUES
(1,'Ruta N40', 'ripio', 4500000, 30, 'ruta'), 
(2,'Avenida 9 de Julio', 'asfalto', 3600, 60, 'calle'), 
(3,'Junin', 'asfalto', 4000, 40,'calle'), 
(4,'Avenida 9 de Julio', 'asfalto', 1900, 40,'calle'), 
(5,'Yapeyu', 'asfalto', 800, 40,'calle'), 
(6,'Ruta N4', 'asfalto', 4500, 30, 'ruta')
;
INSERT INTO Calle(  idLugar, provincia, ciudad ) VALUES 
(2, 'Capital Federal', 'Capital Federal'),
(3, 'Cordoba','Villa Carlos Paz'),
(4, 'Entre Rios', 'Chajari'),
(5, 'Capital Federal', 'Capital Federal')
;
INSERT INTO Ruta(  idLugar, esNacional ) VALUES 
(1, 1),
(6, 0)
;

INSERT INTO Persona(  dni, nombre, apellido, nacionalidad, fechaNacimiento, domicilio ) VALUES 
(24511187, 'Juan', 'Perez', 'argentino', '19480711', 'Riobamba 2323, CABA'),
(95789111, 'Marco', 'Puertas', 'uruguayo', '19881221', 'Cochabamba 23, Santa Ana, Entre Rios'),
(34655298, 'Marta', 'Paredes', 'argentina', '19880908', '3 Arroyos 124, Ciudad Autonoma de Buenos Aires'),
(54879213, 'Marcela', 'Morales', 'argentina', '19540321', 'San Martin 2344, Junin, Buenos Aires'),
(47111111, 'Emiliano', 'Rosales', 'argentino', '19430706', 'Venezuela 1789, Almagro, Capital Federal'),
(31849516, 'Rosario', 'San Marcos', 'argentina', '19841007', 'Gregoria Perez 3202, Capital Federal')
;

/*http://www.buenosaires.gob.ar/areas/obr_publicas/lic_conducir/categorias.php?menu_id=6427*/
INSERT INTO Licencia(numero, dni, clases, otorgamiento, vencimiento) VALUES
(11445123, 24511187, 'C, B2, D1', '20060701', '20160701' ),
(24546788, 34655298, 'B1', '20090101', '20190101'),
(19345677, 47111111, 'B1', '20121201', '20221201'),
(30111345, 31849516, 'A1', '20120301', '20220301')
;

INSERT INTO Modalidad (idModalidad, descripcion) VALUES 
(1, 'atropello'),
(2, 'vuelco'),
(3, 'incendio'),
(4, 'choque contra objeto estatito'),
(5, 'caída del ocupante'),
(6, 'choque en cadena'),
(7, 'choque frontal')
;


INSERT INTO Vehiculo(  patente, marca, modelo, anio, categoria, titular ,aseguradora, tipoCobertura, vigenciaSeguro) VALUES 
('CJK165', 'Peugeot', '306', 2006, 'sedan gama media', 24511187,  'La Caja', 'Todo Total', '20160701' ),
('AAA456', 'Ford', 'Mondeo', 2006, 'sedan gama alta', 95789111,  'La Caja', 'Terceros Completo con Granizo', '20160701' ),
('RWE951', 'Ford', 'F100', 1984, 'camioneta', 24511187,  'La Caja', 'Responsabilidad Civil', '20160701' ),
('TKL111', 'Citroen', '3CV', 1972, 'sedan gama media', 34655298,  'La Caja', 'Terceros Completo con Granizo', '20160701' ),
('EEE245', 'Toyota', 'Corola', 2010, 'sedan gama alta', 47111111,  'La Caja', 'Responsabilidad Civil', '20160701' )
;

INSERT INTO HabilitacionConduccion(  dni, patente ) VALUES 
(24511187, 'CJK165'),
(95789111, 'AAA456'),
(24511187, 'RWE951'),
(34655298, 'TKL111'),
(47111111, 'EEE245'),
(24511187, 'EEE245'),
(54879213, 'AAA456')
;


INSERT INTO Accidente(  idAccidente, fecha, idLugar, altura, fechaDenuncia, comisaria, oficial, idModalidad) VALUES 
(1,'20101005', 1, 2400, '20101005', 'Comisaria 123, San Rafael de Mendoza', 'Teniente Juan Manuel Rosas', 2),
(2,'20150417', 4, 1025, '20150418', 'Comisaria 15, Chajari', 'Pedro Moscano',7),
(3,'20061224', 5, 493, '20061224', 'Comisaria 78, Almagro', 'Cabo Fernando Freitas', 1),
(4,'20101005', 2, 3011, '20101005', 'Comisaria 123, San Rafael de Mendoza', 'Teniente Juan Manuel Rosas',2),
(5,'20121103', 2, 3011, '20121103', 'Comisaria 55, San Rafael de Mendoza', 'Jose Ramos',2),
(6,'20140809', 3, 244, '20140809', 'Comisaria 74', 'Mariano Puentes' ,7)
;

TRUNCATE TABLE AccidenteVehiculoPersona
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) VALUES 
(1,24511187, 'RWE951', 'conductor'),
(2,24511187, 'CJK165', 'conductor'),
(2,34655298, 'TKL111', 'conductor'),
(3,24511187, 'CJK165', 'conductor'),
(3,34655298, 'CJK165', 'acompañante'),
(3,47111111, 'CJK165', 'atropellado'),
(4,47111111, 'EEE245', 'conductor'),
(4,95789111, 'EEE245', 'conductor'),
(5,24511187, 'RWE951', 'conductor'),
(6,34655298, 'TKL111', 'conductor'),
(6,24511187, 'TKL111', 'acompañante'),
(6,95789111, 'AAA456', 'conductor'),
(6,47111111, 'EEE245', 'conductor')
;

INSERT INTO Testigo(  idAccidente, dni ) VALUES 
(1,47111111 ),
(1,95789111 ),
(2,47111111 ),
(2,34655298 ),
(2,95789111 ),
(4,24511187 )
;

INSERT INTO Peritaje(  idPeritaje, idAccidente, perito, fecha, motivo, resultado ) VALUES 
(1, 1, 'Lic Jorge Garrafa', '20101006', 'Heridos', 'No se registraron.' ),
(2, 1, 'Lic Jorge Garrafa', '20101006', 'Uso de cinturon de seguridad', 'El conductor llevaba abrochado el cinturon de seguridad.' ),
(3, 1, 'Lic Jorge Garrafa', '20101006', 'Condiciones meteorologicas', 'Cielo despejado. Visibilidad normal a 1500m.' ),
(4, 1, 'Lic Jorge Garrafa', '20101006', 'Estado del asfalto', 'La ruta presentaba baches en la zona del accidente.' )
;
INSERT INTO Infraccion(  idInfraccion, fecha, idLugar, altura, tipo, oficial ) VALUES 
(1,'20010126', 2, 1234, 'Cruza semaforo en rojo', 'Martin Chomspy'),
(2,'20010126', 3, 233, 'Estacionamiento no habilitado', 'Martin Chomspy'),
(3,'20010126', 2, 756, 'Maxima velocidad superada', 'Martin Chomspy'),
(4,'20010126', 1, 888, 'Cruza semaforo en rojo', 'Martin Chomspy')
;
INSERT INTO InfraccionVehiculoPersona(  idInfraccion, dni, patente ) VALUES 
(1, 24511187,'RWE951'),
(2, 54879213, 'AAA456'),
(3, 24511187, 'CJK165'),
(4, 47111111, 'EEE245')
;

/****************************************************************************************************/

SELECT  a.idAccidente, p.Nombre, p.Apellido, p.dni,  l.numero as Licencia, avp.rolPersona as participacion, m.descripcion, v.patente,  a.fecha, lu.nombre as 'lugar'
FROM AccidenteVehiculoPersona avp 
INNER JOIN Persona p
ON avp.dni = p.dni
LEFT JOIN Licencia l
ON p.dni = l.dni
INNER JOIN Accidente a
ON a.idAccidente = avp.idAccidente
INNER JOIN Lugar lu
ON lu.idLugar = a.idLugar
INNER JOIN Modalidad m
ON m.idModalidad = a.idModalidad
INNER JOIN Vehiculo v
ON v.patente = avp.patente
--WHERE l.numero = 24546788 AND avp.rolPersona = 'conductor'
order by a.idAccidente
;

select l.numero as Licencia, m.descripcion, count(1)
from AccidenteVehiculoPersona avp
INNER JOIN Accidente a
ON a.idAccidente = avp.idAccidente
INNER JOIN Modalidad m
ON m.idModalidad = a.idModalidad
INNER JOIN Persona p
ON p.dni = avp.dni
LEFT JOIN Licencia l
ON l.dni = p.dni 
--WHERE avp.modalidad
GROUP BY l.numero, m.descripcion
order by l.numero