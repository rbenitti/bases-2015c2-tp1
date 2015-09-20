/*
Lugar(_idLugar_, nombre, tipoPavimento, longitud, velocidaMaxima)
PK = CK = {_idLugar_}
*/
CREATE TABLE Lugar
(
    idVia   int,
	nombre		varchar(128),
	tipoPavimento varchar(256), 
	longitud	int, 
	velocidaMaxima int
)

/*
Calle(_idLugar_, provincia, ciudad)
PK = CK = FK ={_idLugar_}
*/
CREATE TABLE Calle
(
    idLugar 	int,
    provincia	varchar(128),
	ciudad		varchar(128)
)


/*
Ruta(_idLugar_, esNacional)
PK = CK = FK ={_idLugar_}
*/
CREATE TABLE Ruta
(
    idLugar 		int, 
    esNacional  	bit, /*Provincial/Nacional*/
	FOREIGN KEY idLugar REFERENCES Lugar(idLugar)
)

/*
Vehiculo(_patente_, aseguradora, tipoCobertura, vigencia, anio, gama, categoria, idDuenio)
PK = CK = {_patente_}
FK = {idDuenio}
*/
CREATE TABLE Vehiculo
(
    patente   	CHAR(6),
	aseguradora		varchar(128),
	tipoCobertura	varchar(128),
	vigencia		date, 		
	anio			smallint,
	gama			varchar(128),
	categoria		varchar(128),
	idDuenio 		int /*dniPersona*/
	PRIMARY KEY (patente)
)

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
)   

/*
	Accidente(idAccidente, fecha, idLugar, altura, fechaDenuncia, comisaria, oficial)
	PK = CK = {idAccidente}
	FK = {idLugar}
*/
CREATE TABLE Accidente
(
    idAccidente		int, 
	fecha			date, 
	idLugar			int,
	altura		 	int,
	fechaDenuncia	date,	 
	comisaria		varchar(256), 
	oficial			varchar(256)
	)

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
	oficial		 varchar(256)
)

/*
	Licencia(idPersona, categoria, fechaCaducidad)
	PK = CK = {idPersona, categoria}
	FK = {idPersona}
*/
CREATE TABLE Licencia
(
    idPersona 		int,
    categoria 		int,
	fechaCaducidad 	date
)

/*
	HabilitacionConduccion(patente, dni)
	PK = CK = {(patente, dni)}
	FK = {patente, dni}
*/
CREATE TABLE HabilitacionConduccion
(
    patente		char(6), 
	dni			int,
    PRIMARY KEY (patente, dni),
	FOREIGN KEY (patente) REFERENCES Vehiculo (patente),
    FOREIGN KEY (dni) REFERENCES Persona (dni) 
)

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
    FOREIGN KEY (idAccidente) REFERENCES Accidente (idAccidente),
    FOREIGN KEY (dni) REFERENCES Persona (dni)
)   

/*
	InfraccionVehiculoPersona(idInfraccion, dni, patente)
	CK = {(idInfraccion, dni), (idInfraccion, patente)}
	PK = {(idInfraccion, dni)}
	FK = {idInfraccion, dni, patente}
*/
CREATE TABLE InfraccionVehiculoPersona
(
    idInfraccion int,
    dni int,
    patente int,
    PRIMARY KEY (idInfraccion, dni),
    FOREIGN KEY (idInfraccion) REFERENCES Infraccion (idInfraccion),
    FOREIGN KEY (patente) REFERENCES Vehiculo (patente),
    FOREIGN KEY (dni) REFERENCES Persona (dni)
)

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
    patente 	int,
	rolPersona	varchar(128),
    PRIMARY KEY (idAccidente, dniPersona),
    FOREIGN KEY (idAccidente) REFERENCES Siniestro (idAccidente),
    FOREIGN KEY (idVehiculo) REFERENCES Vehiculo (idVehiculo),
    FOREIGN KEY (dniPersona) REFERENCES Persona (dniPersona)
)

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
	resultado	varchar(8000)
    PRIMARY KEY (idAccidente, idPeritaje),
    FOREIGN KEY (idAccidente) REFERENCES Accidente (idAccidente),
    
)