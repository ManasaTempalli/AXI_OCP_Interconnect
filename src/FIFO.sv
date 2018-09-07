/***************** FIFO ********************/
module FIFO #(
	      parameter WIDTH = 32,
	      parameter DEPTH = 8,
              parameter PTR_SIZE=3,
	      parameter	type T = logic [WIDTH-1:0]
	)(
	 input logic we,
	 input logic re,
	 input logic clk,
 	 input logic rst,
	 input logic [WIDTH-1:0] wdata,
	 output logic [WIDTH-1:0] rdata,
 	 output logic almost_full,
	 output logic full,
	 output logic empty,
	 output logic [3:0] wptr,
	 output logic [3:0] rptr
	  );
parameter FIFO_WIDTH=$bits(T);
parameter FIFO_DEPTH=DEPTH;
//parameter PTR_DEPTH=clogb2(DEPTH);

FIFO_control #(.DEPTH(FIFO_DEPTH),.WRSIZE(PTR_SIZE)) fifo_con1(.*);

logic [FIFO_DEPTH-1:0][FIFO_WIDTH-1:0] memory;

always @ (posedge clk)
begin
 if(rst==1)
 begin
  memory <= 'h0;
 end
 else if(we==1)
 begin
  memory[wptr] <= wdata;
 end
end

always_comb rdata = memory[rptr];

endmodule: FIFO

