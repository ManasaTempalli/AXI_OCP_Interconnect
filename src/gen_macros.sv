`define DFF_async_rst(d_in, d_out, clk, rst, rst_val='0)\
always @ (posedge clk or negedge clk) \
begin \
 if(rst===1'bX)\
 begin \
  d_out<=#1 'X;\
 end \
 else if(rst===1'b0)\
 begin \
  d_out<=#1 rst_val;\
 end \
 else if(clk===1'bX)\
 begin \
  d_out<=#1 'X;\
 end \
 else \
 begin \
  d_out<=#1 d_in;\
 end \
end \

//async rst with enable
`define DFF_async_rst_en(d_in,d_out,enable,clk,rst)\
always @ (posedge clk or negedge clk)\
begin \
 if(rst===1'bX)\
 begin \
  d_out<=#1 'X;\
 end \
 else if( rst===1'b0)\
 begin \
  d_out<=#1 '0;\
 end \
 else if( clk===1'bX || enable===1'bX)\
 begin \
  d_out<=#1 'X;\
 end \
 else if( enable===1'b1)\
 begin \
  d_out<=#1 d_in;\
 end \
end \

//mux2
`define mux_2(d0,d1,sel,out)\
always_comb \
begin \
unique casez(sel) \
 1'b0: out = d0; \
 1'b1: out = d1; \
 default: out = 'x; \
endcase \
end \

`define mux_4(d0,d1,d2,d3,sel,out)\
always_comb \
begin \
unique casez(sel) \
 2'b00: out = d0; \
 2'b01: out = d1; \
 2'b10: out = d2; \
 2'b11: out = d3; \
 default: out = 'x; \
endcase \
end \

`define mux_8(d0,d1,d2,d3,d4,d5,d6,d7,sel,out)\
always_comb \
begin \
unique casez(sel) \
 3'b000: out = d0; \
 3'b001: out = d1; \
 3'b010: out = d2; \
 3'b011: out = d3; \
 3'b100: out = d4; \
 3'b101: out = d5; \
 3'b110: out = d6; \
 3'b111: out = d7; \
 default: out = 'x; \
endcase \
end \

`define mux_16(d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,sel,out)\
always_comb \
begin \
unique casez(sel) \
4'b0000:out=d0; \
4'b0001:out=d1; \
4'b0010:out=d2; \
4'b0011:out=d3; \
4'b0100:out=d4; \
4'b0101:out=d5; \
4'b0110:out=d6; \
4'b0111:out=d7; \
4'b1000:out=d8; \
4'b1001:out=d9; \
4'b1010:out=d10; \
4'b1011:out=d11; \
4'b1100:out=d12; \
4'b1101:out=d13; \
4'b1110:out=d14; \
4'b1111:out=d15; \
default:out='x; \
endcase \
end
