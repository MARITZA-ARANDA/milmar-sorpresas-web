

package pe.sorpresas.servlet;

import pe.sorpresas.dao.PedidoDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/pedidos")
public class PedidoServlet extends HttpServlet {

    private final PedidoDAO pedidoDAO = new PedidoDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            request.setAttribute("pedidos", pedidoDAO.listar());

            List<Map<String, Object>> servicios =
                    pedidoDAO.listarServiciosActivos();

            request.setAttribute("servicios", servicios);

            request.getRequestDispatcher("/pedidos.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "No se pudieron consultar los pedidos o servicios.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        try {
            if ("registrar".equals(accion)) {

                int idCliente = Integer.parseInt(
                        request.getParameter("idCliente"));

                String[] servicios = request.getParameterValues("idServicio");
                String[] cantidades = request.getParameterValues("cantidad");

                if (servicios == null || cantidades == null
                        || servicios.length == 0
                        || servicios.length != cantidades.length) {
                    throw new IllegalArgumentException(
                            "Agrega al menos un servicio y su cantidad.");
                }

                int[] idsServicios = new int[servicios.length];
                int[] cantidadesServicios = new int[cantidades.length];

                for (int i = 0; i < servicios.length; i++) {
                    idsServicios[i] = Integer.parseInt(servicios[i]);
                    cantidadesServicios[i] = Integer.parseInt(cantidades[i]);

                    if (idsServicios[i] <= 0
                            || cantidadesServicios[i] <= 0) {
                        throw new IllegalArgumentException(
                                "Selecciona servicios y cantidades válidas.");
                    }
                }

                if (idCliente <= 0) {
                    throw new IllegalArgumentException(
                            "Selecciona un cliente válido.");
                }

                int idPedido = pedidoDAO.registrarConDetalles(
                        idCliente, idsServicios, cantidadesServicios);

                redirigir(request, response,
                        "Pedido N.º " + idPedido + " registrado correctamente.");
                return;

            } else if ("actualizar".equals(accion)) {

                int idPedido = Integer.parseInt(
                        request.getParameter("idPedido"));

                String estadoPedido = request.getParameter("estadoPedido");
                String estadoPago = request.getParameter("estadoPago");

                if (!esEstadoPedidoValido(estadoPedido)
                        || !esEstadoPagoValido(estadoPago)) {
                    throw new IllegalArgumentException(
                            "Selecciona estados válidos.");
                }

                boolean actualizado = pedidoDAO.actualizarEstados(
                        idPedido, estadoPedido, estadoPago);

                redirigir(request, response,
                        actualizado ? "Estados actualizados."
                                     : "No se encontró el pedido.");
                return;
            }

            redirigir(request, response, "Acción no reconocida.");

        } catch (IllegalArgumentException e) {
            redirigir(request, response,
                    "Datos inválidos: verifica el cliente, los servicios y las cantidades.");
        } catch (SQLException e) {
            throw new ServletException(
                    "No se pudo procesar el pedido.", e);
        }
    }

    private boolean esEstadoPedidoValido(String estado) {
        return "Pendiente".equals(estado)
                || "En proceso".equals(estado)
                || "Completado".equals(estado)
                || "Cancelado".equals(estado);
    }

    private boolean esEstadoPagoValido(String estado) {
        return "Pendiente".equals(estado)
                || "Pagado".equals(estado)
                || "Anulado".equals(estado);
    }

    private void redirigir(HttpServletRequest request,
                           HttpServletResponse response,
                           String mensaje) throws IOException {
        response.sendRedirect(request.getContextPath()
                + "/pedidos?mensaje="
                + java.net.URLEncoder.encode(
                        mensaje, java.nio.charset.StandardCharsets.UTF_8));
    }
}
