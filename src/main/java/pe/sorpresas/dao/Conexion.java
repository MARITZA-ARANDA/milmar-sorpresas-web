


package pe.sorpresas.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL =
        "jdbc:mysql://localhost:3306/bd_milmar_sorpresas"
        + "?useSSL=false&serverTimezone=America/Lima"
        + "&allowPublicKeyRetrieval=true";

    private static final String USUARIO = "root";
    private static final String CLAVE = "";

    public static Connection obtenerConexion() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "No se encontró el controlador JDBC de MySQL.", e
            );
        }

        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }

    // Método alternativo para los DAO
    public static Connection getConnection() throws SQLException {
        return obtenerConexion();
    }

    // Probar conexión con MySQL
    public static void main(String[] args) {
        try (Connection conexion = obtenerConexion()) {
            System.out.println("Conexión exitosa con MySQL");
            System.out.println("Base de datos: " + conexion.getCatalog());
        } catch (SQLException e) {
            System.err.println("Error de conexión: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
