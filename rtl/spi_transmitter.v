module spi_transmitter
(
input       clk_i,
input       rst_n,
input       sample,
input       en,
input [7:0] data_i,
input       lsbf,
input       valid_i,
output      ready_o,
output      sdo
);


localparam IDLE     = 1'b0,
	   TRANSMIT = 1'b1;


reg  state, next_state;
reg  load;
wire shifter_ready;
wire sdo_val;

LR_shifter tx_shifter
(
.clk_i   (clk_i),
.rst_n   (rst_n),
.data_i  (data_i),
.valid_i (load),
.sh_en   (sample),
.sh_rl   (lsbf),
.ready_o (shifter_ready),
.sdo     (sdo_val)
);

// Transmitter Finite State Machine
/***********************************************************/
always@(*) begin
load         = 0;

case(state) 

IDLE: begin
if(en && valid_i) begin
load = 1;
next_state      = TRANSMIT;
end 
else next_state = IDLE;
end


TRANSMIT: begin
if(shifter_ready) 
next_state = IDLE;
else begin
next_state = TRANSMIT;
end
end

endcase
end

always@(posedge clk_i, negedge rst_n) begin
if(!rst_n) 
state   <= IDLE;
else begin 
state   <= next_state;
end
end


assign ready_o = shifter_ready;
assign sdo     = (!ready_o)? sdo_val: 1'b0;
endmodule
