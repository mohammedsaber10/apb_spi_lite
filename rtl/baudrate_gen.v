module baudrate_gen
(
input clk_i,
input rst_n,
input sclk_en,
input cpol,
input cpha,
input [2:0] SPR,	// Baudrate pre-selection bits
input [2:0] SPPR,	// Baudrate selection bits
output reg sclk,        // Baudrate serial output clock
output sample
);

wire [11:0] BaudrateDivisor; // we need 11 wires to accomodate for baudrate divisor calculations (SPPR + 1) << SPR + 1 needs 11 bits
assign BaudrateDivisor = (SPPR + 1) << (SPR + 1);

reg [11:0] counter; // clock divider register
wire count_done;
wire sample_cpha0;
wire sample_cpha1;
reg sample_enable;
// clock dividor counter
always @(posedge clk_i, negedge rst_n)
if(!rst_n)
counter    <= 0;
else if(count_done) // clear the counter only if the count is done. 
counter    <= 0;
else
counter <= counter + 1;
assign count_done = (counter == BaudrateDivisor - 1);


// sclk generation
always @(posedge clk_i, negedge rst_n)
if(!rst_n)
	sclk <= cpol;
else if(sclk_en && count_done) 
	sclk <= ~sclk;
else if (!sclk_en) 
	sclk <= cpol; 

// sample pulse generation
// sample signal is 1 for one system clock cycle only, not sclk cycle
// sample signal is 1 if the divider counter value is 0 (i.e. when the sclk starts to toggle, providing sync. sampling with the serial clock)
// for cpha = 0 --> the sample pulse is generated at the first (rising/falling) edge of the sclk
// for cpha = 1 --> the sample pulse is generated at the secend (rising/falling) edge of the sclk


// registering/latching sclk enable so that the sample clock enable is sync. with the system clock for glitch immunning
// Therefore no glitches will be occurred 
always @(posedge clk_i, negedge rst_n) begin
if(!rst_n) sample_enable <= 0;
else if (sclk_en) sample_enable <= 1;
else sample_enable <= 0;
end


assign sample_cpha0 = sample_enable && ((!cpol &&  sclk) || (cpol && !sclk)) && (counter == 0);
assign sample_cpha1 = sample_enable && ((!cpol && !sclk) || (cpol &&  sclk)) && (counter == 0);
assign sample       = (cpha)? sample_cpha1 : sample_cpha0;


endmodule
