module LR_shifter
#(
parameter DATAWIDTH = 8
)
(
input                 clk_i,
input                 rst_n,
input [DATAWIDTH-1:0] data;
input                 ld,
input                 sh_en,
input                 sh_rl,  // if sh_rl = 1 --> shift right, sh_rl = 0 --> sh
output                sdo
);
reg   [DATAWIDTH-1:0] shift_reg;

always@(posedge clk_i, negedge rst_n) begin
if(!rst_n) shift_reg <= 0;
else if(ld) shfit_reg <= data;
else if (sh_en && sh_rl)  shift_reg <= {1'b0, shift_reg[DATAWIDTH-1:1]};
else if (sh_en && !sh_rl) shift_reg <= {shift_reg[DATAWIDTH-2:0], 1'b0};
end
);

// assign the serial data output bit to the LSB or MSB of the shifter only if the shifter is enabled,
// else it will be assigned a zero if the shifter is disabled.

assign sdo = (sh_en) && ((sh_rl)? shift_reg[0]: shift_reg[DATAWIDTH-1]);

endmodule
