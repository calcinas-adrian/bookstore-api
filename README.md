# Librería - Backend (API)

Este es el backend de la aplicación **Librería**, un sistema de gestión de tienda en línea desarrollado con **.NET Core 8**. Sigue una arquitectura por capas (n‑layered) para separar responsabilidades y facilitar el mantenimiento.

> **Importante**: Este backend expone una API REST que es consumida por el [frontend Angular](https://github.com/calcinas-adrian/bookstore-web). Asegúrate de tener ambos proyectos en ejecución para el correcto funcionamiento.

---

## Requisitos previos

- **.NET 8 SDK** ([Descargar](https://dotnet.microsoft.com/download))
- **Docker** y **Docker Compose** (para la base de datos SQL Server)
- Un cliente de base de datos (opcional, para ejecutar scripts)

---

## Pasos para levantar el backend

### 1. Clonar el repositorio

```bash
git clone https://github.com/calcinas-adrian/bookstore-api
cd bookstore-api
```

### 2. Iniciar la base de datos con Docker

El proyecto usa SQL Server. En la carpeta `db/` se encuentra un archivo `docker-compose.yml` que levanta un contenedor con SQL Server.

```bash
cd db
docker-compose up -d
```

Esto iniciará un contenedor con:

- **Puerto**: `1433`
- **Base de datos**: `Libreria`
- **Usuario**: `sa`
- **Contraseña**: `Sinclave1!` (definida en el `docker-compose.yml`)

### 3. Aplicar el esquema de la base de datos

Ejecuta el script `db.sql` (también en la carpeta `db/`) para crear las tablas y cargar datos de ejemplo. Puedes hacerlo con cualquier herramienta que se conecte a SQL Server (por ejemplo, Azure Data Studio, SSMS, o usando `sqlcmd`).

### 4. Configurar la cadena de conexión

La cadena de conexión ya está configurada en `Libreria.PresentationLayer/appsettings.json` con los valores del contenedor Docker. Si cambiaste la contraseña o el puerto, actualiza el valor de `ConnectionStrings:ConnectionString`.

```json
"ConnectionStrings": {
  "ConnectionString": "Server=localhost,1433;Database=Libreria;User Id=sa;Password=Sinclave1!;Encrypt=False;"
}
```

### 5. Restaurar dependencias y compilar

Desde la raíz del proyecto, ejecuta:

```bash
dotnet restore
dotnet build
```

### 6. Ejecutar la API

```bash
dotnet run --project Libreria.PresentationLayer
```

La API estará disponible en:

- **HTTP**: `http://localhost:5210`
- **HTTPS**: `https://localhost:7260` (si está configurado)

Puedes probar los endpoints visitando `http://localhost:5210/swagger` en tu navegador.

---

## 🗂️ Estructura del proyecto

El proyecto sigue una arquitectura de **n capas**:

```
Libreria.sln
├── Libreria.Models               # Entidades de dominio (POCOs)
├── Libreria.DataAccessLayer      # Repositorios, contexto de EF Core
├── Libreria.BusinessLogicLayer   # Servicios con la lógica de negocio
└── Libreria.PresentationLayer    # Controladores API (capa de presentación)
```

### Capas

- **Presentation Layer**: Controladores que reciben peticiones HTTP y devuelven respuestas JSON.
- **Business Logic Layer**: Servicios que contienen las reglas de negocio y orquestan las operaciones.
- **Data Access Layer**: Repositorios y contexto de Entity Framework Core para la persistencia.

---

## 🔌 Endpoints principales

La API expone los siguientes controladores (todos bajo el prefijo `/api/`):

| Controlador                                                | Descripción                                   |
| ---------------------------------------------------------- | --------------------------------------------- |
| `Carrito`                                                  | Gestión de carritos de compra                 |
| `Categorium`                                               | Categorías de productos                       |
| `Compra`                                                   | Compras y su historial                        |
| `Cupon`                                                    | Cupones de descuento                          |
| `DetalleCarrito`                                           | Detalles del carrito                          |
| `DetalleCompra`                                            | Detalles de compras                           |
| `Productos`                                                | CRUD de productos y búsquedas                 |
| `Promocion`                                                | Promociones y ofertas                         |
| `Proveedor`                                                | Proveedores de productos                      |
| `Usuario`                                                  | Autenticación, registro y gestión de usuarios |
| ...y otros para entidades como `Envio`, `Inventario`, etc. |

> Para más detalles, consulta la documentación Swagger una vez que el servidor esté corriendo.

---

## 📦 Tecnologías utilizadas

- **.NET 8** y **C#**
- **Entity Framework Core 8** (ORM)
- **SQL Server** (base de datos)
- **Docker** (para la base de datos)
- **Swagger/OpenAPI** (documentación interactiva)

---

## 🔗 Relación con el frontend

Este backend está diseñado para ser consumido por el frontend Angular (disponible en [libreria-frontend](https://github.com/calcinas-adrian/bookstore-web)). Asegúrate de que la URL base del frontend apunte a `http://localhost:5210/api` (configurado en `environments.ts` del frontend).

---

## 🤝 Contribuciones

Si deseas contribuir, por favor abre un issue o envía un pull request. Asegúrate de seguir las convenciones de código y de probar tus cambios.

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## ✉️ Contacto

Para dudas o sugerencias, puedes contactar al mantenedor del proyecto o abrir un issue en GitHub.

---

**¡Gracias por usar Librería!**

---

![Diagrama ERD](db/ERD_Libreria.png)
