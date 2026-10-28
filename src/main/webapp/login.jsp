
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Iniciar sesión</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f2ecfc;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .login {
            background: white;
            padding: 35px;
            border-radius: 15px;
            width: 320px;
            box-shadow: 0 8px 25px #0002;
        }
        h2 { color: #673ab7; text-align: center; }
        label { display: block; margin-top: 15px; }
        input {
            box-sizing: border-box;
            width: 100%;
            padding: 12px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 7px;
        }
        button {
            width: 100%;
            margin-top: 22px;
            padding: 12px;
            border: 0;
            border-radius: 7px;
            background: #673ab7;
            color: white;
            cursor: pointer;
        }
        a { display: block; text-align: center; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="login">
        <h2>🎁 Iniciar sesión</h2>
        <form action="LoginServlet" method="post">
            <label for="usuario">Usuario</label>
            <input id="usuario" name="usuario"
                   type="text" required>

            <label for="clave">Contraseña</label>
            <input id="clave" name="clave"
                   type="password" required>

            <button type="submit">Ingresar</button>
        </form>
        <a href="index.jsp">Volver al inicio</a>
    </div>
</body>
</html>
