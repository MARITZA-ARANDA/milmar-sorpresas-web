
package pe.sorpresas.servlet;

import pe.sorpresas.dao.ServicioDAO;
import pe.sorpresas.entidades.Servicio;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

@WebServlet("/servicios")
public class ServicioServlet extends HttpServlet {

    private final ServicioDAO dao = new ServicioDAO();

    private boolean sesionValida(HttpServletRequest request) {
        HttpSession sesion = request.getSession(false);
        return sesion != null
                && sesion.getAttribute("usuario") != null;
    }

    private void redirigirMensaje(HttpServletRequest request,
                                  HttpServletResponse response,
                                  String mensaje)
            throws IOException {

        String texto = URLEncoder.encode(
                mensaje, StandardCharsets.UTF_8);

        response.sendRedirect(
                request.getContextPath() + "/servicios?mensaje=" + texto);
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
            request.setAttribute("servicios", dao.listar());

            request.getRequestDispatcher("/servicios.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Error al consultar los servicios", e);
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

                String nombre = request.getParameter("nombreServicio");
                String descripcion = request.getParameter("descripcion");
                String precioTexto = request.getParameter("precioUnitario");

                if (nombre == null || nombre.isBlank()
                        || precioTexto == null || precioTexto.isBlank()) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "El nombre y el precio son obligatorios.");
                    return;
                }

                nombre = nombre.trim();

                if (nombre.length() > 100) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "El nombre no puede superar los 100 caracteres.");
                    return;
                }

                BigDecimal precio = new BigDecimal(precioTexto.trim());

                if (precio.signum() < 0
                        || precio.scale() > 2
                        || precio.precision() > 10) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Ingresa un precio válido con hasta dos decimales.");
                    return;
                }

                Servicio servicio = new Servicio();
                servicio.setNombreServicio(nombre);
                servicio.setDescripcion(
                        descripcion == null || descripcion.isBlank()
                        ? null : descripcion.trim());
                servicio.setPrecioUnitario(precio);

                if ("registrar".equals(accion)) {
                    servicio.setEstado("Activo");
                    dao.registrar(servicio);

                    redirigirMensaje(request, response,
                            "Servicio registrado correctamente.");

                } else {
                    String idTexto = request.getParameter("idServicio");

                    if (idTexto == null || idTexto.isBlank()) {
                        response.sendError(
                                HttpServletResponse.SC_BAD_REQUEST,
                                "Falta el identificador del servicio.");
                        return;
                    }

                    int id = Integer.parseInt(idTexto);

                    if (id <= 0) {
                        response.sendError(
                                HttpServletResponse.SC_BAD_REQUEST,
                                "Identificador inválido.");
                        return;
                    }

                    servicio.setIdServicio(id);

                    if (dao.actualizar(servicio)) {
                        redirigirMensaje(request, response,
                                "Servicio actualizado correctamente.");
                    } else {
                        redirigirMensaje(request, response,
                                "No se encontró el servicio para actualizar.");
                    }
                }

            } else if ("cambiarEstado".equals(accion)) {

                String idTexto = request.getParameter("idServicio");
                String estado = request.getParameter("estado");

                if (idTexto == null || idTexto.isBlank()) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Falta el identificador del servicio.");
                    return;
                }

                int id = Integer.parseInt(idTexto);

                if (id <= 0
                        || (!"Activo".equals(estado)
                        && !"Inactivo".equals(estado))) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Datos de estado inválidos.");
                    return;
                }

                if (dao.cambiarEstado(id, estado)) {
                    redirigirMensaje(request, response,
                            "Estado del servicio actualizado.");
                } else {
                    redirigirMensaje(request, response,
                            "No se encontró el servicio.");
                }

            } else {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Acción no válida.");
            }

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "El identificador o el precio no tiene un formato válido.");

        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Verifica el precio ingresado.");

        } catch (SQLException e) {
            throw new ServletException(
                    "Error al procesar el servicio", e);
        }
    }
}
