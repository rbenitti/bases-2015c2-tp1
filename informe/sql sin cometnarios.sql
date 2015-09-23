CREATE TABLE Lugar
(
    idLugar         int NOT NULL,
	nombre          varchar(128),
	tipoPavimento   varchar(256), 
	longitud        int, 
	velocidaMaxima  int,
	tipo            varchar(16) NOT NULL,
	PRIMARY KEY (idLugar)
);
Go

CREATE TRIGGER chkTipoLugar ON Lugar
FOR INSERT, UPDATE
AS 
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (select 1 from inserted where tipo not in ('ruta', 'calle'))
        Rollback Transaction
END
Go

CREATE TABLE Calle
(
    idLugar 	int,
    provincia	varchar(128),
	ciudad		varchar(128),
	PRIMARY KEY (idLugar),
	FOREIGN KEY (idLugar) REFERENCES Lugar(idLugar)
);

CREATE TABLE Ruta
(
    idLugar 		int, 
    tipo            char(10),
	PRIMARY KEY (idLugar),
	FOREIGN KEY (idLugar) REFERENCES Lugar(idLugar)
);
Go
CREATE TRIGGER chkTipoRuta ON Ruta
FOR INSERT, UPDATE
AS 
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (select 1 from inserted where tipo not in ('provincial', 'nacional'))
        Rollback Transaction
END
Go


CREATE TABLE Persona
(
    dni             int,
	nombre          varchar(128), 
	apellido        varchar(128), 
	nacionalidad    varchar(128), 
	fechaNacimiento datetime, 
	domicilio       varchar(256),
	numeroLic       int, 
    clasesLic       varchar(256),
    otorgamientoLic datetime, 
    vencimientoLic     datetime,
    PRIMARY KEY (dni)
);


CREATE TABLE Vehiculo
(
    patente   	    CHAR(6),
    marca           VARCHAR(48), 
    modelo          VARCHAR(48), 
	anio			smallint,
	tipo            varchar(16),
	categoria	    varchar(128),
	titular 		int,
	aseguradora		varchar(128),
	tipoCobertura	varchar(128),
	vigenciaSeguro  datetime, 		
	PRIMARY KEY (patente),
	FOREIGN KEY (titular) REFERENCES Persona(dni) 
);
GO
CREATE TRIGGER chkTipoVehiculo ON Vehiculo
FOR INSERT, UPDATE
AS 
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (select 1 from inserted where tipo not in ('automovil', 'camion', 'motocicleta', 'camioneta', 'utilitario'))
        Rollback Transaction
END
Go


CREATE TABLE Modalidad
(
    idModalidad  int,
    descripcion varchar(32),
    PRIMARY KEY (idModalidad)
);


CREATE TABLE Accidente
(
    idAccidente		int, 
	fecha			datetime, 
	idLugar			int,
	altura		 	int,
	fechaDenuncia	datetime,	 
	comisaria		varchar(256), 
	oficial			varchar(256),
	idModalidad     int,
	PRIMARY KEY (idAccidente), 
	FOREIGN KEY (idLugar) REFERENCES Lugar(idLugar),
	FOREIGN KEY (idModalidad) REFERENCES Modalidad(idModalidad)
);


CREATE TABLE Infraccion
(
    idInfraccion int,
    fecha	 	 datetime,
    idLugar		 int,
	altura		 int,
    tipo	     varchar(256),
	oficial		 varchar(256),
	PRIMARY KEY (idInfraccion), 
	FOREIGN KEY (idLugar) REFERENCES Lugar(idLugar)
);


CREATE TABLE HabilitacionConduccion
(
    dni			int,
    patente		CHAR(6), 
	PRIMARY KEY (dni, patente),
    FOREIGN KEY (dni) REFERENCES Persona (dni), 
	FOREIGN KEY (patente) REFERENCES Vehiculo (patente)
);


CREATE TABLE Testigo
(
    idAccidente int,
    dni 		int,
    PRIMARY KEY (idAccidente, dni),
    FOREIGN KEY (idAccidente) REFERENCES Accidente(idAccidente),
    FOREIGN KEY (dni) REFERENCES Persona (dni)
);

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

CREATE TABLE AntecedentePenal 
(
    numeroCausa     int,
    dni             int,
    motivo          varchar(256),
    estado          varchar(32),
    FOREIGN KEY (dni) REFERENCES Persona (dni)
)

INSERT INTO Lugar(  idLugar, nombre, tipoPavimento, longitud, velocidaMaxima, tipo ) 
VALUES (1,'Ruta N40', 'ripio', 4500000, 30, 'ruta')
INSERT INTO Lugar(  idLugar, nombre, tipoPavimento, longitud, velocidaMaxima, tipo ) 
VALUES (2,'Avenida 9 de Julio', 'asfalto', 3600, 60, 'calle')
INSERT INTO Lugar(  idLugar, nombre, tipoPavimento, longitud, velocidaMaxima, tipo ) 
VALUES (3,'Junin', 'asfalto', 4000, 40,'calle') 
INSERT INTO Lugar(  idLugar, nombre, tipoPavimento, longitud, velocidaMaxima, tipo ) 
VALUES (4,'Avenida 9 de Julio', 'asfalto', 1900, 40,'calle')
INSERT INTO Lugar(  idLugar, nombre, tipoPavimento, longitud, velocidaMaxima, tipo ) 
VALUES (5,'Yapeyu', 'asfalto', 800, 40,'calle')
INSERT INTO Lugar(  idLugar, nombre, tipoPavimento, longitud, velocidaMaxima, tipo ) 
VALUES (6,'Ruta N4', 'asfalto', 4500, 30, 'ruta')
;
INSERT INTO Calle(  idLugar, provincia, ciudad ) VALUES (2, 'Capital Federal', 'Capital Federal')
INSERT INTO Calle(  idLugar, provincia, ciudad ) VALUES (3, 'Cordoba','Villa Carlos Paz')
INSERT INTO Calle(  idLugar, provincia, ciudad ) VALUES (4, 'Entre Rios', 'Chajari')
INSERT INTO Calle(  idLugar, provincia, ciudad ) VALUES (5, 'Capital Federal', 'Capital Federal')
;
INSERT INTO Ruta( idLugar, tipo ) VALUES (1, 'Nacional')
INSERT INTO Ruta( idLugar, tipo ) VALUES(6, 'Provincial')
;

INSERT INTO Persona( dni, nombre, apellido, nacionalidad, fechaNacimiento, domicilio, numeroLic,  clasesLic, otorgamientoLic, vencimientoLic) 
VALUES (24511187, 'Juan', 'Perez', 'argentino', '19480711', 'Riobamba 2323, CABA',11445123, 'C, B2, D1', '20060701', '20160701')
INSERT INTO Persona( dni, nombre, apellido, nacionalidad, fechaNacimiento, domicilio, numeroLic,  clasesLic, otorgamientoLic, vencimientoLic) 
VALUES (95789111, 'Marco', 'Puertas', 'uruguayo', '19881221', 'Cochabamba 23, Santa Ana, Entre Rios', 45632123, 'B1, C2', '20150501', '20250501')
INSERT INTO Persona( dni, nombre, apellido, nacionalidad, fechaNacimiento, domicilio, numeroLic,  clasesLic, otorgamientoLic, vencimientoLic) 
VALUES (34655298, 'Marta', 'Paredes', 'argentina', '19880908', '3 Arroyos 124, Ciudad Autonoma de Buenos Aires', 24546788, 'B1', '20090101', '20190101')
INSERT INTO Persona( dni, nombre, apellido, nacionalidad, fechaNacimiento, domicilio, numeroLic,  clasesLic, otorgamientoLic, vencimientoLic) 
VALUES (54879213, 'Marcela', 'Morales', 'argentina', '19540321', 'San Martin 2344, Junin, Buenos Aires', 24754575, 'A1, B1', '20110301', '20210301')
INSERT INTO Persona( dni, nombre, apellido, nacionalidad, fechaNacimiento, domicilio, numeroLic,  clasesLic, otorgamientoLic, vencimientoLic) 
VALUES (47111111, 'Emiliano', 'Rosales', 'argentino', '19430706', 'Venezuela 1789, Almagro, Capital Federal', 19345677,  'B1', '20121201', '20221201')
GO
INSERT INTO Persona( dni, nombre, apellido, nacionalidad, fechaNacimiento, domicilio, numeroLic,  clasesLic, otorgamientoLic, vencimientoLic) 
VALUES (31849516, 'Rosario', 'San Marcos', 'argentina', '19841007', 'Gregoria Perez 3202, Capital Federal', 30111345, 'A1', '20120301', '20220301')
GO
;

INSERT INTO Modalidad (idModalidad, descripcion) VALUES (1, 'atropello')
INSERT INTO Modalidad (idModalidad, descripcion) VALUES (2, 'vuelco')
INSERT INTO Modalidad (idModalidad, descripcion) VALUES (3, 'incendio')
INSERT INTO Modalidad (idModalidad, descripcion) VALUES (4, 'choque contra objeto estatito')
INSERT INTO Modalidad (idModalidad, descripcion) VALUES (5, 'caída del ocupante')
INSERT INTO Modalidad (idModalidad, descripcion) VALUES (6, 'choque en cadena')
INSERT INTO Modalidad (idModalidad, descripcion) VALUES (7, 'choque frontal')
;


INSERT INTO Vehiculo(  patente, marca, modelo, anio, tipo, categoria, titular ,aseguradora, tipoCobertura, vigenciaSeguro) 
VALUES ('CJK165', 'Peugeot', '306', 2006, 'automovil','sedan gama media', 24511187,  'La Caja', 'Todo Total', '20160701' )
INSERT INTO Vehiculo(  patente, marca, modelo, anio, tipo, categoria, titular ,aseguradora, tipoCobertura, vigenciaSeguro) 
VALUES ('AAA456', 'Ford', 'Mondeo', 2006, 'automovil','sedan gama alta', 95789111,  'La Caja', 'Terceros Completo con Granizo', '20160701' )
INSERT INTO Vehiculo(  patente, marca, modelo, anio, tipo, categoria, titular ,aseguradora, tipoCobertura, vigenciaSeguro) 
VALUES ('RWE951', 'Ford', 'F100', 1984, 'camioneta','gama media', 24511187,  'La Caja', 'Responsabilidad Civil', '20160701' )
INSERT INTO Vehiculo(  patente, marca, modelo, anio, tipo, categoria, titular ,aseguradora, tipoCobertura, vigenciaSeguro) 
VALUES ('TKL111', 'Citroen', '3CV', 1972, 'automovil','sedan gama media', 34655298,  'La Caja', 'Terceros Completo con Granizo', '20160701' )
INSERT INTO Vehiculo(  patente, marca, modelo, anio, tipo, categoria, titular ,aseguradora, tipoCobertura, vigenciaSeguro) 
VALUES ('EEE245', 'Toyota', 'Corola', 2010, 'automovil','sedan gama alta', 47111111,  'La Caja', 'Responsabilidad Civil', '20160701' )
INSERT INTO Vehiculo(  patente, marca, modelo, anio, tipo, categoria, titular ,aseguradora, tipoCobertura, vigenciaSeguro) 
VALUES ('GHJ924', 'Ford', 'Taunus', 1973, 'batimovil','gama media', 47111111,  'La Caja', 'Responsabilidad Civil', '20160701' )
;

INSERT INTO HabilitacionConduccion(  dni, patente ) VALUES (24511187, 'CJK165')
INSERT INTO HabilitacionConduccion(  dni, patente ) VALUES (95789111, 'AAA456')
INSERT INTO HabilitacionConduccion(  dni, patente ) VALUES (24511187, 'RWE951')
INSERT INTO HabilitacionConduccion(  dni, patente ) VALUES (34655298, 'TKL111')
INSERT INTO HabilitacionConduccion(  dni, patente ) VALUES (47111111, 'EEE245')
INSERT INTO HabilitacionConduccion(  dni, patente ) VALUES (24511187, 'EEE245')
INSERT INTO HabilitacionConduccion(  dni, patente ) VALUES (54879213, 'AAA456')
;


INSERT INTO Accidente(  idAccidente, fecha, idLugar, altura, fechaDenuncia, comisaria, oficial, idModalidad) 
VALUES (1,'20101005', 1, 2400, '20101005', 'Comisaria 123, San Rafael de Mendoza', 'Teniente Juan Manuel Rosas', 2)
INSERT INTO Accidente(  idAccidente, fecha, idLugar, altura, fechaDenuncia, comisaria, oficial, idModalidad) 
VALUES (2,'20150417', 4, 1025, '20150418', 'Comisaria 15, Chajari', 'Pedro Moscano',7)
INSERT INTO Accidente(  idAccidente, fecha, idLugar, altura, fechaDenuncia, comisaria, oficial, idModalidad) 
VALUES (3,'20061224', 5, 493, '20061224', 'Comisaria 78, Almagro', 'Cabo Fernando Freitas', 1)
INSERT INTO Accidente(  idAccidente, fecha, idLugar, altura, fechaDenuncia, comisaria, oficial, idModalidad) 
VALUES (4,'20101005', 2, 3011, '20101005', 'Comisaria 123, San Rafael de Mendoza', 'Teniente Juan Manuel Rosas',2)
INSERT INTO Accidente(  idAccidente, fecha, idLugar, altura, fechaDenuncia, comisaria, oficial, idModalidad) 
VALUES (5,'20121103', 2, 3011, '20121103', 'Comisaria 55, San Rafael de Mendoza', 'Jose Ramos',2)
INSERT INTO Accidente(  idAccidente, fecha, idLugar, altura, fechaDenuncia, comisaria, oficial, idModalidad) 
VALUES (6,'20140809', 3, 244, '20140809', 'Comisaria 74', 'Mariano Puentes' ,7)
;

INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (1,24511187, 'RWE951', 'conductor')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (2,24511187, 'CJK165', 'conductor')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (2,34655298, 'TKL111', 'conductor')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (3,24511187, 'CJK165', 'conductor')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (3,34655298, 'CJK165', 'acompañante')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (3,47111111, 'CJK165', 'atropellado')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (4,47111111, 'EEE245', 'conductor')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (4,95789111, 'EEE245', 'conductor')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (5,24511187, 'RWE951', 'conductor')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (6,34655298, 'TKL111', 'conductor')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (6,24511187, 'TKL111', 'acompañante')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (6,95789111, 'AAA456', 'conductor')
INSERT INTO AccidenteVehiculoPersona(  idAccidente, dni, patente, rolPersona ) 
VALUES (6,47111111, 'EEE245', 'conductor')
;

INSERT INTO Testigo(  idAccidente, dni ) VALUES (1,47111111 )
INSERT INTO Testigo(  idAccidente, dni ) VALUES (1,95789111 )
INSERT INTO Testigo(  idAccidente, dni ) VALUES (2,47111111 )
INSERT INTO Testigo(  idAccidente, dni ) VALUES (2,34655298 )
INSERT INTO Testigo(  idAccidente, dni ) VALUES (2,95789111 )
INSERT INTO Testigo(  idAccidente, dni ) VALUES (4,24511187 )
;

INSERT INTO Peritaje(  idPeritaje, idAccidente, perito, fecha, motivo, resultado ) 
VALUES (1, 1, 'Lic Jorge Garrafa', '20101006', 'Heridos', 'No se registraron.' )
INSERT INTO Peritaje(  idPeritaje, idAccidente, perito, fecha, motivo, resultado ) 
VALUES (2, 1, 'Lic Jorge Garrafa', '20101006', 'Uso de cinturon de seguridad', 
	'El conductor llevaba abrochado el cinturon de seguridad.' )
INSERT INTO Peritaje(  idPeritaje, idAccidente, perito, fecha, motivo, resultado ) 
VALUES (3, 1, 'Lic Jorge Garrafa', '20101006', 'Condiciones meteorologicas', 
	'Cielo despejado. Visibilidad normal a 1500m.' )
INSERT INTO Peritaje(  idPeritaje, idAccidente, perito, fecha, motivo, resultado ) 
VALUES (4, 1, 'Lic Jorge Garrafa', '20101006', 'Estado del asfalto', 
	'La ruta presentaba baches en la zona del accidente.' )
;

INSERT INTO Infraccion(  idInfraccion, fecha, idLugar, altura, tipo, oficial ) 
VALUES (1,'20010126', 2, 1234, 'Cruza semaforo en rojo', 'Martin Chomspy')
INSERT INTO Infraccion(  idInfraccion, fecha, idLugar, altura, tipo, oficial ) 
VALUES (2,'20010126', 3, 233, 'Estacionamiento no habilitado', 'Martin Chomspky')
INSERT INTO Infraccion(  idInfraccion, fecha, idLugar, altura, tipo, oficial ) 
VALUES (3,'20010126', 2, 756, 'Maxima velocidad superada', 'Marcelo Morela')
INSERT INTO Infraccion(  idInfraccion, fecha, idLugar, altura, tipo, oficial ) 
VALUES (4,'20010126', 1, 888, 'Cruza semaforo en rojo', 'Susana Trosky')
;

INSERT INTO InfraccionVehiculoPersona(  idInfraccion, dni, patente ) VALUES (1, 24511187,'RWE951')
INSERT INTO InfraccionVehiculoPersona(  idInfraccion, dni, patente ) VALUES (2, 54879213, 'AAA456')
INSERT INTO InfraccionVehiculoPersona(  idInfraccion, dni, patente ) VALUES (3, 24511187, 'CJK165')
INSERT INTO InfraccionVehiculoPersona(  idInfraccion, dni, patente ) VALUES (4, 47111111, 'EEE245')
;

INSERT INTO AntecedentePenal  (numeroCausa,dni,motivo,estado) 
VALUES (12332,24511187, 'Estafa', 'Sobreseido')
INSERT INTO AntecedentePenal  (numeroCausa,dni,motivo,estado) 
VALUES (12354,24511187, 'Defraudación', 'Sobreseido')
INSERT INTO AntecedentePenal  (numeroCausa,dni,motivo,estado) 
VALUES (75564,24511187, 'Amenazas', 'En tramite')
INSERT INTO AntecedentePenal  (numeroCausa,dni,motivo,estado) 
VALUES (32346,54879213, 'Usurpacion de autoridad', 'Sobreseido')
INSERT INTO AntecedentePenal  (numeroCausa,dni,motivo,estado) 
VALUES (97899,54879213, 'Tentativa de evasion impositiva', 'Procesado')
;
GO

IF EXISTS (SELECT 1 FROM sys.procedures where name = 'AccidentesPorLicencia')
    DROP PROCEDURE AccidentesPorLicencia
GO
CREATE PROCEDURE AccidentesPorLicencia @licencia int
AS
BEGIN
    SELECT  a.idAccidente, p.Nombre, p.Apellido, p.dni,  p.numeroLic as Licencia, avp.rolPersona as participacion, m.descripcion, v.patente,  a.fecha, 
	CASE lu.tipo 
		WHEN 'ruta' THEN lu.nombre +' ('+ r.tipo +')'
		WHEN 'calle' THEN lu.nombre + ', '+ c.ciudad + ', '+ c.provincia
	END as 'lugar', a.altura,
	(select count(1) from HabilitacionConduccion WHERE dni = p.dni) as [Cantidad de autos habilitados]
    FROM AccidenteVehiculoPersona avp 
    INNER JOIN Persona p
    ON avp.dni = p.dni
    INNER JOIN Accidente a
    ON a.idAccidente = avp.idAccidente
    INNER JOIN Lugar lu
    ON lu.idLugar = a.idLugar
    INNER JOIN Modalidad m
    ON m.idModalidad = a.idModalidad
    INNER JOIN Vehiculo v
	ON v.patente = avp.patente
    LEFT JOIN Calle c
	on c.idLugar = lu.idLugar
	LEFT JOIN Ruta r
	on r.idLugar = lu.idLugar
	WHERE (@licencia is null or p.numeroLic = @licencia)
    order by a.idAccidente
    ;
END
GO

IF EXISTS (SELECT 1 FROM sys.views where name = 'SumarioAccidentes')
    DROP VIEW SumarioAccidentes
GO
CREATE VIEW SumarioAccidentes AS
    select p.numeroLic as Licencia, m.descripcion as Modalidad, count(1) AS Cantidad
    from AccidenteVehiculoPersona avp
    INNER JOIN Accidente a
    ON a.idAccidente = avp.idAccidente
    INNER JOIN Modalidad m
    ON m.idModalidad = a.idModalidad
    INNER JOIN Persona p
    ON p.dni = avp.dni
    GROUP BY p.numeroLic, m.descripcion
GO

EXEC AccidentesPorLicencia 11445123
Go

SELECT * FROM SumarioAccidentes where modalidad = 'choque frontal'
GO

SELECT v.tipo, COUNT(1) AS Cantidad
FROM AccidenteVehiculoPersona avp
INNER JOIN Vehiculo v
on v.patente = avp.patente
group by v.tipo

select * from persona where dni = 95789111