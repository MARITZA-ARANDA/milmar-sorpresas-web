
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    int clientes = (Integer) request.getAttribute("totalClientes");
    int servicios = (Integer) request.getAttribute("serviciosActivos");
    int pedidos = (Integer) request.getAttribute("totalPedidos");
    double ingresos = (Double) request.getAttribute("ingresosPagados");
    int pendientes = (Integer) request.getAttribute("pagosPendientes");

    NumberFormat moneda = NumberFormat.getCurrencyInstance(
        Locale.forLanguageTag("es-PE"));
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes | Milmar Sorpresas</title>

    <style>
        * { box-sizing: border-box; }

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
            flex-wrap: wrap;
            gap: 15px;
        }

        header h1 { margin: 0; font-size: 24px; }

        header a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        main {
            max-width: 1100px;
            margin: 30px auto;
            padding: 0 18px;
        }

        .rejilla {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
        }

        .tarjeta {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 14px rgba(0,0,0,.07);
        }

        .tarjeta h2 {
            font-size: 16px;
            color: #667085;
            margin-top: 0;
        }

        .valor {
            font-size: 30px;
            font-weight: bold;
            color: #713b8f;
            overflow-wrap: anywhere;
        }

        .descripcion {
            color: #667085;
            font-size: 13px;
        }

        .boton {
            display: inline-block;
            background: #713b8f;
            color: white;
            text-decoration: none;
            padding: 12px 18px;
            border-radius: 7px;
            margin-top: 25px;
        }
    </style>
</head>

<body>
<header>
    <h1>Milmar Sorpresas | Reportes</h1>
    <a href="<%= request.getContextPath() %>/panel.jsp">
        Volver al panel
    </a>
</header>

<main>
    <h2>Resumen general del negocio</h2>
    <p>Indicadores calculados a partir de los registros de MySQL.</p>

    <div class="rejilla">
        <section class="tarjeta">
            <h2>Total de clientes</h2>
            <div class="valor"><%= clientes %></div>
            <p class="descripcion">Clientes registrados.</p>
        </section>

        <section class="tarjeta">
            <h2>Servicios activos</h2>
            <div class="valor"><%= servicios %></div>
            <p class="descripcion">Servicios disponibles.</p>
        </section>

        <section class="tarjeta">
            <h2>Total de pedidos</h2>
            <div class="valor"><%= pedidos %></div>
            <p class="descripcion">Pedidos registrados.</p>
        </section>

        <section class="tarjeta">
            <h2>Ingresos pagados</h2>
            <div class="valor"><%= moneda.format(ingresos) %></div>
            <p class="descripcion">
                Suma de los pagos con estado Pagado.
            </p>
        </section>

        <section class="tarjeta">
            <h2>Pagos pendientes</h2>
            <div class="valor"><%= pendientes %></div>
            <p class="descripcion">Pagos aún no confirmados.</p>
        </section>
    </div>

    <a class="boton"
       href="<%= request.getContextPath() %>/panel.jsp">
        Regresar al menú principal
    </a>
</main>
</body>
</html>
