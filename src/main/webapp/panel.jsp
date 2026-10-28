
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String usuario = String.valueOf(session.getAttribute("usuario"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Principal - Milmar Sorpresas</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f5f2f8;
            color: #342640;
        }

        .encabezado {
            background: #512b70;
            color: white;
            padding: 25px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .encabezado h1 {
            font-size: 27px;
            margin-bottom: 6px;
        }

        .encabezado p {
            font-size: 14px;
            color: #eee3f7;
        }

        .btn-cerrar {
            display: inline-block;
            background: #ffffff;
            color: #512b70;
            padding: 11px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
        }

        .btn-cerrar:hover {
            background: #eee3f7;
        }

        .contenedor {
            width: 92%;
            max-width: 1200px;
            margin: 35px auto;
        }

        .bienvenida {
            margin-bottom: 30px;
        }

        .bienvenida h2 {
            font-size: 25px;
            color: #512b70;
            margin-bottom: 8px;
        }

        .bienvenida p {
            color: #6b6272;
            line-height: 1.6;
        }

        .titulo-seccion {
            color: #512b70;
            font-size: 21px;
            margin-bottom: 18px;
        }

        .modulos {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 22px;
            margin-bottom: 35px;
        }

        .modulo {
            background: #ffffff;
            border: 1px solid #e8dff0;
            border-radius: 14px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(60, 30, 80, 0.08);
            min-width: 0;
        }

        .modulo h3 {
            color: #512b70;
            font-size: 19px;
            margin-bottom: 18px;
        }

        .modulo a {
            display: inline-block;
            background: #713b8f;
            color: #ffffff;
            text-decoration: none;
            padding: 11px 18px;
            border-radius: 8px;
            font-weight: bold;
        }

        .modulo a:hover {
            background: #512b70;
        }

        /* Tarjetas anchas de Pagos y Reportes */
        .modulos-extra {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 25px;
            width: 100%;
            margin: 0 auto 35px;
        }

        .modulo-card {
            display: flex;
            flex-direction: row;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            width: 100%;
            min-width: 0;
            min-height: 105px;
            padding: 22px 28px;
            margin: 0;
            background: #ffffff;
            border: 1px solid #e8dff0;
            border-radius: 14px;
            box-shadow: 0 4px 12px rgba(60, 30, 80, 0.10);
        }

        .modulo-icono {
            font-size: 32px;
            line-height: 1;
            flex-shrink: 0;
        }

        .modulo-card h2 {
            margin: 0;
            color: #512b70;
            font-size: 21px;
            flex: 1;
        }

        .modulo-card .btn-modulo {
            display: inline-block;
            position: static;
            flex-shrink: 0;
            padding: 11px 20px;
            background: #713b8f;
            color: #ffffff;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            white-space: nowrap;
        }

        .modulo-card .btn-modulo:hover {
            background: #512b70;
        }

        .pie {
            text-align: center;
            padding: 20px;
            color: #81758a;
            font-size: 13px;
        }

        @media (max-width: 850px) {
            .modulos {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .modulos-extra {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 550px) {
            .encabezado {
                padding: 22px;
            }

            .contenedor {
                width: 92%;
                margin: 25px auto;
            }

            .modulos {
                grid-template-columns: 1fr;
            }

            .modulo-card {
                gap: 12px;
                padding: 18px;
            }

            .modulo-card h2 {
                font-size: 18px;
            }

            .modulo-card .btn-modulo {
                padding: 10px 12px;
                font-size: 13px;
            }
        }
    </style>
</head>

<body>

    <header class="encabezado">
        <div>
            <h1>Milmar Sorpresas</h1>
            <p>Sistema web de gestión de eventos y sorpresas</p>
        </div>

        <a class="btn-cerrar"
           href="<%=request.getContextPath()%>/CerrarSesionServlet">
            Cerrar sesión
        </a>
    </header>

    <main class="contenedor">

        <section class="bienvenida">
            <h2>¡Bienvenido, <%=usuario%>!</h2>
            <p>Selecciona el módulo que deseas administrar.</p>
        </section>

        <h2 class="titulo-seccion">Gestión del sistema</h2>

        <section class="modulos">

            <div class="modulo">
                <h3>Clientes</h3>
                <a href="<%=request.getContextPath()%>/clientes">
                    Ingresar →
                </a>
            </div>

            <div class="modulo">
                <h3>Servicios</h3>
                <a href="<%=request.getContextPath()%>/servicios">
                    Ingresar →
                </a>
            </div>

            <div class="modulo">
                <h3>Pedidos</h3>
                <a href="<%=request.getContextPath()%>/pedidos">
                    Ingresar →
                </a>
            </div>

            <div class="modulo">
                <h3>Eventos y entregas</h3>
                <a href="<%=request.getContextPath()%>/eventos">
                    Ingresar →
                </a>
            </div>

        </section>

        <h2 class="titulo-seccion">Administración financiera</h2>

        <section class="modulos-extra">

            <div class="modulo-card">
                <span class="modulo-icono">💳</span>
                <h2>Pagos</h2>
                <a class="btn-modulo"
                   href="<%=request.getContextPath()%>/pagos">
                    Ingresar →
                </a>
            </div>

            <div class="modulo-card">
                <span class="modulo-icono">📊</span>
                <h2>Reportes</h2>
                <a class="btn-modulo"
                   href="<%=request.getContextPath()%>/reportes">
                    Ingresar →
                </a>
            </div>

        </section>

    </main>

    <footer class="pie">
        Milmar Sorpresas © 2026 | Sistema de gestión
    </footer>

</body>
</html>
