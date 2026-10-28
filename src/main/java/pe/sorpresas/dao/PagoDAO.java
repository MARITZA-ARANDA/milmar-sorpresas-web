
package pe.sorpresas.dao;

import pe.sorpresas.entidades.Pago;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PagoDAO {

    public boolean registrar(Pago pago) throws SQLException {

        String sql = "INSERT INTO pago "
                + "(id_pedido, monto, metodo_pago, estado_pago, "
                + "numero_operacion, observacion) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, pago.getIdPedido());
            ps.setBigDecimal(2, pago.getMonto());
            ps.setString(3, pago.getMetodoPago());
            ps.setString(4, pago.getEstadoPago());
            ps.setString(5, pago.getNumeroOperacion());
            ps.setString(6, pago.getObservacion());

            return ps.executeUpdate() > 0;
        }
    }

    public List<Pago> listar() throws SQLException {

        List<Pago> lista = new ArrayList<>();

        String sql = "SELECT id_pago, id_pedido, fecha_pago, monto, "
                + "metodo_pago, estado_pago, numero_operacion, observacion "
                + "FROM pago ORDER BY id_pago DESC";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Pago pago = new Pago();

                pago.setIdPago(rs.getInt("id_pago"));
                pago.setIdPedido(rs.getInt("id_pedido"));
                pago.setFechaPago(rs.getTimestamp("fecha_pago"));
                pago.setMonto(rs.getBigDecimal("monto"));
                pago.setMetodoPago(rs.getString("metodo_pago"));
                pago.setEstadoPago(rs.getString("estado_pago"));
                pago.setNumeroOperacion(
                        rs.getString("numero_operacion"));
                pago.setObservacion(rs.getString("observacion"));

                lista.add(pago);
            }
        }

        return lista;
    }

    public boolean actualizarEstado(int idPago, String estado)
            throws SQLException {

        String sql = "UPDATE pago SET estado_pago = ? "
                + "WHERE id_pago = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estado);
            ps.setInt(2, idPago);

            return ps.executeUpdate() > 0;
        }
    }
}
