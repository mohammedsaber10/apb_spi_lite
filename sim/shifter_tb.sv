module shfiter_tb;
// inputs
bit   clk;
bit   rst_n;
logic [7:0] data;
logic ld;
logic sh_en;
logic sh_rl;
// outputs
logic sdo;

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial reset();


LR_shifter dut
(
.clk_i(clk),
.rst_n(rst_n),
.data(data),
.ld(ld),
.sh_en(sh_en),
.sh_rl(sh_rl),
.sdo(sdo)
);

initial drive();

initial begin
#1000;
$finish;
end

task drive();
@(posedge clk);
ld    <= 1;
data  <= $urandom;
sh_en <= 0;
@(posedge clk);
ld <= 0;
sh_rl <= 1;
forever begin
repeat(4) @(posedge clk);
sh_en <= 1;
@(posedge clk);
sh_en <= 0;
end
endtask

task reset();
rst_n = 1;
#2;
rst_n = 0;
#2;
rst_n = 1;
endtask



endmodule
