
package pe.sorpresas.entidades;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Pago {

    private int idPago;
    private int idPedido;
    private Timestamp fechaPago;
    private BigDecimal monto;
    private String metodoPago;
    private String estadoPago;
    private String numeroOperacion;
    private String observacion;

    public Pago() {
    }

    public Pago(int idPago, int idPedido, Timestamp fechaPago,
                BigDecimal monto, String metodoPago,
                String estadoPago, String numeroOperacion,
                String observacion) {
        this.idPago = idPago;
        this.idPedido = idPedido;
        this.fechaPago = fechaPago;
        this.monto = monto;
        this.metodoPago = metodoPago;
        this.estadoPago = estadoPago;
        this.numeroOperacion = numeroOperacion;
        this.observacion = observacion;
    }

    public int getIdPago() {
        return idPago;
    }

    public void setIdPago(int idPago) {
        this.idPago = idPago;
    }

    public int getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }

    public Timestamp getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(Timestamp fechaPago) {
        this.fechaPago = fechaPago;
    }

    public BigDecimal getMonto() {
        return monto;
    }

    public void setMonto(BigDecimal monto) {
        this.monto = monto;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public void setMetodoPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }

    public String getEstadoPago() {
        return estadoPago;
    }

    public void setEstadoPago(String estadoPago) {
        this.estadoPago = estadoPago;
    }

    public String getNumeroOperacion() {
        return numeroOperacion;
    }

    public void setNumeroOperacion(String numeroOperacion) {
        this.numeroOperacion = numeroOperacion;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }
}
