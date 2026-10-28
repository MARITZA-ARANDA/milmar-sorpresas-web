

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="pe.sorpresas.entidades.Cliente" %>

<%
    HttpSession sesion = request.getSession(false);

    if (sesion == null || sesion.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Cliente> clientes =
        (List<Cliente>) request.getAttribute("clientes");

    String mensaje = request.getParameter("mensaje");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Clientes - Milmar Sorpresas</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/estilos.css">

    <style>
        * {
            box-sizing: border-box;
        }

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

        header h1 {
            margin-top: 0;
        }

        header a {
            color: white;
            margin-right: 18px;
            text-decoration: none;
            font-weight: bold;
        }

        header a:hover {
            text-decoration: underline;
        }

        main {
            max-width: 1200px;
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
            font-weight: bold;
        }

        input, select, button {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        input:focus, select:focus {
            outline: 2px solid #e9a4c8;
            border-color: #b83280;
        }

        button {
            cursor: pointer;
            background: #b83280;
            color: white;
            border: none;
            font-weight: bold;
        }

        button:hover {
            opacity: 0.88;
        }

        .botones {
            display: flex;
            gap: 10px;
            align-items: end;
            flex-wrap: wrap;
        }

        .limpiar {
            background: #666;
        }

        .editar {
            background: #2471a3;
        }

        .eliminar {
            background: #a61b1b;
        }

        /* Encabezado de la lista de clientes */
        .encabezado-clientes {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 15px;
        }

        .encabezado-clientes h3 {
            margin-top: 0;
            margin-bottom: 5px;
        }

        /* Botón de exportación a Excel */
        .boton-excel {
            display: inline-block;
            padding: 11px 16px;
            background: #217346;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: bold;
        }

        .boton-excel:hover {
            background: #185c37;
            text-decoration: none;
        }

        .tabla-contenedor {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 850px;
        }

        th, td {
            padding: 10px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }

        th {
            background: #f8dce9;
        }

        tbody tr:hover {
            background: #fff8fb;
        }

        .acciones {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .acciones form {
            margin: 0;
        }

        .mensaje {
            padding: 12px;
            background: #f8dce9;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        .nota {
            color: #666;
            font-size: 13px;
        }

        @media (max-width: 600px) {
            main {
                padding: 10px;
            }

            .panel {
                padding: 15px;
            }

            header a {
                display: inline-block;
                margin-bottom: 10px;
            }

            .boton-excel {
                width: 100%;
                text-align: center;
            }
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

        <a href="<%= request.getContextPath() %>/CerrarSesionServlet">
            Cerrar sesión
        </a>
    </nav>
</header>

<main>

    <h2>Registro de clientes</h2>

    <p>Registra y administra los clientes de Milmar Sorpresas.</p>

    <% if (mensaje != null && !mensaje.isBlank()) { %>
        <div class="mensaje">
            <%= mensaje.replace("&", "&amp;")
                       .replace("<", "&lt;")
                       .replace(">", "&gt;")
                       .replace("\"", "&quot;")
                       .replace("'", "&#39;") %>
        </div>
    <% } %>

    <!-- FORMULARIO DE REGISTRO Y EDICIÓN -->
    <section class="panel" id="formularioClientes">

        <h3 id="tituloFormulario">Datos del cliente</h3>

        <p class="nota">
            Los campos marcados con * son obligatorios.
        </p>

        <form id="formCliente"
              action="<%= request.getContextPath() %>/clientes"
              method="post"
              class="form-grid">

            <input type="hidden"
                   name="accion"
                   id="accion"
                   value="registrar">

            <input type="hidden"
                   name="idCliente"
                   id="idCliente"
                   value="">

            <label>
                Nombres *
                <input type="text"
                       name="nombres"
                       id="nombres"
                       maxlength="80"
                       autocomplete="given-name"
                       required>
            </label>

            <label>
                Apellidos *
                <input type="text"
                       name="apellidos"
                       id="apellidos"
                       maxlength="80"
                       autocomplete="family-name"
                       required>
            </label>

            <label>
                Tipo de documento *
                <select name="tipoDocumento"
                        id="tipoDocumento"
                        required>
                    <option value="">Seleccionar</option>
                    <option value="DNI">DNI</option>
                    <option value="CE">Carné de extranjería</option>
                    <option value="PASAPORTE">Pasaporte</option>
                </select>
            </label>

            <label>
                Número de documento *
                <input type="text"
                       name="nroDocumento"
                       id="nroDocumento"
                       maxlength="20"
                       required>
            </label>

            <label>
                Teléfono
                <input type="text"
                       name="telefono"
                       id="telefono"
                       maxlength="25"
                       autocomplete="tel">
            </label>

            <label>
                Correo electrónico
                <input type="email"
                       name="correo"
                       id="correo"
                       maxlength="120"
                       autocomplete="email">
            </label>

            <div class="botones">
                <button type="submit" id="btnGuardar">
                    Guardar cliente
                </button>

                <button type="button"
                        class="limpiar"
                        onclick="reiniciarFormulario()">
                    Nuevo / Limpiar
                </button>
            </div>

        </form>
    </section>

    <!-- TABLA DE CLIENTES -->
    <section class="panel">

        <div class="encabezado-clientes">
            <div>
                <h3>Clientes registrados</h3>
                <p class="nota">
                    Consulta tus clientes o descarga la lista en Excel.
                </p>
            </div>

            <a class="boton-excel"
               href="<%= request.getContextPath() %>/ExportarClientesServlet">
                &#128229; Exportar a Excel
            </a>
        </div>

        <div class="tabla-contenedor">

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombres</th>
                        <th>Apellidos</th>
                        <th>Documento</th>
                        <th>N.º documento</th>
                        <th>Teléfono</th>
                        <th>Correo</th>
                        <th>Acciones</th>
                    </tr>
                </thead>

                <tbody>

                <% if (clientes != null && !clientes.isEmpty()) {
                       for (Cliente c : clientes) { %>

                    <tr>
                        <td><%= c.getIdCliente() %></td>

                        <td><%= escapar(c.getNombres()) %></td>

                        <td><%= escapar(c.getApellidos()) %></td>

                        <td><%= escapar(c.getTipoDocumento()) %></td>

                        <td><%= escapar(c.getNroDocumento()) %></td>

                        <td><%= escapar(c.getTelefono()) %></td>

                        <td><%= escapar(c.getCorreo()) %></td>

                        <td>
                            <div class="acciones">

                                <button type="button"
                                        class="editar"
                                        onclick="editarCliente(this)"
                                        data-id="<%= c.getIdCliente() %>"
                                        data-nombres="<%= escaparAtributo(c.getNombres()) %>"
                                        data-apellidos="<%= escaparAtributo(c.getApellidos()) %>"
                                        data-tipo="<%= escaparAtributo(c.getTipoDocumento()) %>"
                                        data-documento="<%= escaparAtributo(c.getNroDocumento()) %>"
                                        data-telefono="<%= escaparAtributo(c.getTelefono()) %>"
                                        data-correo="<%= escaparAtributo(c.getCorreo()) %>">
                                    Editar
                                </button>

                                <form action="<%= request.getContextPath() %>/clientes"
                                      method="post"
                                      onsubmit="return confirm('¿Deseas eliminar este cliente?');">

                                    <input type="hidden"
                                           name="accion"
                                           value="eliminar">

                                    <input type="hidden"
                                           name="idCliente"
                                           value="<%= c.getIdCliente() %>">

                                    <button type="submit" class="eliminar">
                                        Eliminar
                                    </button>
                                </form>

                            </div>
                        </td>
                    </tr>

                <%     }
                   } else { %>

                    <tr>
                        <td colspan="8">
                            No hay clientes registrados.
                        </td>
                    </tr>

                <% } %>

                </tbody>
            </table>

        </div>
    </section>

</main>

<script>
    function editarCliente(boton) {
        const datos = boton.dataset;

        document.getElementById("idCliente").value = datos.id;
        document.getElementById("nombres").value = datos.nombres;
        document.getElementById("apellidos").value = datos.apellidos;
        document.getElementById("tipoDocumento").value = datos.tipo;
        document.getElementById("nroDocumento").value = datos.documento;
        document.getElementById("telefono").value = datos.telefono;
        document.getElementById("correo").value = datos.correo;

        document.getElementById("accion").value = "actualizar";
        document.getElementById("btnGuardar").textContent =
            "Actualizar cliente";

        document.getElementById("tituloFormulario").textContent =
            "Editar datos del cliente";

        document.getElementById("formularioClientes").scrollIntoView({
            behavior: "smooth",
            block: "start"
        });
    }

    function reiniciarFormulario() {
        document.getElementById("formCliente").reset();

        document.getElementById("accion").value = "registrar";
        document.getElementById("idCliente").value = "";

        document.getElementById("btnGuardar").textContent =
            "Guardar cliente";

        document.getElementById("tituloFormulario").textContent =
            "Datos del cliente";
    }
</script>

</body>
</html>

<%!
    // Escapa texto para mostrarlo de forma segura en la tabla.
    public String escapar(String valor) {
        if (valor == null) {
            return "";
        }

        return valor.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    // Escapa texto para insertarlo en atributos HTML.
    public String escaparAtributo(String valor) {
        return escapar(valor);
    }
%>
