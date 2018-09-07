typedef enum {MASTER=0,SLAVE=1} agent_type;
typedef enum {READ=0,WRITE=1} rd_wr_type;

typedef enum logic[1:0]{
NULL=2'b00, //No response
DVA=2'b01, //Data valid
FAIL=2'b10, // Request failed
ERROR=2'b11 //Response Error
}OCP_SResp;

typedef enum logic[2:0]{
IDLE=3'b000, //Idle
WR=3'b001, //Write
RD=3'b010, //Read
RDEX=3'b011, //Read Execute
RDL=3'b100, //Read Linked
WRNP=3'b101, // Write Non Post
WRC=3'b110, //Write Conditional
BCST=3'b111 //Broadcast
}OCP_MCmd;

typedef enum logic[1:0]{
OKAY=2'b00,
EXOKAY=2'b01,
SLVERR=2'b10,
DECERR=2'b11
}
AXI_WrResp;