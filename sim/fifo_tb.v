module fifo_tb;

bit clk;
bit rst_n;
logic w_en;
logic r_en;
logic [7:0] DataIn;
logic [7:0] DataOut;
logic full;
logic empty;


initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
rst_n = 1;
#2;
rst_n = 0;
#5;
rst_n = 1;


task drive();
forever begin
@(posedge clk);
w_en   <= 1;
r_en   <= 0;
DataIn <= $urandom;
end
endtask

initial drive();

fifo dut
(
.clk_i  (clk    ),
.rst_n  (rst_n  ),
.w_en   (w_en   ),
.r_en   (r_en   ),
.DataIn (DataIn ),
.DataOut(DataOut),
.full   (full   ),
.empty  (empty  )
);

initial begin
#1000;
$finish;
end


endmodule
