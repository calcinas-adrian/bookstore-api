IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Libreria')
    CREATE DATABASE Libreria;
GO

USE Libreria;
GO

-- 1. Tabla Rol
CREATE TABLE
    Rol (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        NombreRol NVARCHAR (50) NOT NULL UNIQUE,
        Descripcion NVARCHAR (255)
    );

-- 2. Tabla Usuario
CREATE TABLE
    Usuario (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        NombreUsuario NVARCHAR (100) NOT NULL,
        CorreoElectronico NVARCHAR (100) NOT NULL UNIQUE,
        Contrasena NVARCHAR (255) NOT NULL, -- Almacenar hash de contraseña
        RolID INT NOT NULL,
        FechaRegistro DATE NOT NULL,
        Telefono NVARCHAR (15),
        Estado BIT DEFAULT 1, -- Activo/Inactivo
        CONSTRAINT FK_Usuario_Rol FOREIGN KEY (RolID) REFERENCES Rol (Id)
    );

-- 3. Tabla Categoria (géneros literarios)
CREATE TABLE
    Categoria (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        NombreCategoria NVARCHAR (100) NOT NULL,
        Descripcion NVARCHAR (255)
    );

-- 4. Tabla Proveedor (editoriales / distribuidoras)
CREATE TABLE
    Proveedor (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        NombreProveedor NVARCHAR (150),
        Telefono NVARCHAR (15),
        CorreoElectronico NVARCHAR (100),
        Direccion NVARCHAR (255)
    );

-- 5. Tabla Sucursal
CREATE TABLE
    Sucursal (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        NombreSucursal NVARCHAR (100) NOT NULL,
        Direccion NVARCHAR (255)
    );

-- 6. Tabla Producto (libros)
CREATE TABLE
    Producto (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        NombreProducto NVARCHAR (100) NOT NULL,
        Descripcion NVARCHAR (255),
        Precio DECIMAL(10, 2) NOT NULL,
        CantidadStock INT NOT NULL,
        CategoriaID INT NOT NULL,
        FechaIngreso DATE NOT NULL,
        ProveedorID INT NOT NULL,
        Autor NVARCHAR (150),
        ISBN NVARCHAR (20),
        Editorial NVARCHAR (150),
        AnioPublicacion INT,
        CONSTRAINT FK_Producto_Categoria FOREIGN KEY (CategoriaID) REFERENCES Categoria (Id),
        CONSTRAINT FK_Producto_Proveedor FOREIGN KEY (ProveedorID) REFERENCES Proveedor (Id)
    );

-- 7. Tabla Carrito
CREATE TABLE
    Carrito (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        UsuarioID INT NOT NULL,
        FechaCreacion DATE NOT NULL,
        EstadoCarrito NVARCHAR (50) NOT NULL,
        CONSTRAINT FK_Carrito_Usuario FOREIGN KEY (UsuarioID) REFERENCES Usuario (Id)
    );

-- 8. Tabla DetalleCarrito
CREATE TABLE
    DetalleCarrito (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        CarritoID INT NOT NULL,
        ProductoID INT NOT NULL,
        Cantidad INT NOT NULL,
        PrecioUnitario DECIMAL(10, 2) NOT NULL,
        CONSTRAINT FK_DetalleCarrito_Carrito FOREIGN KEY (CarritoID) REFERENCES Carrito (Id),
        CONSTRAINT FK_DetalleCarrito_Producto FOREIGN KEY (ProductoID) REFERENCES Producto (Id)
    );

-- 9. Tabla Compra
CREATE TABLE
    Compra (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        UsuarioID INT NOT NULL,
        FechaCompra DATE NOT NULL,
        TotalCompra DECIMAL(10, 2) NOT NULL,
        Estado NVARCHAR (50) NOT NULL,
        CONSTRAINT FK_Compra_Usuario FOREIGN KEY (UsuarioID) REFERENCES Usuario (Id)
    );

-- 10. Tabla DetalleCompra
CREATE TABLE
    DetalleCompra (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        CompraID INT NOT NULL,
        ProductoID INT NOT NULL,
        Cantidad INT NOT NULL,
        PrecioUnitario DECIMAL(10, 2) NOT NULL,
        Subtotal DECIMAL(10, 2) NOT NULL,
        CONSTRAINT FK_DetalleCompra_Compra FOREIGN KEY (CompraID) REFERENCES Compra (Id),
        CONSTRAINT FK_DetalleCompra_Producto FOREIGN KEY (ProductoID) REFERENCES Producto (Id)
    );

-- 11. Tabla Cupon
CREATE TABLE
    Cupon (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        CodigoCupon NVARCHAR (50) NOT NULL,
        Descripcion NVARCHAR (255),
        Descuento DECIMAL(5, 2) NOT NULL,
        FechaExpiracion DATE NOT NULL,
        Estado NVARCHAR (50) NOT NULL
    );

-- 12. Tabla Envio
CREATE TABLE
    Envio (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        CompraID INT NOT NULL,
        SucursalID INT NOT NULL,
        FechaEnvio DATE NOT NULL,
        EstadoEnvio NVARCHAR (50) NOT NULL,
        CONSTRAINT FK_Envio_Compra FOREIGN KEY (CompraID) REFERENCES Compra (Id),
        CONSTRAINT FK_Envio_Sucursal FOREIGN KEY (SucursalID) REFERENCES Sucursal (Id)
    );

-- 13. Tabla Inventario
CREATE TABLE
    Inventario (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        ProductoID INT NOT NULL,
        CantidadEntrante INT NOT NULL,
        FechaEntrada DATE NOT NULL,
        ProveedorID INT NOT NULL,
        CONSTRAINT FK_Inventario_Producto FOREIGN KEY (ProductoID) REFERENCES Producto (Id),
        CONSTRAINT FK_Inventario_Proveedor FOREIGN KEY (ProveedorID) REFERENCES Proveedor (Id)
    );

-- 14. Tabla Promocion
CREATE TABLE
    Promocion (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        NombrePromocion NVARCHAR (100) NOT NULL,
        Descripcion NVARCHAR (255),
        FechaInicio DATE NOT NULL,
        FechaFin DATE NOT NULL,
        Descuento DECIMAL(5, 2) NOT NULL,
        ProductoID INT NOT NULL,
        CONSTRAINT FK_Promocion_Producto FOREIGN KEY (ProductoID) REFERENCES Producto (Id)
    );

-- 15. Tabla PedidoProveedor
CREATE TABLE
    PedidoProveedor (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        ProveedorID INT NOT NULL,
        FechaPedido DATE NOT NULL,
        EstadoPedido NVARCHAR (50) NOT NULL,
        TotalPedido DECIMAL(10, 2) NOT NULL,
        CONSTRAINT FK_PedidoProveedor_Proveedor FOREIGN KEY (ProveedorID) REFERENCES Proveedor (Id)
    );

-- 16. Tabla DetallePedidoProveedor
CREATE TABLE
    DetallePedidoProveedor (
        Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        PedidoProveedorID INT NOT NULL,
        ProductoID INT NOT NULL,
        Cantidad INT NOT NULL,
        PrecioUnitario DECIMAL(10, 2) NOT NULL,
        Subtotal DECIMAL(10, 2) NOT NULL,
        CONSTRAINT FK_DetallePedidoProveedor_Pedido FOREIGN KEY (PedidoProveedorID) REFERENCES PedidoProveedor (Id),
        CONSTRAINT FK_DetallePedidoProveedor_Producto FOREIGN KEY (ProductoID) REFERENCES Producto (Id)
    );

-- DATA
INSERT INTO
    Rol (NombreRol, Descripcion)
VALUES
    (
        'Administrador',
        'Gestiona todos los aspectos del sistema'
    ),
    ('Cliente', 'Usuario que realiza compras'),
    (
        'Proveedor',
        'Usuario que representa a una editorial o distribuidora'
    );

INSERT INTO
    Usuario (
        NombreUsuario,
        CorreoElectronico,
        Contrasena,
        RolID,
        FechaRegistro,
        Telefono,
        Estado
    )
VALUES
    (
        'admin',
        'admin@libreria.com',
        'hashed_password_1',
        1,
        '2023-01-10',
        '1140010001',
        1
    ),
    (
        'ana.gomez',
        'ana.gomez@correo.com',
        'hashed_password_2',
        2,
        '2023-03-15',
        '1140021234',
        1
    ),
    (
        'carlos.fernandez',
        'carlos.fernandez@correo.com',
        'hashed_password_3',
        2,
        '2023-04-02',
        '1140035678',
        1
    ),
    (
        'lucia.martinez',
        'lucia.martinez@correo.com',
        'hashed_password_4',
        2,
        '2023-05-20',
        '1140042468',
        1
    ),
    (
        'diego.rodriguez',
        'diego.rodriguez@correo.com',
        'hashed_password_5',
        2,
        '2023-06-11',
        '1140051357',
        1
    ),
    (
        'valentina.lopez',
        'valentina.lopez@correo.com',
        'hashed_password_6',
        2,
        '2023-07-30',
        '1140069876',
        1
    ),
    (
        'martin.sanchez',
        'martin.sanchez@correo.com',
        'hashed_password_7',
        2,
        '2023-09-05',
        '1140076543',
        0
    ),
    (
        'sofia.torres',
        'sofia.torres@correo.com',
        'hashed_password_8',
        2,
        '2023-10-18',
        '1140083210',
        1
    ),
    (
        'contacto.penguin',
        'contacto@penguinrandomhouse.com.ar',
        'hashed_password_9',
        3,
        '2023-02-01',
        '1143211000',
        1
    ),
    (
        'contacto.planeta',
        'contacto@planetadelibros.com.ar',
        'hashed_password_10',
        3,
        '2023-02-15',
        '1143222000',
        1
    );

INSERT INTO
    Categoria (NombreCategoria, Descripcion)
VALUES
    (
        'Ficción',
        'Novelas y relatos de ficción literaria y narrativa contemporánea'
    ),
    (
        'No Ficción',
        'Ensayos, divulgación y textos basados en hechos reales'
    ),
    (
        'Infantil y Juvenil',
        'Libros dirigidos a lectores niños y adolescentes'
    ),
    (
        'Ciencia Ficción y Fantasía',
        'Mundos imaginarios, futuros especulativos y universos fantásticos'
    ),
    (
        'Académico y Técnico',
        'Libros de texto, manuales técnicos y bibliografía especializada'
    ),
    (
        'Cómics y Novela Gráfica',
        'Historietas y narrativa secuencial ilustrada'
    ),
    ('Poesía', 'Poemarios y antologías líricas'),
    (
        'Autoayuda y Desarrollo Personal',
        'Libros de crecimiento personal, hábitos y bienestar'
    );

INSERT INTO
    Proveedor (
        NombreProveedor,
        Telefono,
        CorreoElectronico,
        Direccion
    )
VALUES
    (
        'Penguin Random House Grupo Editorial',
        '1143211000',
        'distribucion@penguinrandomhouse.com.ar',
        'Av. Corrientes 1500, CABA'
    ),
    (
        'Editorial Planeta',
        '1143222000',
        'pedidos@planetadelibros.com.ar',
        'Av. Independencia 1682, CABA'
    ),
    (
        'Grupo SM',
        '1143233000',
        'contacto@grupo-sm.com.ar',
        'Av. Callao 850, CABA'
    ),
    (
        'HarperCollins Ibérica',
        '34914234000',
        'distribucion@harpercollinsiberica.com',
        'Núñez de Balboa 56, Madrid'
    ),
    (
        'Editorial Anagrama',
        '34935523400',
        'pedidos@anagrama-ed.es',
        'Pau Claris 172, Barcelona'
    );

INSERT INTO
    Sucursal (NombreSucursal, Direccion)
VALUES
    ('Sucursal Recoleta', 'Av. Callao 1500, CABA'),
    ('Sucursal Palermo', 'Av. Santa Fe 3200, CABA'),
    ('Sucursal Belgrano', 'Av. Cabildo 2100, CABA');

INSERT INTO
    Producto (
        NombreProducto,
        Descripcion,
        Precio,
        CantidadStock,
        CategoriaID,
        FechaIngreso,
        ProveedorID,
        Autor,
        ISBN,
        Editorial,
        AnioPublicacion
    )
VALUES
    (
        'Cien años de soledad',
        'Obra cumbre del realismo mágico que narra siete generaciones de la familia Buendía en el pueblo de Macondo.',
        18.50, 40, 1, '2024-01-05', 1,
        'Gabriel García Márquez', '9781000000016', 'Editorial Sudamericana', 1967
    ),
    (
        'Rayuela',
        'Novela experimental que puede leerse en múltiples órdenes, ícono de la literatura latinoamericana.',
        16.75, 25, 1, '2024-01-10', 2,
        'Julio Cortázar', '9781000000023', 'Alfaguara', 1963
    ),
    (
        '1984',
        'Distopía totalitaria que retrata la vigilancia masiva y la manipulación del lenguaje y la verdad.',
        14.99, 60, 1, '2024-01-12', 1,
        'George Orwell', '9781000000030', 'Debolsillo', 1949
    ),
    (
        'El Principito',
        'Fábula poética sobre la amistad, la pérdida de la inocencia y la mirada de un niño ante el mundo.',
        12.50, 80, 3, '2024-01-15', 3,
        'Antoine de Saint-Exupéry', '9781000000047', 'Salamandra', 1943
    ),
    (
        'Harry Potter y la piedra filosofal',
        'Primer libro de la saga sobre un joven mago que descubre su destino en el colegio Hogwarts.',
        22.99, 55, 3, '2024-01-18', 3,
        'J.K. Rowling', '9781000000054', 'Salamandra', 1997
    ),
    (
        'El nombre del viento',
        'Primer volumen de la Crónica del Asesino de Reyes, narrado por el legendario Kvothe.',
        24.90, 30, 4, '2024-01-20', 4,
        'Patrick Rothfuss', '9781000000061', 'Plaza & Janés', 2007
    ),
    (
        'Fundación',
        'Saga de ciencia ficción sobre el colapso y renacimiento de un imperio galáctico.',
        15.90, 35, 4, '2024-01-22', 1,
        'Isaac Asimov', '9781000000078', 'Debolsillo', 1951
    ),
    (
        'Sapiens: De animales a dioses',
        'Ensayo sobre la historia de la humanidad desde la Edad de Piedra hasta la actualidad.',
        26.50, 45, 2, '2024-01-25', 2,
        'Yuval Noah Harari', '9781000000085', 'Debate', 2011
    ),
    (
        'Breves respuestas a las grandes preguntas',
        'Último libro del físico, con reflexiones sobre el origen del universo y el futuro de la humanidad.',
        21.00, 20, 5, '2024-01-28', 4,
        'Stephen Hawking', '9781000000092', 'Crítica', 2018
    ),
    (
        'Cómo ganar amigos e influir sobre las personas',
        'Clásico del desarrollo personal sobre relaciones humanas y comunicación efectiva.',
        17.25, 50, 8, '2024-02-01', 1,
        'Dale Carnegie', '9781000000108', 'Editorial Sudamericana', 1936
    ),
    (
        'El poder del ahora',
        'Guía espiritual sobre vivir en el presente y liberarse del sufrimiento mental.',
        19.99, 38, 8, '2024-02-03', 5,
        'Eckhart Tolle', '9781000000115', 'Gaia Ediciones', 1997
    ),
    (
        'Maus',
        'Novela gráfica sobre el Holocausto narrada con animales antropomorfos, ganadora del Pulitzer.',
        23.75, 15, 6, '2024-02-05', 5,
        'Art Spiegelman', '9781000000122', 'Reservoir Books', 1991
    ),
    (
        'Watchmen',
        'Deconstrucción del género de superhéroes ambientada en una Guerra Fría alternativa.',
        28.00, 18, 6, '2024-02-08', 5,
        'Alan Moore', '9781000000139', 'ECC Ediciones', 1987
    ),
    (
        'Veinte poemas de amor y una canción desesperada',
        'Poemario juvenil que consagró a Neruda como una de las voces líricas más importantes en español.',
        13.40, 28, 7, '2024-02-10', 2,
        'Pablo Neruda', '9781000000146', 'Seix Barral', 1924
    ),
    (
        'Clean Code',
        'Guía práctica sobre buenas prácticas de programación y escritura de código mantenible.',
        34.99, 22, 5, '2024-02-12', 4,
        'Robert C. Martin', '9781000000153', 'Prentice Hall', 2008
    );

INSERT INTO
    Inventario (
        ProductoID,
        CantidadEntrante,
        FechaEntrada,
        ProveedorID
    )
VALUES
    (1, 20, '2024-01-05', 1),
    (2, 15, '2024-01-10', 2),
    (3, 30, '2024-01-12', 1),
    (4, 40, '2024-01-15', 3),
    (5, 25, '2024-01-18', 3),
    (6, 15, '2024-01-20', 4),
    (7, 20, '2024-01-22', 1),
    (8, 25, '2024-01-25', 2),
    (9, 10, '2024-01-28', 4),
    (10, 30, '2024-02-01', 1),
    (11, 20, '2024-02-03', 5),
    (12, 10, '2024-02-05', 5),
    (13, 12, '2024-02-08', 5),
    (14, 15, '2024-02-10', 2),
    (15, 12, '2024-02-12', 4);

INSERT INTO
    Carrito (UsuarioID, FechaCreacion, EstadoCarrito)
VALUES
    (2, '2024-03-01', 'Activo'),
    (3, '2024-03-02', 'Finalizado'),
    (4, '2024-03-03', 'Activo'),
    (5, '2024-03-04', 'Finalizado');

INSERT INTO
    DetalleCarrito (CarritoID, ProductoID, Cantidad, PrecioUnitario)
VALUES
    (1, 1, 1, 18.50),
    (1, 4, 2, 12.50),
    (2, 3, 1, 14.99),
    (2, 8, 1, 26.50),
    (3, 6, 1, 24.90),
    (4, 10, 1, 17.25),
    (4, 11, 1, 19.99);

INSERT INTO
    Compra (UsuarioID, FechaCompra, TotalCompra, Estado)
VALUES
    (3, '2024-03-02', 41.49, 'Completada'),
    (5, '2024-03-04', 37.24, 'Completada'),
    (2, '2024-03-10', 43.50, 'Completada'),
    (6, '2024-03-15', 13.40, 'Pendiente');

INSERT INTO
    DetalleCompra (
        CompraID,
        ProductoID,
        Cantidad,
        PrecioUnitario,
        Subtotal
    )
VALUES
    (1, 3, 1, 14.99, 14.99),
    (1, 8, 1, 26.50, 26.50),
    (2, 10, 1, 17.25, 17.25),
    (2, 11, 1, 19.99, 19.99),
    (3, 1, 1, 18.50, 18.50),
    (3, 4, 2, 12.50, 25.00),
    (4, 14, 1, 13.40, 13.40);

INSERT INTO
    Cupon (
        CodigoCupon,
        Descripcion,
        Descuento,
        FechaExpiracion,
        Estado
    )
VALUES
    (
        'LECTOR10',
        '10% de descuento para nuevos lectores registrados',
        10.00,
        '2024-12-31',
        'Activo'
    ),
    (
        'ENVIOGRATIS',
        'Envío gratis en compras mayores a $30',
        0.00,
        '2024-12-31',
        'Activo'
    ),
    (
        'BLACKBOOKS',
        '20% de descuento por Black Friday literario',
        20.00,
        '2024-11-30',
        'Inactivo'
    );

INSERT INTO
    Envio (CompraID, SucursalID, FechaEnvio, EstadoEnvio)
VALUES
    (1, 1, '2024-03-03', 'Entregado'),
    (2, 2, '2024-03-05', 'Entregado'),
    (3, 3, '2024-03-11', 'En tránsito'),
    (4, 1, '2024-03-16', 'Preparando');

INSERT INTO
    Promocion (
        NombrePromocion,
        Descripcion,
        FechaInicio,
        FechaFin,
        Descuento,
        ProductoID
    )
VALUES
    (
        'Semana del Libro',
        'Descuento especial en clásicos de ficción por el Día Internacional del Libro',
        '2024-04-15',
        '2024-04-23',
        15.00,
        1
    ),
    (
        'Vuelta al Cole',
        'Descuento en libros académicos y técnicos',
        '2024-02-20',
        '2024-03-10',
        10.00,
        15
    ),
    (
        'Fantasía y Magia',
        'Promoción especial en sagas de fantasía',
        '2024-07-01',
        '2024-07-31',
        12.00,
        5
    );

INSERT INTO
    PedidoProveedor (
        ProveedorID,
        FechaPedido,
        EstadoPedido,
        TotalPedido
    )
VALUES
    (1, '2024-01-02', 'Completado', 1020.00),
    (2, '2024-01-08', 'Completado', 820.00),
    (3, '2024-01-14', 'Pendiente', 1220.00),
    (4, '2024-01-20', 'Completado', 675.00),
    (5, '2024-01-25', 'Pendiente', 710.00);

INSERT INTO
    DetallePedidoProveedor (
        PedidoProveedorID,
        ProductoID,
        Cantidad,
        PrecioUnitario,
        Subtotal
    )
VALUES
    (1, 1, 50, 10.00, 500.00),
    (1, 7, 40, 13.00, 520.00),
    (2, 2, 30, 14.00, 420.00),
    (2, 8, 20, 20.00, 400.00),
    (3, 4, 60, 9.00, 540.00),
    (3, 5, 40, 17.00, 680.00),
    (4, 6, 25, 18.00, 450.00),
    (4, 9, 15, 15.00, 225.00),
    (5, 11, 30, 13.00, 390.00),
    (5, 12, 20, 16.00, 320.00);
