
package pe.sorpresas.servlet;

import pe.sorpresas.dao.EventoEntregaDAO;
import pe.sorpresas.entidades.EventoEntrega;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.sql.SQLException;

@WebServlet("/eventos")
public class EventoEntregaServlet extends HttpServlet {

    private final EventoEntregaDAO dao = new EventoEntregaDAO();

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
            request.setAttribute("eventos", dao.listar());
            request.getRequestDispatcher("/eventos.jsp")
                   .forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(
                    "No se pudieron consultar los eventos y entregas.", e);
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
                EventoEntrega e = new EventoEntrega();

                int idPedido = Integer.parseInt(
                        request.getParameter("idPedido"));

                String tipo = request.getParameter("tipoCelebracion").trim();
                String destinatario =
                        request.getParameter("nombreDestinatario").trim();
                String fecha = request.getParameter("fechaEntrega");
                String hora = request.getParameter("horaEntrega");
                String direccion =
                        request.getParameter("direccionEntrega").trim();
                String referencia = request.getParameter("referenciaEntrega");

                if (idPedido <= 0 || tipo.isEmpty()
                        || destinatario.isEmpty() || fecha.isEmpty()
                        || hora.isEmpty() || direccion.isEmpty()) {
                    throw new IllegalArgumentException(
                            "Completa todos los campos obligatorios.");
                }

                if (tipo.length() > 50 || destinatario.length() > 100
                        || direccion.length() > 255
                        || (referencia != null && referencia.length() > 150)) {
                    throw new IllegalArgumentException(
                            "Uno de los campos supera la longitud permitida.");
                }

                e.setIdPedido(idPedido);
                e.setTipoCelebracion(tipo);
                e.setNombreDestinatario(destinatario);
                e.setFechaEntrega(Date.valueOf(fecha));
                e.setHoraEntrega(Time.valueOf(hora.length() == 5
                        ? hora + ":00" : hora));
                e.setDireccionEntrega(direccion);
                e.setReferenciaEntrega(
                        referencia == null || referencia.trim().isEmpty()
                        ? null : referencia.trim());
                e.setEstadoEntrega("Por Preparar");

                if (dao.registrar(e)) {
                    redirigir(request, response, "Evento registrado correctamente.");
                } else {
                    redirigir(request, response, "No se pudo registrar el evento.");
                }
                return;

            } else if ("actualizar".equals(accion)) {
                int idEvento = Integer.parseInt(
                        request.getParameter("idEvento"));
                String estado = request.getParameter("estadoEntrega");

                if (idEvento <= 0 || !estadoValido(estado)) {
                    throw new IllegalArgumentException(
                            "El evento o el estado no son válidos.");
                }

                boolean actualizado = dao.actualizarEstado(idEvento, estado);

                redirigir(request, response, actualizado
                        ? "Estado de entrega actualizado."
                        : "No se encontró el evento.");
                return;
            }

            redirigir(request, response, "Acción no reconocida.");

        } catch (IllegalArgumentException e) {
            redirigir(request, response,
                    "Datos inválidos. Revisa los campos y sus formatos.");
        } catch (SQLException e) {
            throw new ServletException(
                    "No se pudo guardar el evento. Verifica el pedido y la base de datos.", e);
        }
    }

    private boolean estadoValido(String estado) {
        return "Por Preparar".equals(estado)
                || "En Preparación".equals(estado)
                || "Listo para Entrega".equals(estado)
                || "En Camino".equals(estado)
                || "Entregado".equals(estado)
                || "Cancelado".equals(estado);
    }

    private void redirigir(HttpServletRequest request,
                           HttpServletResponse response,
                           String mensaje) throws IOException {
        response.sendRedirect(request.getContextPath()
                + "/eventos?mensaje="
                + java.net.URLEncoder.encode(
                        mensaje, java.nio.charset.StandardCharsets.UTF_8));
    }
}
