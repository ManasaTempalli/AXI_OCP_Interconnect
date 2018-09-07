interface axi_wr_addr_intf(input clk,rst);
logic[3:0] awid;
logic[31:0] awaddr;
logic[3:0] awlen;
logic[2:0] awsize;
logic[1:0] awburst;
logic[1:0] awlock;
logic[3:0] awcache;
logic[2:0] awprot;
logic awvalid;
logic awready;

modport MASTER(input clk,rst,output awid,awaddr,awlen,awsize,awburst,awlock,awcache,awprot,awvalid,input awready);
modport SLAVE(input clk,rst,awid,awaddr,awlen, awsize, awburst, awlock, awcache, awprot, awvalid, output awready);

endinterface: axi_wr_addr_intf

interface axi_wr_data_intf(input clk,rst);
logic[3:0] wid;
logic[31:0] wdata;
logic wstrb;
logic wlast;;
logic wvalid;
logic wready;

modport MASTER(input clk,rst, output wid,wdata,wstrb,wlast,wvalid, input wready);
modport SLAVE(input clk, rst, wid, wdata, wstrb, wlast, wvalid, output wready);

endinterface: axi_wr_data_intf

interface axi_wr_resp_intf(input clk, rst);
logic [3:0] bid;
logic [1:0] bresp;
logic bvalid;
logic bready;
modport SLAVE(input clk, rst, input bid, bresp, bvalid, output bready);
modport MASTER(input clk,rst, output bid, bresp, bvalid, input bready);
endinterface: axi_wr_resp_intf

interface axi_rd_addr_intf(input clk, rst);
logic [3:0] arid;
logic[31:0] araddr;
logic[3:0] arlen;
logic[2:0] arsize;
logic[1:0] arburst;
logic[1:0] arlock;
logic[3:0] arcache;
logic[2:0] arprot;
logic arvalid;
logic arready;

modport MASTER(input clk, rst, output arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arvalid,input arready);
modport SLAVE(input clk, rst, input arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arvalid, output arready);
endinterface: axi_rd_addr_intf

interface axi_rd_data_intf(input clk, rst);
logic[3:0] rid;
logic[31:0] rdata;
logic[1:0] rresp;
logic rlast;
logic rvalid;
logic rready;
modport SLAVE(input clk, rst, input rid, rdata, rresp, rlast, rvalid, output rready);
modport MASTER (input clk, rst, output rid, rdata, rresp, rlast, rvalid, input rready);
endinterface: axi_rd_data_intf

interface ocp_intf(input clk, rst);
logic [2:0] MCmd;
logic[31:0] MAddr;
logic[3:0] MBurstLength;
logic[3:0] MTagID;
logic MDataValid;
logic[31:0] MData;
logic MDataLast;
logic SCmdAccept;
logic SDataAccept;
logic[31:0] SData;
logic SRespLast;
logic [1:0] SResp;
logic[3:0] STagID;
logic MRespAccept;

modport MASTER(input clk,rst,output MCmd, MAddr, MBurstLength, MDataValid, MData, MDataLast, MTagID, MRespAccept, input SCmdAccept, SDataAccept, SData, SRespLast, SResp, STagID);
modport SLAVE(input clk,rst,input MCmd, MAddr, MBurstLength, MDataValid, MData, MDataLast, MTagID, MRespAccept, output SCmdAccept, SDataAccept, SData, SRespLast, SResp, STagID);
endinterface:ocp_intf

