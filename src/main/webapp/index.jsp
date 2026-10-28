
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Milmar Sorpresas | Sistema Web</title>

    <style>
        * {
            box-sizing: border-box;
        }

        

body {
    margin: 0;
    min-height: 100vh;
    font-family: Arial, sans-serif;
    color: #302344;

    background-image:
        linear-gradient(
            rgba(245, 240, 255, 0.25),
            rgba(245, 240, 255, 0.25)
        ),
        url("imagenes/fondo.jpg"); /* <-- Ruta relativa limpia y directa */

    background-size: cover;
    background-position: center center;
    background-repeat: no-repeat;
    background-attachment: fixed;
}


        header {
            background: rgba(103, 58, 183, 0.94);
            color: white;
            padding: 25px 8%;
            text-align: center;
        }

        header h1 {
            margin: 0;
            font-size: 32px;
        }

        header p {
            margin-bottom: 0;
            font-size: 16px;
        }

        main {
            width: 90%;
            max-width: 1000px;
            margin: 45px auto;
        }

        .panel {
            background: rgba(255, 255, 255, 0.94);
            padding: 35px;
            border-radius: 18px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(48, 35, 68, 0.15);
        }

        h2 {
            color: #673ab7;
            font-size: 28px;
            margin-top: 0;
        }

        .panel p {
            font-size: 17px;
            line-height: 1.7;
        }

        .boton {
            display: inline-block;
            margin-top: 15px;
            background: #673ab7;
            color: white;
            padding: 13px 25px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s, transform 0.3s;
        }

        .boton:hover {
            background: #512da8;
            transform: translateY(-2px);
        }

        .titulo-servicios {
            text-align: center;
            color: #512da8;
            margin-top: 35px;
            margin-bottom: 20px;
        }

        .tarjetas {
            display: grid;
            grid-template-columns: repeat(
                auto-fit,
                minmax(200px, 1fr)
            );
            gap: 20px;
            margin-top: 22px;
        }

        .tarjeta {
            background: rgba(255, 255, 255, 0.94);
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 6px 18px rgba(48, 35, 68, 0.12);
            transition: transform 0.3s;
        }

        .tarjeta:hover {
            transform: translateY(-5px);
        }

        .tarjeta h3 {
            color: #673ab7;
            font-size: 21px;
        }

        .tarjeta p {
            line-height: 1.6;
        }

        footer {
            text-align: center;
            padding: 25px;
            margin-top: 35px;
            background: rgba(255, 255, 255, 0.85);
            color: #514365;
        }

        @media (max-width: 600px) {
            header {
                padding: 22px 5%;
            }

            header h1 {
                font-size: 25px;
            }

            main {
                width: 92%;
                margin: 25px auto;
            }

            .panel {
                padding: 25px 18px;
            }

            h2 {
                font-size: 24px;
            }
        }
    </style>
</head>

<body>

    <header>
        <h1>🎁 Milmar Sorpresas</h1>
        <p>Organiza momentos especiales en un solo lugar.</p>
    </header>

    <main>

        <section class="panel">
            <h2>¡Bienvenido a Milmar Sorpresas!</h2>

            <p>
                Gestiona los servicios, clientes y pedidos de tu negocio
                de sorpresas desde una sola plataforma.
            </p>

            <p>
                Haz que cada celebración se convierta en un momento
                inolvidable.
            </p>

            <a class="boton"
               href="<%=request.getContextPath()%>/login.jsp">
                🔐 Iniciar sesión
            </a>
        </section>

        <h2 class="titulo-servicios">
            Nuestros módulos
        </h2>

        <section class="tarjetas">

            <article class="tarjeta">
                <h3>🎉 Servicios</h3>
                <p>
                    Consulta y organiza los servicios disponibles
                    para cada ocasión especial.
                </p>
            </article>

            <article class="tarjeta">
                <h3>👥 Clientes</h3>
                <p>
                    Administra la información de tus clientes
                    de forma ordenada.
                </p>
            </article>

            <article class="tarjeta">
                <h3>📋 Pedidos</h3>
                <p>
                    Organiza las solicitudes y lleva el control
                    de los pedidos de tus clientes.
                </p>
            </article>

        </section>

    </main>

    <footer>
        <p>
            © 2026 Milmar Sorpresas
           
        </p>
    </footer>

</body>
</html>
