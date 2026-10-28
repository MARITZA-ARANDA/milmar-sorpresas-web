
package pe.sorpresas.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import pe.sorpresas.dao.Conexion;

@WebServlet("/ExportarClientesServlet")
public class ExportarClientesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar que el usuario haya iniciado sesión
        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String sql = "SELECT id_cliente, tipo_documento, "
                + "nro_documento, nombres, apellidos, telefono, correo "
                + "FROM cliente ORDER BY id_cliente";

        try (Workbook libro = new XSSFWorkbook()) {

            Sheet hoja = libro.createSheet("Clientes");

            // Encabezados
            String[] encabezados = {
                "ID", "Tipo documento", "Nro. documento",
                "Nombres", "Apellidos", "Teléfono", "Correo"
            };

            Row filaEncabezado = hoja.createRow(0);

            for (int i = 0; i < encabezados.length; i++) {
                filaEncabezado.createCell(i)
                        .setCellValue(encabezados[i]);
            }

            // Consultar los clientes
            try (Connection con = Conexion.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                int numeroFila = 1;

                while (rs.next()) {
                    Row fila = hoja.createRow(numeroFila++);

                    fila.createCell(0)
                            .setCellValue(rs.getInt("id_cliente"));
                    fila.createCell(1)
                            .setCellValue(valor(rs, "tipo_documento"));
                    fila.createCell(2)
                            .setCellValue(valor(rs, "nro_documento"));
                    fila.createCell(3)
                            .setCellValue(valor(rs, "nombres"));
                    fila.createCell(4)
                            .setCellValue(valor(rs, "apellidos"));
                    fila.createCell(5)
                            .setCellValue(valor(rs, "telefono"));
                    fila.createCell(6)
                            .setCellValue(valor(rs, "correo"));
                }
            }

            // Ajustar el ancho de las columnas
            for (int i = 0; i < encabezados.length; i++) {
                hoja.autoSizeColumn(i);
            }

            // Preparar la descarga de Excel
            response.setContentType(
                    "application/vnd.openxmlformats-officedocument"
                    + ".spreadsheetml.sheet");

            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename=\"clientes_milmar.xlsx\"");

            libro.write(response.getOutputStream());
            response.flushBuffer();

        
} catch (SQLException e) {
    log("Error SQL al exportar clientes a Excel.", e);
    throw new ServletException(
            "Error al consultar los clientes para Excel.", e);
} catch (Exception e) {
    log("Error al generar el archivo Excel de clientes.", e);
    throw new ServletException(
            "No se pudo generar el archivo Excel de clientes.", e);
}

    }

    private String valor(ResultSet rs, String columna)
            throws SQLException {

        String dato = rs.getString(columna);
        return dato == null ? "" : dato;
    }
}
