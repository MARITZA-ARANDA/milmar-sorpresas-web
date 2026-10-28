
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="pe.sorpresas.entidades.Pago"%>

<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    List<Pago> pagos =
        (List<Pago>) request.getAttribute("pagos");

    if (pagos == null) {
        response.sendRedirect(request.getContextPath() + "/pagos");
        return;
    }

    NumberFormat moneda = NumberFormat.getCurrencyInstance(
        Locale.forLanguageTag("es-PE"));
    
    String mensaje = request.getParameter("mensaje");
    
    // Escapar textos antes de mostrarlos en HTML.
    java.util.function.Function<String, String> esc = s -> {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    };
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Pagos | Milmar Sorpresas</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6fb;
            color: #263247;
        }

        header {
            background: #713b8f;
            color: white;
            padding: 22px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        header h1 {
            margin: 0;
            font-size: 24px;
        }

        header a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        main {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 18px;
        }

        .tarjeta {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 4px 14px rgba(0,0,0,.07);
        }

        h2 {
            margin-top: 0;
            color: #713b8f;
        }

        .formulario {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 17px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input, select, textarea {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccd2df;
            border-radius: 7px;
            font-size: 14px;
        }

        textarea {
            resize: vertical;
        }

        .campo-completo {
            grid-column: 1 / -1;
        }

        button {
            border: 0;
            border-radius: 7px;
            padding: 12px 20px;
            cursor: pointer;
            color: white;
            background: #713b8f;
            font-weight: bold;
        }

        button:hover {
            background: #572b70;
        }

        .tabla-contenedor {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e5e8ef;
        }

        th {
            background: #f0e7f6;
            color: #572b70;
        }

        .estado {
            font-weight: bold;
        }

        .acciones {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .acciones select {
            min-width: 135px;
        }

        .secundario {
            background: #52647d;
        }

        .aviso {
            padding: 12px;
            background: #f0e7f6;
            border-radius: 7px;
            margin-bottom: 18px;
        }

        @media (max-width: 600px) {
            .tarjeta {
                padding: 16px;
            }

            header h1 {
                font-size: 20px;
            }
        }
    </style>
</head>

<body>

<header>
    <h1>Milmar Sorpresas | Gestión de Pagos</h1>
    <a href="<%= request.getContextPath() %>/panel.jsp">
        Volver al panel
    </a>
</header>

<main>

    <section class="tarjeta">
        <h2>Registrar nuevo pago</h2>

        <p>
            Registra el pago correspondiente a un pedido previamente creado.
        </p>

        <form action="<%= request.getContextPath() %>/pagos"
              method="post">

            <input type="hidden" name="accion" value="registrar">

            <div class="formulario">

                <div>
                    <label for="id_pedido">ID del pedido</label>
                    <input type="number" id="id_pedido" name="id_pedido"
                           min="1" required>
                </div>

                <div>
                    <label for="monto">Monto (S/)</label>
                    <input type="number" id="monto" name="monto"
                           min="0.01" step="0.01" required>
                </div>

                <div>
                    <label for="metodo_pago">Método de pago</label>
                    <select id="metodo_pago" name="metodo_pago" required>
                        <option value="">Seleccionar</option>
                        <option value="Efectivo">Efectivo</option>
                        <option value="Transferencia">Transferencia</option>
                        <option value="Yape">Yape</option>
                        <option value="Plin">Plin</option>
                        <option value="Tarjeta">Tarjeta</option>
                        <option value="Otro">Otro</option>
                    </select>
                </div>

                <div>
                    <label for="estado_pago">Estado del pago</label>
                    <select id="estado_pago" name="estado_pago" required>
                        <option value="Pendiente">Pendiente</option>
                        <option value="Pagado">Pagado</option>
                        <option value="Rechazado">Rechazado</option>
                    </select>
                </div>

                <div>
                    <label for="numero_operacion">
                        Número de operación
                    </label>
                    <input type="text" id="numero_operacion"
                           name="numero_operacion" maxlength="100">
                </div>

                <div class="campo-completo">
                    <label for="observacion">Observación</label>
                    <textarea id="observacion" name="observacion"
                              maxlength="255" rows="3"></textarea>
                </div>

                <div class="campo-completo">
                    <button type="submit">Registrar pago</button>
                </div>

            </div>
        </form>
    </section>

    <section class="tarjeta">
        <h2>Historial de pagos</h2>

        <div class="tabla-contenedor">
            <table>
                <thead>
                    <tr>
                        <th>ID pago</th>
                        <th>ID pedido</th>
                        <th>Fecha</th>
                        <th>Monto</th>
                        <th>Método</th>
                        <th>Estado</th>
                        <th>Operación</th>
                        <th>Observación</th>
                        <th>Actualizar estado</th>
                    </tr>
                </thead>

                <tbody>
                <% if (pagos.isEmpty()) { %>
                    <tr>
                        <td colspan="9">
                            Todavía no hay pagos registrados.
                        </td>
                    </tr>
                <% } else {
                    for (Pago p : pagos) { %>
                    <tr>
                        <td><%= p.getIdPago() %></td>
                        <td><%= p.getIdPedido() %></td>
                        <td><%= esc.apply(String.valueOf(p.getFechaPago())) %></td>
                        <td><%= moneda.format(p.getMonto()) %></td>
                        <td><%= esc.apply(p.getMetodoPago()) %></td>
                        <td class="estado">
                            <%= esc.apply(p.getEstadoPago()) %>
                        </td>
                        <td>
                            <%= esc.apply(p.getNumeroOperacion()) %>
                        </td>
                        <td>
                            <%= esc.apply(p.getObservacion()) %>
                        </td>
                        <td>
                            <form action="<%= request.getContextPath() %>/pagos"
                                  method="post" class="acciones">

                                <input type="hidden" name="accion"
                                       value="actualizarEstado">

                                <input type="hidden" name="id_pago"
                                       value="<%= p.getIdPago() %>">

                                <select name="estado_pago" required>
                                    <option value="Pendiente"
                                        <%= "Pendiente".equals(p.getEstadoPago())
                                            ? "selected" : "" %>>
                                        Pendiente
                                    </option>

                                    <option value="Pagado"
                                        <%= "Pagado".equals(p.getEstadoPago())
                                            ? "selected" : "" %>>
                                        Pagado
                                    </option>

                                    <option value="Rechazado"
                                        <%= "Rechazado".equals(p.getEstadoPago())
                                            ? "selected" : "" %>>
                                        Rechazado
                                    </option>
                                </select>

                                <button type="submit">Guardar</button>
                            </form>
                        </td>
                    </tr>
                <%  }
                   } %>
                </tbody>
            </table>
        </div>
    </section>

</main>
</body>
</html>
