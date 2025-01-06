-- CREACIÓN DE ROLES
-- Super Administrador: Puede crear y eliminar bases de datos
CREATE ROLE 'SuperAdmin';
GRANT CREATE, DROP ON *.* TO 'SuperAdmin';

-- Administrador: Puede crear usuarios y procesos
CREATE ROLE 'Administrador';
GRANT CREATE USER, PROCESS ON *.* TO 'Administrador';

-- CRUD: Permite insertar, actualizar y eliminar datos
CREATE ROLE 'CRUD';
GRANT INSERT, UPDATE, DELETE ON *.* TO 'CRUD';

-- CRU: Permite insertar y actualizar, pero sin eliminar
CREATE ROLE 'CRU';
GRANT INSERT, UPDATE ON *.* TO 'CRU';

-- Solo Lectura: Permite realizar consultas a las tablas
CREATE ROLE 'SoloLectura';
GRANT SELECT ON *.* TO 'SoloLectura';

-- CREACIÓN DE USUARIOS
-- Usuario Super Administrador
CREATE USER 'superadmin'@'localhost' IDENTIFIED BY 'ContraseñaSeguraSuperAdmin!';
GRANT 'SuperAdmin' TO 'superadmin'@'localhost';

-- Usuario Administrador
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'ContraseñaSeguraAdmin!';
GRANT 'Administrador' TO 'admin'@'localhost';

-- Usuario CRUD
CREATE USER 'cruduser'@'localhost' IDENTIFIED BY 'ContraseñaSeguraCRUD!';
GRANT 'CRUD' TO 'cruduser'@'localhost';

-- Usuario CRU
CREATE USER 'cruuser'@'localhost' IDENTIFIED BY 'ContraseñaSeguraCRU!';
GRANT 'CRU' TO 'cruuser'@'localhost';

-- Usuario Solo Lectura
CREATE USER 'readuser'@'localhost' IDENTIFIED BY 'ContraseñaSeguraRead!';
GRANT 'SoloLectura' TO 'readuser'@'localhost';

-- Verificación de privilegios de los usuarios:
-- Usar el siguiente comando para verificar los privilegios
SHOW GRANTS FOR 'readuser'@'localhost';

CREATE DATABASE TriggerSS;
USE TriggerSS;

-- Tabla de empleados
CREATE TABLE Empleados (
    EmpID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Departamento VARCHAR(100),
    Salario DECIMAL(10,2)
);

-- Tabla de auditoría
CREATE TABLE Auditoria (
    AudID INT AUTO_INCREMENT PRIMARY KEY,
    Accion VARCHAR(10),  -- INSERT, UPDATE, DELETE
    EmpID INT,
    Nombre VARCHAR(100),
    Departamento VARCHAR(100),
    Salario DECIMAL(10,2),
    Fecha DATETIME
);


#1. Trigger para INSERT:
DELIMITER $$
CREATE TRIGGER AuditoriaInsert
AFTER INSERT ON Empleados
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('INSERT', NEW.EmpID, NEW.Nombre, NEW.Departamento, NEW.Salario, NOW());
END$$
DELIMITER ;

#2. Trigger para DELETE:
DELIMITER $$

CREATE TRIGGER AuditoriaDelete
AFTER DELETE ON Empleados
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('DELETE', OLD.EmpID, OLD.Nombre, OLD.Departamento, OLD.Salario, NOW());
END$$

DELIMITER ;

#3. Trigger para UPDATE:
DELIMITER $$

CREATE TRIGGER AuditoriaUpdate
AFTER UPDATE ON Empleados
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('UPDATE', OLD.EmpID, OLD.Nombre, OLD.Departamento, OLD.Salario, NOW());
END$$

DELIMITER ;


SELECT * FROM Auditoria;

#Christian Márquez

