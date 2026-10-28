
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="pe.sorpresas.entidades.Servicio" %>

<%!
    public String escapar(String valor) {
        if (valor == null) return "";

        return valor.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    HttpSession sesion = request.getSession(false);

    if (sesion == null || sesion.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Servicio> servicios =
        (List<Servicio>) request.getAttribute("servicios");

    String mensaje = request.getParameter("mensaje");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Servicios - Milmar Sorpresas</title>

    <style>
        * { box-sizing: border-box; }

        body {
            font-family: Arial, sans-serif;
            background: #fff4f7;
            color: #333;
            margin: 0;
        }

        header {
            background: #b83280;
            color: white;
            padding: 20px;
        }

        header a {
            color: white;
            margin-right: 18px;
            text-decoration: none;
        }

        main {
            max-width: 1150px;
            margin: 25px auto;
            padding: 20px;
        }

        .panel {
            background: white;
            padding: 22px;
            margin-bottom: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 12px #00000012;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 15px;
        }

        label {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        input, textarea, select, button {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font: inherit;
        }

        textarea {
            min-height: 90px;
            resize: vertical;
        }

        button {
            cursor: pointer;
            color: white;
            background: #b83280;
            border: none;
        }

        .secundario { background: #666; }
        .editar { background: #2471a3; }
        .estado { background: #555; }

        .mensaje {
            background: #f8dce9;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        .tabla-contenedor { overflow-x: auto; }

        table {
            width: 100%;
            min-width: 750px;
            border-collapse: collapse;
        }

        th, td {
            text-align: left;
            padding: 10px;
            border-bottom: 1px solid #eee;
        }

        th { background: #f8dce9; }

        .acciones {
            display: flex;
            flex-wrap: wrap;
            gap: 7px;
        }

        .acciones form { margin: 0; }

        .activo {
            color: #137333;
            font-weight: bold;
        }

        .inactivo {
            color: #a61b1b;
            font-weight: bold;
        }

        @media (max-width: 600px) {
            main { padding: 10px; }
            .panel { padding: 15px; }
        }
    </style>
</head>

<body>

<header>
    <h1>Milmar Sorpresas</h1>

    <nav>
        <a href="<%= request.getContextPath() %>/panel.jsp">
            Panel principal
        </a>

        <a href="<%= request.getContextPath() %>/clientes">
            Clientes
        </a>

        <a href="<%= request.getContextPath() %>/servicios">
            Servicios
        </a>

        <a href="<%= request.getContextPath() %>/CerrarSesionServlet">
            Cerrar sesión
        </a>
    </nav>
</header>

<main>
    <h2>Gestión de servicios</h2>
    <p>Administra los servicios y paquetes de Milmar Sorpresas.</p>

    <% if (mensaje != null && !mensaje.isBlank()) { %>
        <div class="mensaje"><%= escapar(mensaje) %></div>
    <% } %>

    <section class="panel" id="formularioServicio">
        <h3 id="tituloFormulario">Registrar servicio</h3>

        <form id="formServicio"
              action="<%= request.getContextPath() %>/servicios"
              method="post"
              class="form-grid">

            <input type="hidden" name="accion" id="accion" value="registrar">
            <input type="hidden" name="idServicio" id="idServicio" value="">

            <label>
                Nombre del servicio *
                <input type="text"
                       name="nombreServicio"
                       id="nombreServicio"
                       maxlength="100"
                       required>
            </label>

            <label>
                Precio unitario (S/) *
                <input type="number"
                       name="precioUnitario"
                       id="precioUnitario"
                       min="0"
                       max="99999999.99"
                       step="0.01"
                       required>
            </label>

            <label style="grid-column: 1 / -1;">
                Descripción
                <textarea name="descripcion"
                          id="descripcion"
                          placeholder="Describe lo que incluye el servicio"></textarea>
            </label>

            <div style="display:flex; gap:10px; align-items:end; flex-wrap:wrap;">
                <button type="submit" id="btnGuardar">
                    Guardar servicio
                </button>

                <button type="button"
                        class="secundario"
                        onclick="reiniciarFormulario()">
                    Nuevo / Limpiar
                </button>
            </div>
        </form>
    </section>

    <section class="panel">
        <h3>Servicios registrados</h3>

        <div class="tabla-contenedor">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Descripción</th>
                        <th>Precio (S/)</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>

                <tbody>
                <% if (servicios != null && !servicios.isEmpty()) {
                       for (Servicio s : servicios) {
                           String estado = s.getEstado() == null
                                   ? "Activo" : s.getEstado();
                %>
                    <tr>
                        <td><%= s.getIdServicio() %></td>

                        <td><%= escapar(s.getNombreServicio()) %></td>

                        <td><%= escapar(s.getDescripcion()) %></td>

                        <td>
                            <%= s.getPrecioUnitario() == null
                                    ? "0.00"
                                    : s.getPrecioUnitario().toPlainString() %>
                        </td>

                        <td>
                            <span class="<%= "Activo".equals(estado)
                                    ? "activo" : "inactivo" %>">
                                <%= escapar(estado) %>
                            </span>
                        </td>

                        <td>
                            <div class="acciones">

                                <button type="button"
                                        class="editar"
                                        onclick="editarServicio(this)"
                                        data-id="<%= s.getIdServicio() %>"
                                        data-nombre="<%= escapar(s.getNombreServicio()) %>"
                                        data-descripcion="<%= escapar(s.getDescripcion()) %>"
                                        data-precio="<%= s.getPrecioUnitario() == null
                                                ? "0.00"
                                                : s.getPrecioUnitario().toPlainString() %>">
                                    Editar
                                </button>

                                <form action="<%= request.getContextPath() %>/servicios"
                                      method="post"
                                      onsubmit="return confirm('¿Cambiar el estado de este servicio?');">

                                    <input type="hidden"
                                           name="accion"
                                           value="cambiarEstado">

                                    <input type="hidden"
                                           name="idServicio"
                                           value="<%= s.getIdServicio() %>">

                                    <input type="hidden"
                                           name="estado"
                                           value="<%= "Activo".equals(estado)
                                                   ? "Inactivo" : "Activo" %>">

                                    <button type="submit" class="estado">
                                        <%= "Activo".equals(estado)
                                                ? "Desactivar" : "Activar" %>
                                    </button>
                                </form>

                            </div>
                        </td>
                    </tr>

                <%     }
                   } else { %>
                    <tr>
                        <td colspan="6">No hay servicios registrados.</td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>

<script>
    function editarServicio(boton) {
        const d = boton.dataset;

        document.getElementById("idServicio").value = d.id;
        document.getElementById("nombreServicio").value = d.nombre;
        document.getElementById("descripcion").value = d.descripcion;
        document.getElementById("precioUnitario").value = d.precio;

        document.getElementById("accion").value = "actualizar";
        document.getElementById("btnGuardar").textContent =
            "Actualizar servicio";
        document.getElementById("tituloFormulario").textContent =
            "Editar servicio";

        document.getElementById("formularioServicio").scrollIntoView({
            behavior: "smooth",
            block: "start"
        });
    }

    function reiniciarFormulario() {
        document.getElementById("formServicio").reset();
        document.getElementById("idServicio").value = "";
        document.getElementById("accion").value = "registrar";
        document.getElementById("btnGuardar").textContent =
            "Guardar servicio";
        document.getElementById("tituloFormulario").textContent =
            "Registrar servicio";
    }
</script>

</body>
</html>
