RTL = ../rtl/LR_shifter.v ../rtl/baudrate_gen.v ../rtl/spi_transmitter.v
SVA =
TB = spi_tx_tb.sv 
verbosity = UVM_MEDIUM
uvm_compile_options = 
#compile_options = -ntb_opts uvm-1.1
compile_switches = -sverilog -assert enable_diag -lca -debug_access+all -timescale=1ns/1ns -kdb +vcs+vcdpluson -l comp.log ${uvm_compile_options} +define+ASSERT
#uvm_runtime_options = +UVM_VERBOSITY=${verbosity} +UVM_OBJECTION_TRACE 
uvm_runtime_options =
runtime_switches =  -l sim.log ${uvm_runtime_options} #-assert verbose
all: compile run

compile: 
	vcs ${RTL} ${TB} ${SVA} ${compile_switches}

run: 
	./simv ${runtime_switches}

dve:
	dve -vpd vcdplus.vpd

verdi:
	verdi -sverilog -ntb_opts uvm-1.1 ${RTL} ${TB} -ssf tb_top.fsdb -no_logo &

clean:
	rm -rf *report* simv* csrc* *.tmp *.vpd *.key log *.h temp *.log .vcs* *.txt DVE* *.hvp urg* .inter.vpd.uvm .restart* .synopsys* novas.* *.dat *.fsdb verdi* work* vlog*


