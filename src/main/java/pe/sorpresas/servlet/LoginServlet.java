
package pe.sorpresas.controlador;

import pe.sorpresas.dao.UsuarioDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");

        try {
            if (usuario != null && clave != null
                    && usuarioDAO.validarUsuario(usuario.trim(), clave)) {

                HttpSession sesion = request.getSession();
                sesion.setAttribute("usuario", usuario.trim());

                response.sendRedirect(
                    request.getContextPath() + "/panel.jsp"
                );

            } else {
                response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=credenciales"
                );
            }

        } catch (SQLException e) {
            throw new ServletException(
                "Error al consultar la base de datos.", e
            );
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
    }
}
