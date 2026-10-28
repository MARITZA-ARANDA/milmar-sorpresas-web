
package pe.sorpresas.servlet;

import pe.sorpresas.dao.ReporteDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reportes")
public class ReporteServlet extends HttpServlet {

    private final ReporteDAO reporteDAO = new ReporteDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion == null
                || sesion.getAttribute("usuario") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            request.setAttribute(
                    "totalClientes", reporteDAO.contarClientes());

            request.setAttribute(
                    "serviciosActivos",
                    reporteDAO.contarServiciosActivos());

            request.setAttribute(
                    "totalPedidos", reporteDAO.contarPedidos());

            request.setAttribute(
                    "ingresosPagados",
                    reporteDAO.obtenerIngresosPagados());

            request.setAttribute(
                    "pagosPendientes",
                    reporteDAO.contarPagosPendientes());

            request.getRequestDispatcher("/reportes.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Error al generar los reportes.", e);
        }
    }
}
