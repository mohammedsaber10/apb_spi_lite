module baudrate_tb;
bit clk;
bit rst_n;
bit sclk_en;
logic sclk_o;
logic sample;
bit cpol, cpha;
initial begin
cpol = 0; cpha = 1;
sclk_en = 0;
#100;
sclk_en = 1;
#700;
sclk_en = 0;
end

initial begin
clk = 0;
forever #5 clk =~ clk;
end
initial reset();
initial begin 
#1000;
$finish;
end

task reset();
rst_n = 1;
#2;
rst_n = 0;
#2;
rst_n = 1;
endtask

baudrate_gen dut
(
.clk_i(clk),
.rst_n(rst_n),
.SPR(3'b000),
.SPPR(3'b000),
.sclk(sclk_o),
.sclk_en(sclk_en),
.cpol(cpol),
.cpha(cpha),
.sample(sample)
);


endmodule
