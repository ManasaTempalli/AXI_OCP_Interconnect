//AXI Write Front End
`include "gen_macros.sv"
`include "gen_definitions.sv"
typedef struct packed{
 logic [3:0] id;
 logic [3:0] length;
 logic [31:0] addr;
}axi_addr_pkt;

typedef struct packed{
 logic [3:0] id;
 logic [3:0] length;
 logic [31:0] d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,d0;
} axi_data_pkt;

typedef struct packed{
 logic [3:0] id;
 logic [3:0] length;
 logic [31:0] addr;
 logic [31:0] d15, d14, d13, d12, d11, d10, d9, d8, d7, d6, d5, d4, d3, d2, d1, d0;
}axi_addr_data_pkt;

module axi_wr_front_end(
 input logic clk,rst,
 axi_wr_addr_intf.SLAVE addr_intf,
 axi_wr_data_intf.SLAVE data_intf,
 axi_wr_resp_intf.MASTER resp_intf,
 input logic hold_in,
 output logic axi_wr_pkt_vld,
 output axi_addr_data_pkt axi_wr_pkt);
 
 logic addr_fifo_we, addr_fifo_re, addr_fifo_full, addr_fifo_empty;
 logic data_fifo_we, data_fifo_re, data_fifo_full, data_fifo_empty;
 
 axi_addr_pkt addr_fifo_wdata, addr_fifo_rdata;
 logic[511:0] data_fifo_wdata, data_fifo_rdata;
 logic[31:0] din, d15, d14, d13, d12, d11, d10, d9, d8, d7, d6, d5, d4, d3, d2, d1, d0;
 logic [3:0] dcount, dcount_nxt;
 logic wlast_prev, dclear,data_val;

 FIFO #(.WIDTH($bits(axi_addr_pkt)),.DEPTH(4),.PTR_SIZE(2)) axi_addr_fifo(
.clk(clk),
.rst(rst),
.we(addr_fifo_we),
.wdata(addr_fifo_wdata),
.re(addr_fifo_re),
.rdata(addr_fifo_rdata),
.full(addr_fifo_full),
.empty(addr_fifo_empty));

 FIFO #(.WIDTH($bits(512)),.DEPTH(4),.PTR_SIZE(2)) axi_data_fifo(
.clk(clk),
.rst(rst),
.we(data_fifo_we),
.wdata(data_fifo_wdata),
.re(data_fifo_re),
.rdata(data_fifo_rdata),
.full(data_fifo_full),
.empty(data_fifo_empty));

always @(posedge clk)
begin
 addr_fifo_we = addr_intf.awvalid&addr_intf.awready;
 addr_fifo_wdata.id=addr.intf.awid;
 addr_fifo_wdata.length=addr_intf.awlen;
 addr_fifo_wdata.addr=addr_intf.awaddr;
 addr_intf.awready=!addr_fifo_full;
 addr_fifo_re= axi_wr_pkt_vld&!hold_in;

 data_fifo_we=wlast_prev;
 data_fifo_wdata[511:0] = {d15,d14,d13, d12, d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,d0};
 
 data_intf.wready=!data_fifo_full;
 data_fifo_re=axi_wr_pkt_vld&!hold_in;
 
 din[31:0]=data_intf.wdata[31:0];
 dcount_nxt[3:0]=data_intf.wlast?4'b0:(data_intf.wvalid & data_intf.wready)?dcount_nxt[3:0]+4'h1:dcount[3:0];
 dclear=!(dcount==4'b0);
 data_val=data_intf.wvalid & data_intf.wlast;
end
 

`DFF_async_rst(dcount,dcount_nxt,clk,rst,'0)
`DFF_async_rst(wlast_prev,data_val,clk,rst,'0)

always @(posedge clk)
begin
 axi_wr_pkt_vld=!addr_fifo_empty & !data_fifo_empty;
 axi_wr_pkt.id=addr_fifo_rdata.id;
 axi_wr_pkt.length=addr_fifo_rdata.length;
 axi_wr_pkt.addr=addr_fifo_rdata.addr;
 {axi_wr_pkt.d15,axi_wr_pkt.d14,axi_wr_pkt.d13,axi_wr_pkt.d12,axi_wr_pkt.d11,axi_wr_pkt.d10,axi_wr_pkt.d9,axi_wr_pkt.d8,
axi_wr_pkt.d7,axi_wr_pkt.d6,axi_wr_pkt.d5,axi_wr_pkt.d4,axi_wr_pkt.d3,axi_wr_pkt.d2,axi_wr_pkt.d1,axi_wr_pkt.d0} = data_fifo_rdata;
 //Response signals
 resp_intf.bvalid=data_fifo_re;
 resp_intf.bid=data_fifo_re?axi_wr_okt.id:'hX;
 resp_intf.bresp=data_fifo_re?OKAY:'hX;
end
`DFF_async_rst_en(d0,din,(dcount==4'h0),clk,rst)
`DFF_async_rst_en(d1,din,(dcount==4'h1),clk,(rst|dclear))
`DFF_async_rst_en(d2,din,(dcount==4'h2),clk,(rst|dclear))
`DFF_async_rst_en(d3,din,(dcount==4'h3),clk,(rst|dclear))
`DFF_async_rst_en(d4,din,(dcount==4'h4),clk,(rst|dclear))
`DFF_async_rst_en(d5,din,(dcount==4'h5),clk,(rst|dclear))
`DFF_async_rst_en(d6,din,(dcount==4'h6),clk,(rst|dclear))
`DFF_async_rst_en(d7,din,(dcount==4'h7),clk,(rst|dclear))
`DFF_async_rst_en(d8,din,(dcount==4'h8),clk,(rst|dclear))
`DFF_async_rst_en(d9,din,(dcount==4'h9),clk,(rst|dclear))
`DFF_async_rst_en(d10,din,(dcount==4'hA),clk,(rst|dclear))
`DFF_async_rst_en(d11,din,(dcount==4'hB),clk,(rst|dclear))
`DFF_async_rst_en(d12,din,(dcount==4'hC),clk,(rst|dclear))
`DFF_async_rst_en(d13,din,(dcount==4'hD),clk,(rst|dclear))
`DFF_async_rst_en(d14,din,(dcount==4'hE),clk,(rst|dclear))
`DFF_async_rst_en(d15,din,(dcount==4'hF),clk,(rst|dclear))

endmodule: axi_wr_front_end