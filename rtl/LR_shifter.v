module LR_shifter
#(
parameter DATAWIDTH = 8
)
(
input                 clk_i,
input                 rst_n,
input [DATAWIDTH-1:0] data_i,
input                 valid_i,
input                 sh_en,
input                 sh_rl,  // if sh_rl = 1 --> shift right, sh_rl = 0 --> sh
output                ready_o,
output                sdo
);
reg   [DATAWIDTH-1:0] shift_reg;
reg   [DATAWIDTH-1:0] shift_reg_next;


always@(*) begin
if(valid_i)               shift_reg_next = data_i;
else if (sh_en &&  sh_rl) shift_reg_next = {1'b0, shift_reg[DATAWIDTH-1:1]};
else if (sh_en && !sh_rl) shift_reg_next = {shift_reg[DATAWIDTH-2:0], 1'b0};
else                      shift_reg_next = shift_reg;
end



always@(posedge clk_i, negedge rst_n) begin
if (!rst_n)          shift_reg <= 0;
else                 shift_reg <= shift_reg_next;
end

// assigning ready signal when the shift is done

assign ready_o = (shift_reg == 0);

// assign the serial data output bit to the LSB or MSB of the shifter only if the shifter is enabled
assign sdo = (sh_rl)? shift_reg[0]: shift_reg[DATAWIDTH-1];



endmodule
