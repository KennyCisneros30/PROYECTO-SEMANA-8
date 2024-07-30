USE [CS6-3]


SELECT * FROM PROPIETARIO
SELECT * FROM VEHICULO

--       /// Tabla Propietario///
 

CREATE TABLE PROPIETARIO (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    DNI VARCHAR(10) UNIQUE,
    NOMBRES VARCHAR(100),
    APELLIDOS VARCHAR(100),
    CORREO VARCHAR(100),
    TELEFONO VARCHAR(20),
    DIRECCION VARCHAR(200)
);




--       /// Procedimientos de Propietario///


-- Procedimiento para insertar un propietario
CREATE PROCEDURE InsertarPropietario
    @DNI VARCHAR(10),
    @NOMBRES VARCHAR(100),
    @APELLIDOS VARCHAR(100),
    @CORREO VARCHAR(100),
    @TELEFONO VARCHAR(20),
    @DIRECCION VARCHAR(200)
AS
BEGIN
    INSERT INTO PROPIETARIO (DNI, NOMBRES, APELLIDOS, CORREO, TELEFONO, DIRECCION)
    VALUES (@DNI, @NOMBRES, @APELLIDOS, @CORREO, @TELEFONO, @DIRECCION);
END



-- Procedimiento para modificar un propietario
CREATE PROCEDURE ModificarPropietario
    @DNI VARCHAR(10),
    @NOMBRES VARCHAR(100),
    @APELLIDOS VARCHAR(100),
    @CORREO VARCHAR(100),
    @TELEFONO VARCHAR(20),
    @DIRECCION VARCHAR(200)
AS
BEGIN
    UPDATE PROPIETARIO
    SET NOMBRES = @NOMBRES,
        APELLIDOS = @APELLIDOS,
        CORREO = @CORREO,
        TELEFONO = @TELEFONO,
        DIRECCION = @DIRECCION
    WHERE DNI = @DNI;
END


-- Procedimiento para eliminar un propietario
CREATE PROCEDURE EliminarPropietario
    @DNI VARCHAR(10)
AS
BEGIN
	DECLARE @ID_PROPIETARIO INT
    
	SELECT @ID_PROPIETARIO = ID 
	FROM PROPIETARIO 
	WHERE DNI = @DNI;
    
	DELETE FROM VEHICULO 
	WHERE ID_PROPIETARIO = @ID_PROPIETARIO;

	DELETE FROM PROPIETARIO
    WHERE DNI = @DNI;


END


-- Procedimiento para buscar un propietario por su DNI
CREATE PROCEDURE BuscarPropietarioPorDNI
    @DNI VARCHAR(10)
AS
BEGIN
    SELECT ID, DNI, NOMBRES, APELLIDOS, CORREO, TELEFONO, DIRECCION
    FROM PROPIETARIO
    WHERE DNI = @DNI;
END



--       /// Tabla Vehiculo ///



CREATE TABLE VEHICULO (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    PLACA VARCHAR(8) UNIQUE,
    VALOR DECIMAL(10,2), 
    A�O INT,
    CILINDRAJE INT, 
    MODELO VARCHAR(50), 
	COLOR VARCHAR(100),
	ID_PROPIETARIO INT FOREIGN KEY REFERENCES PROPIETARIO(ID)
);






--     /// Procedimientos de Vehiculos ///



-- Procedimiento para insertar un veh�culo
CREATE PROCEDURE InsertarVehiculo
    @PLACA VARCHAR(8),
    @VALOR DECIMAL(10,2),
    @A�O INT,
    @CILINDRAJE INT,
    @MODELO VARCHAR(50),
    @COLOR VARCHAR(100),
    @DNI_PROPIETARIO VARCHAR(10)
AS
BEGIN
    DECLARE @ID_PROPIETARIO INT
    SELECT @ID_PROPIETARIO = ID FROM PROPIETARIO WHERE DNI = @DNI_PROPIETARIO
    INSERT INTO VEHICULO (PLACA, VALOR, A�O, CILINDRAJE, MODELO, COLOR, ID_PROPIETARIO)
    VALUES (@PLACA, @VALOR, @A�O, @CILINDRAJE, @MODELO, @COLOR, @ID_PROPIETARIO);
END



-- Procedimiento para modificar un veh�culo
CREATE PROCEDURE ModificarVehiculo
    @Placa VARCHAR(10),
    @Valor DECIMAL(18, 2),
    @A�o INT,
    @Cilindraje INT,
    @Modelo VARCHAR(50),
    @Color VARCHAR(50),
    @ID_Propietario INT
AS
BEGIN
    UPDATE Vehiculo
    SET 
        Valor = @Valor,
        A�o = @A�o,
        Cilindraje = @Cilindraje,
        Modelo = @Modelo,
        Color = @Color,
        ID_Propietario = @ID_Propietario
    WHERE Placa = @Placa;
END



-- Procedimiento para eliminar un veh�culo
CREATE PROCEDURE EliminarVehiculo
    @PLACA VARCHAR(8)
AS
BEGIN
    DELETE FROM VEHICULO
    WHERE PLACA = @PLACA;
END



-- Procedimiento para buscar un veh�culo por su placa
CREATE PROCEDURE BuscarVehiculoPorPlaca
    @PLACA VARCHAR(8)
AS
BEGIN
    SELECT V.PLACA, V.VALOR, V.A�O, V.CILINDRAJE, V.MODELO, V.COLOR, P.DNI, P.NOMBRES, P.APELLIDOS, P.CORREO, P.TELEFONO, P.DIRECCION
    FROM VEHICULO V
    INNER JOIN PROPIETARIO P ON V.ID_PROPIETARIO = P.ID
    WHERE V.PLACA = @PLACA;
END




-- Procedimiento para verificar si el DNI del propietario Existe
CREATE PROCEDURE VerificarDNI
    @DNI VARCHAR(10)
AS
BEGIN
    -- Seleccionar los datos del propietario
    SELECT PROPIETARIO.DNI, PROPIETARIO.NOMBRES, PROPIETARIO.APELLIDOS, PROPIETARIO.CORREO, DEUDA.TOTAL
    FROM PROPIETARIO
	JOIN VEHICULO ON PROPIETARIO.ID = VEHICULO.ID_PROPIETARIO
	JOIN DEUDA ON VEHICULO.ID = DEUDA.ID_VEHICULO
    WHERE PROPIETARIO.DNI = @DNI
END;






CREATE TABLE DEUDA (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TOTAL DECIMAL(10,2),
    ID_VEHICULO INT FOREIGN KEY REFERENCES VEHICULO(ID)
);



CREATE PROCEDURE CalcularDeudaVehicular
    @PLACA VARCHAR(8)
AS
BEGIN
    DECLARE @VALOR DECIMAL(10,2);
    DECLARE @CILINDRAJE INT;
    DECLARE @TOTAL DECIMAL(10,2);
    DECLARE @ID_VEHICULO INT;

    SELECT @VALOR = VALOR, @CILINDRAJE = CILINDRAJE, @ID_VEHICULO = ID
    FROM VEHICULO
    WHERE PLACA = @PLACA;

    SET @TOTAL = (@VALOR * 0.015) + (@CILINDRAJE * 0.15);

    INSERT INTO DEUDA (TOTAL, ID_VEHICULO)
    VALUES (@TOTAL, @ID_VEHICULO);
END;







