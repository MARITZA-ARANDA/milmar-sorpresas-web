


package pe.sorpresas.dao;

import pe.sorpresas.entidades.Pedido;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class PedidoDAO {

    // Listar todos los pedidos
    public List<Pedido> listar() throws SQLException {
        List<Pedido> lista = new ArrayList<>();

        String sql = "SELECT id_pedido, id_cliente, fecha_pedido, "
                + "monto_total, estado_pedido, estado_pago "
                + "FROM pedido ORDER BY id_pedido DESC";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Pedido p = new Pedido();
                p.setIdPedido(rs.getInt("id_pedido"));
                p.setIdCliente(rs.getInt("id_cliente"));
                p.setFechaPedido(rs.getTimestamp("fecha_pedido"));
                p.setMontoTotal(rs.getBigDecimal("monto_total"));
                p.setEstadoPedido(rs.getString("estado_pedido"));
                p.setEstadoPago(rs.getString("estado_pago"));
                lista.add(p);
            }
        }

        return lista;
    }

    // Listar servicios activos para el formulario
    public List<Map<String, Object>> listarServiciosActivos()
            throws SQLException {

        List<Map<String, Object>> lista = new ArrayList<>();

        String sql = "SELECT id_servicio, nombre_servicio, "
                + "precio_unitario FROM servicio "
                + "WHERE estado = 'Activo' ORDER BY nombre_servicio";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> servicio = new LinkedHashMap<>();
                servicio.put("idServicio", rs.getInt("id_servicio"));
                servicio.put("nombre", rs.getString("nombre_servicio"));
                servicio.put("precio", rs.getBigDecimal("precio_unitario"));
                lista.add(servicio);
            }
        }

        return lista;
    }

    // Registrar pedido y detalles en una sola transacción
    public int registrarConDetalles(
            int idCliente,
            int[] idsServicios,
            int[] cantidades) throws SQLException {

        if (idsServicios == null || cantidades == null
                || idsServicios.length == 0
                || idsServicios.length != cantidades.length) {
            throw new IllegalArgumentException(
                    "Agrega al menos un servicio con su cantidad.");
        }

        try (Connection con = Conexion.getConnection()) {
            boolean autocommitAnterior = con.getAutoCommit();
            con.setAutoCommit(false);

            try {
                // Verificar que el cliente exista
                String sqlCliente =
                        "SELECT id_cliente FROM cliente WHERE id_cliente = ?";

                try (PreparedStatement ps =
                             con.prepareStatement(sqlCliente)) {
                    ps.setInt(1, idCliente);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new IllegalArgumentException(
                                    "El cliente seleccionado no existe.");
                        }
                    }
                }

                // Crear cabecera del pedido
                String sqlPedido =
                        "INSERT INTO pedido "
                        + "(id_cliente, monto_total, estado_pedido, estado_pago) "
                        + "VALUES (?, 0.00, 'Pendiente', 'Pendiente')";

                int idPedido;

                try (PreparedStatement ps = con.prepareStatement(
                        sqlPedido, Statement.RETURN_GENERATED_KEYS)) {

                    ps.setInt(1, idCliente);
                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) {
                            throw new SQLException(
                                    "No se generó el ID del pedido.");
                        }
                        idPedido = rs.getInt(1);
                    }
                }

                BigDecimal total = BigDecimal.ZERO;

                String sqlServicio =
                        "SELECT precio_unitario FROM servicio "
                        + "WHERE id_servicio = ? AND estado = 'Activo'";

                String sqlDetalle =
                        "INSERT INTO detalle_pedido "
                        + "(id_pedido, id_servicio, cantidad, precio_venta) "
                        + "VALUES (?, ?, ?, ?)";

                for (int i = 0; i < idsServicios.length; i++) {
                    int idServicio = idsServicios[i];
                    int cantidad = cantidades[i];

                    if (idServicio <= 0 || cantidad <= 0) {
                        throw new IllegalArgumentException(
                                "Selecciona servicios y cantidades válidas.");
                    }

                    BigDecimal precio;

                    try (PreparedStatement ps =
                                 con.prepareStatement(sqlServicio)) {
                        ps.setInt(1, idServicio);

                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.next()) {
                                throw new IllegalArgumentException(
                                        "Un servicio no existe o está inactivo.");
                            }
                            precio = rs.getBigDecimal("precio_unitario");
                        }
                    }

                    // El precio se obtiene directamente de MySQL
                    BigDecimal subtotal = precio.multiply(
                            BigDecimal.valueOf(cantidad));

                    try (PreparedStatement ps =
                                 con.prepareStatement(sqlDetalle)) {
                        ps.setInt(1, idPedido);
                        ps.setInt(2, idServicio);
                        ps.setInt(3, cantidad);
                        ps.setBigDecimal(4, precio);
                        ps.executeUpdate();
                    }

                    total = total.add(subtotal);
                }

                // Actualizar el total de la cabecera
                String sqlTotal =
                        "UPDATE pedido SET monto_total = ? WHERE id_pedido = ?";

                try (PreparedStatement ps =
                             con.prepareStatement(sqlTotal)) {
                    ps.setBigDecimal(1, total);
                    ps.setInt(2, idPedido);
                    ps.executeUpdate();
                }

                con.commit();
                return idPedido;

            } catch (SQLException | RuntimeException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(autocommitAnterior);
            }
        }
    }

    // Actualizar estados sin alterar el detalle del pedido
    public boolean actualizarEstados(
            int idPedido,
            String estadoPedido,
            String estadoPago) throws SQLException {

        String sql = "UPDATE pedido SET estado_pedido = ?, "
                + "estado_pago = ? WHERE id_pedido = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estadoPedido);
            ps.setString(2, estadoPago);
            ps.setInt(3, idPedido);

            return ps.executeUpdate() > 0;
        }
    }
}
