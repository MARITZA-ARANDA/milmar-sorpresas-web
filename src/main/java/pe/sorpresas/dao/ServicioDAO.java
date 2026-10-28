
package pe.sorpresas.dao;

import pe.sorpresas.entidades.Servicio;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServicioDAO {

    public List<Servicio> listar() throws SQLException {
        List<Servicio> lista = new ArrayList<>();

        String sql = "SELECT id_servicio, nombre_servicio, descripcion, "
                   + "precio_unitario, estado "
                   + "FROM servicio ORDER BY id_servicio DESC";

        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Servicio s = new Servicio();

                s.setIdServicio(rs.getInt("id_servicio"));
                s.setNombreServicio(rs.getString("nombre_servicio"));
                s.setDescripcion(rs.getString("descripcion"));
                s.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
                s.setEstado(rs.getString("estado"));

                lista.add(s);
            }
        }

        return lista;
    }

    public boolean registrar(Servicio s) throws SQLException {
        String sql = "INSERT INTO servicio "
                   + "(nombre_servicio, descripcion, precio_unitario, estado) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, s.getNombreServicio());
            ps.setString(2, s.getDescripcion());
            ps.setBigDecimal(3, s.getPrecioUnitario());
            ps.setString(4, s.getEstado());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean actualizar(Servicio s) throws SQLException {
        String sql = "UPDATE servicio SET nombre_servicio = ?, "
                   + "descripcion = ?, precio_unitario = ? "
                   + "WHERE id_servicio = ?";

        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, s.getNombreServicio());
            ps.setString(2, s.getDescripcion());
            ps.setBigDecimal(3, s.getPrecioUnitario());
            ps.setInt(4, s.getIdServicio());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean cambiarEstado(int id, String estado)
            throws SQLException {

        if (!"Activo".equals(estado) && !"Inactivo".equals(estado)) {
            throw new IllegalArgumentException("Estado no válido");
        }

        String sql = "UPDATE servicio SET estado = ? WHERE id_servicio = ?";

        try (Connection cn = Conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, estado);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;
        }
    }
}
