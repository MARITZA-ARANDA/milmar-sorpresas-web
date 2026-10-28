
package pe.sorpresas.entidades;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Pedido {

    private int idPedido;
    private int idCliente;
    private Timestamp fechaPedido;
    private BigDecimal montoTotal;
    private String estadoPedido;
    private String estadoPago;

    public Pedido() {
    }

    public Pedido(int idPedido, int idCliente,
                  Timestamp fechaPedido, BigDecimal montoTotal,
                  String estadoPedido, String estadoPago) {
        this.idPedido = idPedido;
        this.idCliente = idCliente;
        this.fechaPedido = fechaPedido;
        this.montoTotal = montoTotal;
        this.estadoPedido = estadoPedido;
        this.estadoPago = estadoPago;
    }

    public int getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public Timestamp getFechaPedido() {
        return fechaPedido;
    }

    public void setFechaPedido(Timestamp fechaPedido) {
        this.fechaPedido = fechaPedido;
    }

    public BigDecimal getMontoTotal() {
        return montoTotal;
    }

    public void setMontoTotal(BigDecimal montoTotal) {
        this.montoTotal = montoTotal;
    }

    public String getEstadoPedido() {
        return estadoPedido;
    }

    public void setEstadoPedido(String estadoPedido) {
        this.estadoPedido = estadoPedido;
    }

    public String getEstadoPago() {
        return estadoPago;
    }

    public void setEstadoPago(String estadoPago) {
        this.estadoPago = estadoPago;
    }
}
