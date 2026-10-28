
package pe.sorpresas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ReporteDAO {

    public int contarClientes() throws SQLException {
        String sql = "SELECT COUNT(*) FROM cliente";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int contarServiciosActivos() throws SQLException {
        String sql = "SELECT COUNT(*) FROM servicio WHERE estado = 'Activo'";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int contarPedidos() throws SQLException {
        String sql = "SELECT COUNT(*) FROM pedido";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public double obtenerIngresosPagados() throws SQLException {
        String sql = "SELECT COALESCE(SUM(monto), 0) "
                   + "FROM pago WHERE estado_pago = 'Pagado'";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    public int contarPagosPendientes() throws SQLException {
        String sql = "SELECT COUNT(*) FROM pago "
                   + "WHERE estado_pago = 'Pendiente'";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
