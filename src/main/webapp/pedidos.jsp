

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="pe.sorpresas.entidades.Pedido"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.math.BigDecimal"%>

<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    List<Pedido> pedidos =
        (List<Pedido>) request.getAttribute("pedidos");

    List<Map<String, Object>> servicios =
        (List<Map<String, Object>>) request.getAttribute("servicios");

    NumberFormat moneda =
        NumberFormat.getCurrencyInstance(new Locale("es", "PE"));
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedidos | Milmar Sorpresas</title>

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
            gap: 12px;
            flex-wrap: wrap;
        }
        header h1 { margin: 0 0 5px; }
        header a { color: white; text-decoration: none; }
        main { max-width: 1200px; margin: 28px auto; padding: 0 18px; }
        .tarjeta {
            background: white;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 22px;
            box-shadow: 0 3px 12px #00000010;
        }
        h2 { color: #6c3483; margin-top: 0; }
        label { display: block; font-weight: bold; margin-bottom: 6px; }
        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button, .boton {
            background: #6c3483;
            color: white;
            padding: 10px 14px;
            border: 0;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        button:disabled { opacity: .5; cursor: not-allowed; }
        .secundario { background: #777; }
        .eliminar { background: #b03a2e; }
        .mensaje { background: #eee4f5; padding: 12px; border-radius: 6px; }
        .tabla-contenedor { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 850px; }
        th, td { border-bottom: 1px solid #eee; padding: 12px 9px; text-align: left; }
        th { background: #f0e6f6; }
        td form { display: grid; gap: 7px; min-width: 145px; }
        .form-cliente { max-width: 400px; margin-bottom: 20px; }
        .linea-detalle {
            display: grid;
            grid-template-columns: minmax(200px, 2fr) minmax(90px, .7fr)
                minmax(110px, 1fr) minmax(110px, 1fr) auto;
            gap: 10px;
            align-items: end;
            margin: 12px 0;
        }
        .total {
            text-align: right;
            font-size: 1.35rem;
            font-weight: bold;
            color: #6c3483;
            margin: 20px 0;
        }
        .ayuda { color: #666; font-size: .9rem; }
        @media(max-width: 720px) {
            .linea-detalle { grid-template-columns: 1fr 1fr; }
            .linea-detalle .campo-servicio { grid-column: 1 / -1; }
        }
    </style>
</head>

<body>
<header>
    <div>
        <h1>Milmar Sorpresas</h1>
        <span>Gestión de pedidos</span>
    </div>
    <nav>
        <a href="<%=request.getContextPath()%>/panel.jsp">Panel principal</a>
        &nbsp; | &nbsp;
        <a href="<%=request.getContextPath()%>/CerrarSesionServlet">Cerrar sesión</a>
    </nav>
</header>

<main>

    <% if (request.getParameter("mensaje") != null) { %>
        <p class="mensaje"><%= request.getParameter("mensaje") %></p>
    <% } %>

    <section class="tarjeta">
        <h2>Registrar nuevo pedido</h2>

        <% if (servicios == null || servicios.isEmpty()) { %>
            <p class="mensaje">
                No hay servicios activos. Registra o activa servicios antes de crear un pedido.
            </p>
        <% } else { %>

        <form action="<%=request.getContextPath()%>/pedidos"
              method="post" id="formPedido">

            <input type="hidden" name="accion" value="registrar">

            <div class="form-cliente">
                <label for="idCliente">ID del cliente</label>
                <input type="number" id="idCliente" name="idCliente"
                       min="1" step="1" required>
                <p class="ayuda">
                    Ingresa el ID de un cliente existente en la tabla cliente.
                </p>
            </div>

            <h3>Servicios del pedido</h3>

            <div id="detalles"></div>

            <button type="button" id="btnAgregar" class="secundario">
                + Agregar servicio
            </button>

            <div class="total">
                Total: <span id="totalTexto">S/ 0.00</span>
            </div>

            <input type="hidden" id="totalCalculado" value="0">

            <button type="submit" id="btnRegistrar">
                Registrar pedido
            </button>
        </form>

        <template id="plantillaDetalle">
            <div class="linea-detalle">
                <div class="campo-servicio">
                    <label>Servicio</label>
                    <select name="idServicio" class="servicio" required>
                        <option value="">Selecciona un servicio</option>
                        <% for (Map<String, Object> s : servicios) { %>
                            <option value="<%=s.get("idServicio")%>"
                                    data-precio="<%=s.get("precio")%>">
                                <%=s.get("nombre")%> -
                                <%=moneda.format((BigDecimal)s.get("precio"))%>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div>
                    <label>Cantidad</label>
                    <input type="number" name="cantidad" class="cantidad"
                           min="1" step="1" value="1" required>
                </div>

                <div>
                    <label>Precio unitario</label>
                    <input type="text" class="precio" value="S/ 0.00" readonly>
                </div>

                <div>
                    <label>Subtotal</label>
                    <input type="text" class="subtotal" value="S/ 0.00" readonly>
                </div>

                <div>
                    <button type="button" class="eliminar btnEliminar">
                        Quitar
                    </button>
                </div>
            </div>
        </template>

        <p class="ayuda">
            El precio y el total definitivos se validan y calculan nuevamente en el servidor.
        </p>

        <% } %>
    </section>

    <section class="tarjeta">
        <h2>Lista de pedidos</h2>

        <div class="tabla-contenedor">
            <table>
                <thead>
                    <tr>
                        <th>N.º</th>
                        <th>ID cliente</th>
                        <th>Fecha</th>
                        <th>Monto</th>
                        <th>Estado del pedido</th>
                        <th>Estado del pago</th>
                        <th>Actualizar</th>
                    </tr>
                </thead>

                <tbody>
                <% if (pedidos != null && !pedidos.isEmpty()) {
                       for (Pedido p : pedidos) { %>
                    <tr>
                        <td><%=p.getIdPedido()%></td>
                        <td><%=p.getIdCliente()%></td>
                        <td><%=p.getFechaPedido()%></td>
                        <td><%=moneda.format(p.getMontoTotal())%></td>
                        <td><%=p.getEstadoPedido()%></td>
                        <td><%=p.getEstadoPago()%></td>
                        <td>
                            <form action="<%=request.getContextPath()%>/pedidos"
                                  method="post">
                                <input type="hidden" name="accion" value="actualizar">
                                <input type="hidden" name="idPedido"
                                       value="<%=p.getIdPedido()%>">

                                <label>Pedido</label>
                                <select name="estadoPedido">
                                    <option value="Pendiente"
                                        <%= "Pendiente".equals(p.getEstadoPedido()) ? "selected" : "" %>>
                                        Pendiente
                                    </option>
                                    <option value="En proceso"
                                        <%= "En proceso".equals(p.getEstadoPedido()) ? "selected" : "" %>>
                                        En proceso
                                    </option>
                                    <option value="Completado"
                                        <%= "Completado".equals(p.getEstadoPedido()) ? "selected" : "" %>>
                                        Completado
                                    </option>
                                    <option value="Cancelado"
                                        <%= "Cancelado".equals(p.getEstadoPedido()) ? "selected" : "" %>>
                                        Cancelado
                                    </option>
                                </select>

                                <label>Pago</label>
                                <select name="estadoPago">
                                    <option value="Pendiente"
                                        <%= "Pendiente".equals(p.getEstadoPago()) ? "selected" : "" %>>
                                        Pendiente
                                    </option>
                                    <option value="Pagado"
                                        <%= "Pagado".equals(p.getEstadoPago()) ? "selected" : "" %>>
                                        Pagado
                                    </option>
                                    <option value="Anulado"
                                        <%= "Anulado".equals(p.getEstadoPago()) ? "selected" : "" %>>
                                        Anulado
                                    </option>
                                </select>

                                <button type="submit">Guardar cambios</button>
                            </form>
                        </td>
                    </tr>
                <%     }
                   } else { %>
                    <tr>
                        <td colspan="7">Todavía no hay pedidos registrados.</td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

</main>

<script>
(function () {
    const contenedor = document.getElementById("detalles");
    const plantilla = document.getElementById("plantillaDetalle");
    const botonAgregar = document.getElementById("btnAgregar");
    const formulario = document.getElementById("formPedido");
    const textoTotal = document.getElementById("totalTexto");
    const campoTotal = document.getElementById("totalCalculado");

    if (!contenedor || !plantilla || !botonAgregar || !formulario) {
        return;
    }

    const formatoMoneda = new Intl.NumberFormat("es-PE", {
        style: "currency",
        currency: "PEN"
    });

    function actualizarTotales() {
        let total = 0;

        contenedor.querySelectorAll(".linea-detalle").forEach(function (fila) {
            const selector = fila.querySelector(".servicio");
            const cantidadInput = fila.querySelector(".cantidad");
            const precioInput = fila.querySelector(".precio");
            const subtotalInput = fila.querySelector(".subtotal");

            const opcion = selector.options[selector.selectedIndex];
            const precio = opcion && opcion.dataset.precio
                ? Number(opcion.dataset.precio) : 0;
            const cantidad = Number(cantidadInput.value) || 0;
            const subtotal = precio * cantidad;

            precioInput.value = formatoMoneda.format(precio);
            subtotalInput.value = formatoMoneda.format(subtotal);

            if (cantidad > 0 && Number.isFinite(subtotal)) {
                total += subtotal;
            }
        });

        textoTotal.textContent = formatoMoneda.format(total);
        campoTotal.value = total.toFixed(2);
    }

    function agregarDetalle() {
        const fragmento = plantilla.content.cloneNode(true);
        const fila = fragmento.querySelector(".linea-detalle");

        fila.querySelector(".servicio").addEventListener(
            "change", actualizarTotales);
        fila.querySelector(".cantidad").addEventListener(
            "input", actualizarTotales);

        fila.querySelector(".btnEliminar").addEventListener("click", function () {
            fila.remove();

            if (contenedor.querySelectorAll(".linea-detalle").length === 0) {
                agregarDetalle();
            }

            actualizarTotales();
        });

        contenedor.appendChild(fragmento);
        actualizarTotales();
    }

    botonAgregar.addEventListener("click", agregarDetalle);

    formulario.addEventListener("submit", function (evento) {
        const filas = contenedor.querySelectorAll(".linea-detalle");

        if (filas.length === 0) {
            evento.preventDefault();
            alert("Agrega al menos un servicio.");
            return;
        }

        for (const fila of filas) {
            const servicio = fila.querySelector(".servicio").value;
            const cantidad = Number(fila.querySelector(".cantidad").value);

            if (!servicio || !Number.isInteger(cantidad) || cantidad < 1) {
                evento.preventDefault();
                alert("Selecciona un servicio e indica una cantidad válida en cada fila.");
                return;
            }
        }
    });

    agregarDetalle();
})();
</script>

</body>
</html>
