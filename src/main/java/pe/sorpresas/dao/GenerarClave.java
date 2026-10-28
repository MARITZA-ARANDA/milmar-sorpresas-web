
package pe.sorpresas.dao;

import org.mindrot.jbcrypt.BCrypt;

public class GenerarClave {

    public static void main(String[] args) {
        String clave = "admin123";
        String hash = "$2a$10$0GkerdtVX15hk0hsuwbT4O0ldE9XFicdQ.Eq4.SnYhIGWohNvyqHK";

        System.out.println("Hash válido: " + BCrypt.checkpw(clave, hash));
    }
}
