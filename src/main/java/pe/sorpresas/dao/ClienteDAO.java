
package pe.sorpresas.dao;

import pe.sorpresas.entidades.Cliente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    public List<Cliente> listar() throws SQLException {
        List<Cliente> lista = new ArrayList<>();

        String sql = "SELECT id_cliente, nombres, apellidos, "
                + "tipo_documento, nro_documento, telefono, correo "
                + "FROM cliente ORDER BY id_cliente DESC";

        try (Connection con = new Conexion().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Cliente c = new Cliente(
                    rs.getInt("id_cliente"),
                    rs.getString("nombres"),
                    rs.getString("apellidos"),
                    rs.getString("tipo_documento"),
                    rs.getString("nro_documento"),
                    rs.getString("telefono"),
                    rs.getString("correo")
                );
                lista.add(c);
            }
        }
        return lista;
    }

    public boolean registrar(Cliente c) throws SQLException {
        String sql = "INSERT INTO cliente "
                + "(nombres, apellidos, tipo_documento, "
                + "nro_documento, telefono, correo) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = new Conexion().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getNombres());
            ps.setString(2, c.getApellidos());
            ps.setString(3, c.getTipoDocumento() == null
        ? null : c.getTipoDocumento().trim());
            ps.setString(4, c.getNroDocumento());
            ps.setString(5, c.getTelefono());

            if (c.getCorreo() == null || c.getCorreo().isBlank()) {
                ps.setNull(6, Types.VARCHAR);
            } else {
                ps.setString(6, c.getCorreo());
            }

            return ps.executeUpdate() > 0;
        }
    }

    public boolean eliminar(int id) throws SQLException {
        String sql = "DELETE FROM cliente WHERE id_cliente = ?";

        try (Connection con = new Conexion().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
    
public boolean actualizar(Cliente c) throws SQLException {
    String sql = "UPDATE cliente SET "
            + "nombres = ?, "
            + "apellidos = ?, "
            + "tipo_documento = ?, "
            + "nro_documento = ?, "
            + "telefono = ?, "
            + "correo = ? "
            + "WHERE id_cliente = ?";

    try (Connection con = new Conexion().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, c.getNombres());
        ps.setString(2, c.getApellidos());
        ps.setString(3, c.getTipoDocumento());
        ps.setString(4, c.getNroDocumento());
        ps.setString(5, c.getTelefono());

        if (c.getCorreo() == null || c.getCorreo().isBlank()) {
            ps.setNull(6, Types.VARCHAR);
        } else {
            ps.setString(6, c.getCorreo());
        }

        ps.setInt(7, c.getIdCliente());

        return ps.executeUpdate() > 0;
    }
}

}
