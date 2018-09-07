typedef struct packed{
 logic [3:0] id;
 logic [3:0] length;
 logic [31:0] addr;
}axi_addr_pkt;

module axi_rd_front_end(
 input logic clk,rst,
 axi_rd_addr_intf.SLAVE addr_intf,
 input logic hold_in,
 output logic axi_rd_pkt_vld,
 output axi_addr_pkt axi_rd_pkt);
 
 logic addr_fifo_we, addr_fifo_re, addr_fifo_full, addr_fifo_empty;
 
 axi_addr_pkt addr_fifo_wdata, addr_fifo_rdata;

 FIFO #(.WIDTH($bits(axi_addr_pkt)),.DEPTH(4),.PTR_SIZE(2)) axi_addr_fifo(
.clk(clk),
.rst(rst),
.we(addr_fifo_we),
.wdata(addr_fifo_wdata),
.re(addr_fifo_re),
.rdata(addr_fifo_rdata),
.full(addr_fifo_full),
.empty(addr_fifo_empty));

always @(posedge clk)
begin
 addr_fifo_we = addr_intf.arvalid&addr_intf.arready;
 addr_fifo_wdata.id=addr.intf.arid;
 addr_fifo_wdata.length=addr_intf.arlen;
 addr_fifo_wdata.addr=addr_intf.araddr;
 addr_intf.arready=!addr_fifo_full;
 addr_fifo_re= axi_rd_pkt_vld&!hold_in;

 axi_rd_pkt_vld=!addr_fifo_empty;
 axi_rd_pkt.id=addr_fifo_rdata.id;
 axi_rd_pkt.length=addr_fifo_rdata.length;
 axi_rd_pkt.addr=addr_fifo_rdata.addr;
 
end
endmodule: axi_rd_front_end