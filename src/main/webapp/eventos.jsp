
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="pe.sorpresas.entidades.EventoEntrega"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    List<EventoEntrega> eventos =
        (List<EventoEntrega>) request.getAttribute("eventos");

    String[] estados = {
        "Por Preparar", "En Preparación", "Listo para Entrega",
        "En Camino", "Entregado", "Cancelado"
    };
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Eventos y Entregas | Milmar Sorpresas</title>

    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f3fa;
            color: #333;
        }
        header {
            background: #6c3483;
            color: white;
            padding: 20px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }
        header h1 { margin: 0 0 6px; }
        header a { color: white; text-decoration: none; }
        main { max-width: 1300px; margin: 28px auto; padding: 0 18px; }
        .tarjeta {
            background: white;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 22px;
            box-shadow: 0 3px 12px #00000010;
        }
        h2 { color: #6c3483; margin-top: 0; }
        .formulario {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 15px;
            align-items: end;
        }
        label { display: block; font-weight: bold; margin-bottom: 6px; }
        input, select, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font: inherit;
        }
        textarea { resize: vertical; min-height: 42px; }
        button {
            background: #6c3483;
            color: white;
            padding: 11px 14px;
            border: 0;
            border-radius: 6px;
            cursor: pointer;
        }
        .mensaje { background: #eee4f5; padding: 12px; border-radius: 6px; }
        .tabla-contenedor { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 1100px; }
        th, td { padding: 11px 9px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #f0e6f6; }
        td form { display: grid; gap: 7px; min-width: 150px; }
        .acciones { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
    </style>
</head>

<body>
<header>
    <div>
        <h1>Milmar Sorpresas</h1>
        <span>Gestión de eventos y entregas</span>
    </div>
    <nav>
        <a href="<%=request.getContextPath()%>/panel.jsp">Panel principal</a>
        &nbsp; | &nbsp;
        <a href="<%=request.getContextPath()%>/CerrarSesionServlet">Cerrar sesión</a>
    </nav>
</header>

<main>

    <% if (request.getParameter("mensaje") != null) { %>
        <p class="mensaje"><%=request.getParameter("mensaje")%></p>
    <% } %>

    <section class="tarjeta">
        <h2>Registrar evento y entrega</h2>

        <form action="<%=request.getContextPath()%>/eventos"
              method="post" class="formulario">

            <input type="hidden" name="accion" value="registrar">

            <div>
                <label for="idPedido">ID del pedido</label>
                <input type="number" id="idPedido" name="idPedido"
                       min="1" required>
            </div>

            <div>
                <label for="tipoCelebracion">Tipo de celebración</label>
                <select id="tipoCelebracion" name="tipoCelebracion" required>
                    <option value="">Selecciona</option>
                    <option>Cumpleaños</option>
                    <option>Aniversario</option>
                    <option>Pedida de mano</option>
                    <option>Graduación</option>
                    <option>Sorpresa romántica</option>
                    <option>Baby shower</option>
                    <option>Otro</option>
                </select>
            </div>

            <div>
                <label for="nombreDestinatario">Nombre del destinatario</label>
                <input type="text" id="nombreDestinatario"
                       name="nombreDestinatario" maxlength="100" required>
            </div>

            <div>
                <label for="fechaEntrega">Fecha de entrega</label>
                <input type="date" id="fechaEntrega"
                       name="fechaEntrega" required>
            </div>

            <div>
                <label for="horaEntrega">Hora de entrega</label>
                <input type="time" id="horaEntrega"
                       name="horaEntrega" required>
            </div>

            <div>
                <label for="direccionEntrega">Dirección de entrega</label>
                <input type="text" id="direccionEntrega"
                       name="direccionEntrega" maxlength="255" required>
            </div>

            <div>
                <label for="referenciaEntrega">Referencia (opcional)</label>
                <input type="text" id="referenciaEntrega"
                       name="referenciaEntrega" maxlength="150">
            </div>

            <div>
                <button type="submit">Registrar evento</button>
            </div>
        </form>
        <p>El ID del pedido debe existir en la tabla de pedidos de tu base de datos.</p>
    </section>

    <section class="tarjeta">
        <h2>Eventos y entregas registradas</h2>

        <div class="tabla-contenedor">
            <table>
                <thead>
                    <tr>
                        <th>ID evento</th>
                        <th>ID pedido</th>
                        <th>Celebración</th>
                        <th>Destinatario</th>
                        <th>Fecha</th>
                        <th>Hora</th>
                        <th>Dirección</th>
                        <th>Referencia</th>
                        <th>Estado</th>
                        <th>Actualizar</th>
                    </tr>
                </thead>
                <tbody>
                <% if (eventos != null && !eventos.isEmpty()) {
                       for (EventoEntrega e : eventos) { %>
                    <tr>
                        <td><%=e.getIdEvento()%></td>
                        <td><%=e.getIdPedido()%></td>
                        <td><%=e.getTipoCelebracion()%></td>
                        <td><%=e.getNombreDestinatario()%></td>
                        <td><%=e.getFechaEntrega()%></td>
                        <td><%=e.getHoraEntrega()%></td>
                        <td><%=e.getDireccionEntrega()%></td>
                        <td><%=e.getReferenciaEntrega() == null
                                ? "-" : e.getReferenciaEntrega()%></td>
                        <td><%=e.getEstadoEntrega()%></td>
                        <td>
                            <form action="<%=request.getContextPath()%>/eventos"
                                  method="post">
                                <input type="hidden" name="accion" value="actualizar">
                                <input type="hidden" name="idEvento"
                                       value="<%=e.getIdEvento()%>">

                                <label>Nuevo estado</label>
                                <select name="estadoEntrega" required>
                                    <% for (String estado : estados) { %>
                                        <option value="<%=estado%>"
                                            <%=estado.equals(e.getEstadoEntrega())
                                                ? "selected" : ""%>>
                                            <%=estado%>
                                        </option>
                                    <% } %>
                                </select>

                                <button type="submit">Guardar estado</button>
                            </form>
                        </td>
                    </tr>
                <%     }
                   } else { %>
                    <tr>
                        <td colspan="10">Todavía no hay eventos registrados.</td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

</main>
</body>
</html>
