module spi_tx_tb;
logic clk_i;
logic rst_n;
logic sample;
logic lsbf;
logic en;
logic [7:0] data_i;
logic valid_i;
logic ready_o;
logic sdo;

logic sclk_en;

initial begin
clk_i = 0;
forever #5 clk_i = ~clk_i;
end

spi_transmitter spi_tx_dut
(
.clk_i  (clk_i),
.rst_n  (rst_n),
.sample (sample),
.en     (en),
.data_i (data_i),
.lsbf   (lsbf),
.valid_i(valid_i),
.ready_o(ready_o),
.sdo    (sdo)
);

baudrate_gen baudrate_dut
(
.clk_i  (clk_i),
.rst_n  (rst_n),
.sclk_en(sclk_en),
.cpol   (0),
.cpha   (0),
.SPR    (3'b0),
.SPPR   (3'b0),
.sclk   (sclk),
.sample (sample)
);


initial tx_drive();
initial reset();

initial begin
#1000;
$finish;
end

task tx_drive();
fork 
forever begin
@(posedge clk_i);
data_i  <= $urandom;
valid_i <= 1;
end
join_none
en      <= 1;
lsbf    <= 1;
sclk_en <= 1;
endtask


task reset();
rst_n = 1;
#2;
rst_n = 0;
#2;
rst_n = 1;
endtask

endmodule
