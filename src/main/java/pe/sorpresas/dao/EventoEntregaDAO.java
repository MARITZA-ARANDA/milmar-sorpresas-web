
package pe.sorpresas.dao;

import pe.sorpresas.entidades.EventoEntrega;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EventoEntregaDAO {

    public List<EventoEntrega> listar() throws SQLException {
        List<EventoEntrega> lista = new ArrayList<>();

        String sql = "SELECT id_evento, id_pedido, tipo_celebracion, "
                + "nombre_destinatario, fecha_entrega, hora_entrega, "
                + "direccion_entrega, referencia_entrega, estado_entrega "
                + "FROM evento_entrega ORDER BY fecha_entrega DESC, "
                + "hora_entrega DESC";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                EventoEntrega e = new EventoEntrega();

                e.setIdEvento(rs.getInt("id_evento"));
                e.setIdPedido(rs.getInt("id_pedido"));
                e.setTipoCelebracion(rs.getString("tipo_celebracion"));
                e.setNombreDestinatario(rs.getString("nombre_destinatario"));
                e.setFechaEntrega(rs.getDate("fecha_entrega"));
                e.setHoraEntrega(rs.getTime("hora_entrega"));
                e.setDireccionEntrega(rs.getString("direccion_entrega"));
                e.setReferenciaEntrega(rs.getString("referencia_entrega"));
                e.setEstadoEntrega(rs.getString("estado_entrega"));

                lista.add(e);
            }
        }

        return lista;
    }

    public boolean registrar(EventoEntrega e) throws SQLException {
        String sql = "INSERT INTO evento_entrega "
                + "(id_pedido, tipo_celebracion, nombre_destinatario, "
                + "fecha_entrega, hora_entrega, direccion_entrega, "
                + "referencia_entrega, estado_entrega) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, e.getIdPedido());
            ps.setString(2, e.getTipoCelebracion());
            ps.setString(3, e.getNombreDestinatario());
            ps.setDate(4, e.getFechaEntrega());
            ps.setTime(5, e.getHoraEntrega());
            ps.setString(6, e.getDireccionEntrega());
            ps.setString(7, e.getReferenciaEntrega());
            ps.setString(8, e.getEstadoEntrega());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean actualizarEstado(int idEvento, String estado)
            throws SQLException {

        String sql = "UPDATE evento_entrega "
                + "SET estado_entrega = ? WHERE id_evento = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estado);
            ps.setInt(2, idEvento);

            return ps.executeUpdate() > 0;
        }
    }
}
