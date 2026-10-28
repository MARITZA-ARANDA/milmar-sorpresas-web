PROTOTIPOS WEB - SERVICIOS DE SORPRESAS
Tecnología: NetBeans 25, JDK 17, Maven, Tomcat 10.1+, MySQL 8.

INSTALACIÓN
1. Abra MySQL/phpMyAdmin y ejecute completo el archivo database.sql.
2. En NetBeans: File > Open Project y seleccione la carpeta PrototiposSorpresas.
3. En src/main/java/pe/sorpresas/dao/Conexion.java configure usuario y contraseña de MySQL.
4. Configure Tomcat 10.1 o superior como servidor.
5. Clean and Build; luego Run.
6. Abra http://localhost:8080/PrototiposSorpresas/

PROTOTIPO 1: clientes: registrar, listar, buscar por documento, actualizar y eliminar.
PROTOTIPO 2: pedidos: seleccionar cliente y servicio, ingresar fecha/hora/dirección/cantidad,
calcular total, registrar y listar pedidos.

NOTA: Este es un prototipo académico inicial. No incluye pasarela de pagos ni envío automático a WhatsApp.
Si su servidor es Tomcat 9, se deben cambiar imports jakarta.servlet por javax.servlet y ajustar dependencias.
