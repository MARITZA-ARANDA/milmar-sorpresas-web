package pe.sorpresas.servlet;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;

@WebServlet("/")
public class InicioServlet extends HttpServlet {
 @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException {
   req.getRequestDispatcher("/index.jsp").forward(req,resp);
 }
}