

package pe.sorpresas.servlet;

import pe.sorpresas.dao.ClienteDAO;
import pe.sorpresas.entidades.Cliente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/clientes")
public class ClienteServlet extends HttpServlet {

    private final ClienteDAO dao = new ClienteDAO();

    private boolean sesionValida(HttpServletRequest request) {
        HttpSession sesion = request.getSession(false);
        return sesion != null
                && sesion.getAttribute("usuario") != null;
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!sesionValida(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            request.setAttribute("clientes", dao.listar());

            request.getRequestDispatcher("/clientes.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Error al consultar los clientes", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!sesionValida(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        try {
            if ("registrar".equals(accion)
                    || "actualizar".equals(accion)) {

                Cliente c = new Cliente();

                String nombres = request.getParameter("nombres");
                String apellidos = request.getParameter("apellidos");
                String tipoDocumento =
                        request.getParameter("tipoDocumento");
                String nroDocumento =
                        request.getParameter("nroDocumento");
                String telefono = request.getParameter("telefono");
                String correo = request.getParameter("correo");

                c.setNombres(nombres == null ? "" : nombres.trim());
                c.setApellidos(apellidos == null ? "" : apellidos.trim());
                c.setTipoDocumento(tipoDocumento);
                c.setNroDocumento(
                        nroDocumento == null ? "" : nroDocumento.trim());
                c.setTelefono(
                        telefono == null ? "" : telefono.trim());
                c.setCorreo(
                        correo == null ? "" : correo.trim());

                if (c.getNombres().isBlank()
                        || c.getApellidos().isBlank()
                        || c.getTipoDocumento() == null
                        || c.getTipoDocumento().isBlank()
                        || c.getNroDocumento().isBlank()) {

                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Completa los campos obligatorios.");
                    return;
                }

                if ("registrar".equals(accion)) {
                    dao.registrar(c);

                } else {
                    String idTexto =
                            request.getParameter("idCliente");

                    if (idTexto == null || idTexto.isBlank()) {
                        response.sendError(
                                HttpServletResponse.SC_BAD_REQUEST,
                                "Falta el ID del cliente.");
                        return;
                    }

                    int id = Integer.parseInt(idTexto);
                    c.setIdCliente(id);
                    dao.actualizar(c);
                }

            } else if ("eliminar".equals(accion)) {

                String idTexto =
                        request.getParameter("idCliente");

                if (idTexto == null || idTexto.isBlank()) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Falta el ID del cliente.");
                    return;
                }

                int id = Integer.parseInt(idTexto);
                dao.eliminar(id);

            } else {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Acción no válida.");
                return;
            }

            response.sendRedirect(
                    request.getContextPath() + "/clientes");

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Identificador inválido.");

        } catch (SQLException e) {
            throw new ServletException(
                    "Error al procesar el cliente", e);
        }
    }
}
