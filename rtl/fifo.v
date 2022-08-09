module fifo
#(
parameter DATAWIDTH = 8,
	  ADDRWIDTH = 3
)
(
input clk_i,
input rst_n,
input w_en,
input r_en,
input [DATAWIDTH-1:0] DataIn,
output[DATAWIDTH-1:0] DataOut,
output full,
output empty
);
localparam DEPTH = (1 << ADDRWIDTH);
reg  [ADDRWIDTH  :0] rptr, wptr;
wire [ADDRWIDTH-1:0] raddr, waddr;
reg  [DATAWIDTH-1:0] ram [0:DEPTH-1];

wire winc, rinc;
// increment the points in case of the enables is on in addition to the not full, and not empty
assign winc = ~full  & w_en;
assign rinc = ~empty & r_en;

// write pointer 
always@(posedge clk_i, negedge rst_n) begin
if(!rst_n) wptr <= 0;
else wptr <= wptr + winc;
end

// read pointer
always@(posedge clk_i, negedge rst_n) begin
if(!rst_n) rptr <= 0;
else rptr <= rptr + rinc;
end
// satisfying empty and full conditions
/******************************************************************/
assign empty = (rptr == wptr);
assign full  = ((rptr[ADDRWIDTH] != wptr[ADDRWIDTH]) && (rptr[ADDRWIDTH-1:0] == wptr[ADDRWIDTH-1:0]));

// assigning read and write address addresses
assign raddr = rptr[ADDRWIDTH-1:0];
assign waddr = wptr[ADDRWIDTH-1:0];

// connecting the dual port ram to the read and write addresses
always@(posedge clk_i) begin
if(winc) ram[waddr] <= DataIn; 
end

assign DataOut = ram[raddr];

`ifdef ASSERT_ON
assert property (
@(posedge clk_i) disable iff (!rst_n) 
(rptr == wptr) |-> empty
);
assert property (
@(posedge clk_i) disable iff (!rst_n) 
(rptr[3] != wptr[3]) && (rptr[2:0] == wptr[2:0]) |-> full
);
`endif
endmodule
