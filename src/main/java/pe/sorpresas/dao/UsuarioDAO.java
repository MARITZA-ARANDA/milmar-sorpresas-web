
package pe.sorpresas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class UsuarioDAO {

    public boolean validarUsuario(String username, String clave)
            throws SQLException {

        String sql = "SELECT password_hash FROM usuario "
                   + "WHERE username = ? AND estado = 'Activo'";

        try (Connection con = Conexion.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String hash = rs.getString("password_hash");

                    if (hash == null || clave == null) {
                        return false;
                    }

                    // Comprobar que sea un hash BCrypt
                    if (!(hash.startsWith("$2a$")
                            || hash.startsWith("$2b$")
                            || hash.startsWith("$2y$"))) {
                        return false;
                    }

                    return BCrypt.checkpw(clave, hash);
                }
            }
        }

        return false;
    }
}
