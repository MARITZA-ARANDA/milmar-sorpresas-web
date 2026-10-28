<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestión de Clientes | Milmar Sorpresas</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f2f8;
            margin: 0;
            color: #333;
        }
        header {
            background: #713b83;
            color: white;
            padding: 22px;
        }
        main {
            max-width: 1100px;
            margin: 25px auto;
            padding: 20px;
        }
        .panel {
            background: white;
            padding: 22px;
            margin-bottom: 22px;
            border-radius: 10px;
        }
        .formulario {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px;
        }
        input, select, button {
            box-sizing: border-box;
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background: #713b83;
            color: white;
            border: 0;
            cursor: pointer;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }
        th {
            background: #eee5f2;
        }
        .tabla {
            overflow-x: auto;
        }
        .volver {
            color: white;
        }
        @media(max-width: 650px) {
            .formulario {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<header>
    <h1>Milmar Sorpresas</h1>
    <p>Administración de clientes</p>
    <a class="volver"
       href="${pageContext.request.contextPath}/panel.jsp">
       Volver al panel principal
    </a>
</header>

<main>
    <section class="panel">
        <h2>Registrar cliente</h2>

        <form method="post"
              action="${pageContext.request.contextPath}/clientes"
              class="formulario">

            <input type="hidden" name="accion" id="accion" value="registrar">
<input type="hidden" name="idCliente" id="idCliente">

            <input type="text" name="nombres"
                   placeholder="Nombres" required maxlength="100">

            <input type="text" name="apellidos"
                   placeholder="Apellidos" required maxlength="100">

            <select name="tipoDocumento" required>
                <option value="">Tipo de documento</option>
                <option value="DNI">DNI</option>
                <option value="CE">Carné de extranjería</option>
                <option value="PASAPORTE">Pasaporte</option>
            </select>

            <input type="text" name="nroDocumento"
                   placeholder="Número de documento"
                   required maxlength="20">

            <input type="tel" name="telefono"
                   placeholder="Teléfono" maxlength="20">

            <input type="email" name="correo"
                   placeholder="Correo electrónico" maxlength="150">

            <button type="submit" id="btnGuardar">Guardar cliente</button>
<button type="reset" onclick="reiniciarFormulario()">Nuevo / Limpiar</button>
        </form>
    </section>

    <section class="panel">
        <h2>Clientes registrados</h2>

        <div class="tabla">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombres</th>
                        <th>Apellidos</th>
                        <th>Documento</th>
                        <th>Teléfono</th>
                        <th>Correo</th>
                        <th>Acción</th>
                    </tr>
                </thead>

<script>
function editarCliente(id, nombres, apellidos, tipoDocumento,
                       nroDocumento, telefono, correo) {

    document.getElementById("idCliente").value = id;
    document.getElementById("accion").value = "actualizar";

    document.getElementById("nombres").value = nombres;
    document.getElementById("apellidos").value = apellidos;
    document.getElementById("tipoDocumento").value = tipoDocumento;
    document.getElementById("nroDocumento").value = nroDocumento;
    document.getElementById("telefono").value = telefono || "";
    document.getElementById("correo").value = correo || "";

    document.getElementById("btnGuardar").textContent =
        "Guardar cambios";

    window.scrollTo({ top: 0, behavior: "smooth" });
}

function reiniciarFormulario() {
    document.getElementById("idCliente").value = "";
    document.getElementById("accion").value = "registrar";
    document.getElementById("btnGuardar").textContent =
        "Guardar cliente";
}
</script>
</body>
</html>

                <tbody>
                    <c:forEach var="c" items="${clientes}">
                        <tr>
                            <td><c:out value="${c.idCliente}"/></td>
                            <td><c:out value="${c.nombres}"/></td>
                            <td><c:out value="${c.apellidos}"/></td>
                            <td><c:out value="${c.nroDocumento}"/></td>
                            <td><c:out value="${c.telefono}"/></td>
                            <td><c:out value="${c.correo}"/></td>
                            <td>
                                <form method="post"
                                      action="${pageContext.request.contextPath}/clientes"
                                      onsubmit="return confirm('¿Eliminar este cliente?');">
                                    <input type="hidden" name="accion"
                                           value="eliminar">
                                    <input type="hidden" name="idCliente"
                                           value="${c.idCliente}">
                                    <button type="submit">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty clientes}">
                        <tr>
                            <td colspan="7">No hay clientes registrados.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
