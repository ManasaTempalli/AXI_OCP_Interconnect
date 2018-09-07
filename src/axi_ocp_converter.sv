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
module axi_ocp_converter(input clk, rst,
axi_wr_addr_intf.SLAVE axi_wr_addr_intr1,axi_wr_addr_intf2,
axi_wr_data_intf.SLAVE axi_wr_data_intf1,axi_wr_data_intf2,
axi_wr_resp_intf.MASTER axi_wr_resp_intf1,axi_wr_resp_intf2,
axi_rd_addr_intf.SLAVE axi_rd_addr_intf1,axi_rd_addr_intf2,
ocp_intf.MASTER ocp_intf1);

logic hold_wrfe1,hold_wrfe2,hold_rdfe1,hold_rdfe2;
logic vld_wrfe1,vld_wrfe2,vld_rdfe1,vld_rdfe2;
axi_addr_data_pkt pkt_wrfe1,pk_wrfe2,wr_pkt;
axi_addr_pkt pkt_rdfe1,pkt_rdfe2,rd_pkt;
logic[31:0] d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,d0;

logic[3:0] axi_wr_cnt,axi_wr_cnt_prev;
logic[3:0] axi_wr_pk_length,axi_wr_pk_length_f;
logic axi_ocp_data_wr_start,axi_ocp_data_wr_end;
logic ocp_cmd,hold,ocp_data_hold;
logic rd_valid,wr_valid;
logic[31:0] axi_ocp_wr_data_dw;

logic IDLE_C1RD,IDLE_C2RD,IDLE_C1WR,IDLE_C2WR;
logic C1RD_C2RD,C1RD_C1WR,C1RD_C2WR,C1RD_IDLE;
logic C2RD_C1WR,C2RD_C2WR,C2RD_IDLE;
logic C1WR_C2WR,C1WR_IDLE;
logic C2WR_IDLE;

logic [3:0] ARB_ps,ARB_ns;

typedef enum logic[3:0]{
IDLE='h0,
C1RD='h1,
C2RD='h2,
C1WR='h3,
C2WR='h4}Arb_Client;

Arb_Client ARB_ps_e,ARB_ns_e;

always@(posedge clk)
begin
ARB_ps_e=Arb_Client'(ARB_ps);
ARB_ns_e=Arb_Client'(ARB_ns);
IDLE_C1RD = (ARB_ps==IDLE) & vld_rdfe1;
IDLE_C2RD = (ARB_ps==IDLE) & vld_rdfe2 & !vld_rdfe1;
IDLE_C1WR = (ARB_ps==IDLE) & vld_wrfe1 & !vld_rdfe2 & !vld_rdfe1;
IDLE_C1RD = (ARB_ps==IDLE) & vld_wrfe2 & !vld_wrfe1 & !vld_rdfe2 & !vld_rdfe1;

C1RD_C2RD = (ARB_ps==C1RD) & vld_rdfe1;
C1RD_C1WR = (ARB_ps==C1RD) & vld_wrfe1 & !vld_rdfe2;
C1RD_C2WR = (ARB_ps==C1RD) & vld_wrfe2 & !vld_wrfe1 & !vld_rdfe2;
C1RD_IDLE = (ARB_ps==C1RD) & !vld_wrfe2 & !vld_wrfe1 & !vld_rdfe2;

C2RD_C1WR = (ARB_ps==C2RD) & vld_wrfe1;
C2RD_C2WR = (ARB_ps==C2RD) & vld_wrfe2 & !vld_wrfe1;
C2RD_IDLE = (ARB_ps==C2RD) & !vld_wrfe2 & !vld_wrfe1;

C1WR_C2WR = (ARB_ps==C1WR) & vld_wrfe2 & axi_ocp_data_wr_end;
C1WR_IDLE = (ARB_ps==C1WR) & !vld_wrfe2 & axi_ocp_data_wr_end;

C2WR_IDLE = (ARB_ps==C2WR) & axi_ocp_data_wr_end;
end

always @(posedge clk)
begin
 unique casez(ARB_ps)
 IDLE: 
 begin
  if(IDLE_C1WR) ARB_ns=C1WR;
  else if(IDLE_C2WR) ARB_ns=C2WR;
  else if(IDLE_C1RD) ARB_ns=C1RD;
  else if(IDLE_C2RD) ARB_ns=C2RD;
  else ARB_ns=IDLE;
 end
 C1RD:
 begin
  if(C1RD_C2RD) ARB_ns=C2RD;
  else if(C1RD_C1WR) ARB_ns=C1WR;
  else if(C1RD_C2WR) ARB_ns=C2WR;
  else if(C1RD_IDLE) ARB_ns=IDLE;
  else ARB_ns=C1RD; 
 end
 C2RD:
 begin
  if(C2RD_C1WR) ARB_ns=C1WR;
  else if(C2RD_C2WR) ARB_ns=C2WR;
  else if(C2RD_IDLE) ARB_ns=IDLE;
  else ARB_ns=C2RD; 
 end
 C1WR:
 begin
  if(C1WR_C2WR) ARB_ns=C2WR;
  else if(C1WR_C2WR) ARB_ns=IDLE;
  else ARB_ns=C1WR; 
 end
 C2WR:
 begin
  if(C2WR_IDLE) ARB_ns=IDLE;
  else ARB_ns=C2WR; 
 end
 default: ARB_ns='X;
endcase
end

endmodule:axi_ocp_converter

