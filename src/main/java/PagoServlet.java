
package pe.sorpresas.servlet;

import pe.sorpresas.dao.PagoDAO;
import pe.sorpresas.entidades.Pago;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/pagos")
public class PagoServlet extends HttpServlet {

    private final PagoDAO pagoDAO = new PagoDAO();

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
            List<Pago> pagos = pagoDAO.listar();
            request.setAttribute("pagos", pagos);

            request.getRequestDispatcher("/pagos.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Error al consultar los pagos.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        try {
            if ("registrar".equals(accion)) {
                registrarPago(request);
            } else if ("actualizarEstado".equals(accion)) {
                actualizarEstado(request);
            } else {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Acción no válida.");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/pagos");

        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST, e.getMessage());

        } catch (SQLException e) {
            throw new ServletException(
                    "Error al procesar el pago.", e);
        }
    }

    private void registrarPago(HttpServletRequest request)
            throws SQLException {

        int idPedido = Integer.parseInt(
                request.getParameter("id_pedido"));

        BigDecimal monto = new BigDecimal(
                request.getParameter("monto"));

        String metodo = request.getParameter("metodo_pago");
        String estado = request.getParameter("estado_pago");
        String operacion = request.getParameter("numero_operacion");
        String observacion = request.getParameter("observacion");

        if (idPedido <= 0 || monto.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException(
                    "El pedido y el monto deben ser válidos.");
        }

        if (metodo == null || metodo.isBlank()
                || estado == null || estado.isBlank()) {
            throw new IllegalArgumentException(
                    "Selecciona un método y un estado de pago.");
        }

        if (metodo.length() > 30 || estado.length() > 20
                || (operacion != null && operacion.length() > 100)
                || (observacion != null && observacion.length() > 255)) {
            throw new IllegalArgumentException(
                    "Uno de los campos supera la longitud permitida.");
        }

        Pago pago = new Pago();
        pago.setIdPedido(idPedido);
        pago.setMonto(monto);
        pago.setMetodoPago(metodo);
        pago.setEstadoPago(estado);
        pago.setNumeroOperacion(vacioANull(operacion));
        pago.setObservacion(vacioANull(observacion));

        boolean registrado = pagoDAO.registrar(pago);

        if (!registrado) {
            throw new IllegalArgumentException(
                    "No se pudo registrar el pago.");
        }
    }

    private void actualizarEstado(HttpServletRequest request)
            throws SQLException {

        int idPago = Integer.parseInt(
                request.getParameter("id_pago"));

        String estado = request.getParameter("estado_pago");

        if (idPago <= 0 || estado == null
                || !List.of("Pendiente", "Pagado", "Rechazado")
                       .contains(estado)) {
            throw new IllegalArgumentException(
                    "El identificador o estado no es válido.");
        }

        pagoDAO.actualizarEstado(idPago, estado);
    }

    private String vacioANull(String valor) {
        return valor == null || valor.isBlank() ? null : valor.trim();
    }
}
