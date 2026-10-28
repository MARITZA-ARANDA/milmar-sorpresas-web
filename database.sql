CREATE DATABASE IF NOT EXISTS sorpresas_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sorpresas_db;

CREATE TABLE IF NOT EXISTS clientes (
 id_cliente INT AUTO_INCREMENT PRIMARY KEY,
 nombres VARCHAR(80) NOT NULL,
 apellidos VARCHAR(80) NOT NULL,
 documento VARCHAR(20) NOT NULL UNIQUE,
 telefono VARCHAR(25),
 correo VARCHAR(120)
);

CREATE TABLE IF NOT EXISTS servicios (
 id_servicio INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 descripcion VARCHAR(255),
 precio DECIMAL(10,2) NOT NULL DEFAULT 0,
 activo TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS pedidos (
 id_pedido INT AUTO_INCREMENT PRIMARY KEY,
 id_cliente INT NOT NULL,
 id_servicio INT NOT NULL,
 cantidad INT NOT NULL DEFAULT 1,
 fecha_evento DATE NOT NULL,
 hora_evento TIME NOT NULL,
 direccion VARCHAR(255) NOT NULL,
 observaciones TEXT,
 total DECIMAL(10,2) NOT NULL,
 estado ENUM('Pendiente','Confirmado','Preparado','Entregado','Cancelado') NOT NULL DEFAULT 'Pendiente',
 creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
 CONSTRAINT fk_pedido_servicio FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
);

INSERT INTO servicios(nombre,descripcion,precio) SELECT 'Serenata','Servicio musical para evento',250.00
WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE nombre='Serenata');
INSERT INTO servicios(nombre,descripcion,precio) SELECT 'Desayuno sorpresa','Desayuno personalizado',85.00
WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE nombre='Desayuno sorpresa');
INSERT INTO servicios(nombre,descripcion,precio) SELECT 'Arreglo floral','Ramo de flores personalizado',100.00
WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE nombre='Arreglo floral');
INSERT INTO servicios(nombre,descripcion,precio) SELECT 'Decoración con globos','Decoración para celebración',150.00
WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE nombre='Decoración con globos');
INSERT INTO servicios(nombre,descripcion,precio) SELECT 'Caja de regalo','Caja personalizada de regalo',70.00
WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE nombre='Caja de regalo');
