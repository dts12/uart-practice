#Makefile for UVM Testbench
RTL = ../rtl/*
INC = +incdir+../rtl +incdir+../agent_top +incdir+../test +incdir+../tb +incdir+../src 
#INC = +incdir+../agent_top +incdir+../test +incdir+../tb +incdir+../src 
SVTB =  ../agent_top/uart_agent_top.sv
SVTB1 = ../test/uart_test_pkg.sv
work = work
VSIMOPT= -novopt -sva -sv_seed random -l s.log work.uart_agent_top
VSIMBATCH1 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll mem_cov1;run -all;exit"
VSIMBATCH2 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll mem_cov2;run -all;exit"
VSIMBATCH3 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll mem_cov3;run -all;exit"
VSIMBATCH4 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll mem_cov4;run -all;exit"

html:
	C:/"Program Files"/Nightly/firefox.exe covhtmlreport/pages/__frametop.htm

log_file:
	D:\PERSONAL/notepad++.exe s.log

lib:
	vlib $(work)
	vmap work $(work)

sv_cmp:  lib comp0
         
run_sim:
	vsim $(VSIMOPT) $(VSIMBATCH1)    
	vcover report -html mem_cov1
	#vcover merge mem_cover mem_cov1 #mem_cov2 mem_cov3 mem_cov4
	#vcover report -html mem_cover

gui:
	vsim $(VSIMOPT) -coverage +UVM_OBJECTION_TRACE +UVM_TESTNAME=uart_base_test +UVM_VERBOSITY=UVM_MEDIUM 
	vcover report -html mem_cov1
	vcover merge mem_cover mem_cov1 #mem_cov2 mem_cov3 mem_cov4
	vcover report -html mem_cover
	
comp0:
	vlog -work $(work) $(RTL) $(INC) $(SVTB1) $(SVTB)

run_gui: clean lib comp0 gui

run_test: lib comp0
	vsim $(VSIMBATCH1) +UVM_OBJECTION_TRACE +UVM_TESTNAME=uart_base_test +UVM_VERBOSITY=UVM_MEDIUM -coverage -l s.log -sva -sv_seed random -novopt work.uart_agent_top	
	vcover report -html mem_cov1

run_test1:
	vsim $(VSIMBATCH2) +UVM_OBJECTION_TRACE +UVM_TESTNAME= +UVM_VERBOSITY=UVM_MEDIUM -coverage -l s.log -sva -sv_seed random -novopt work.uart_agent_top	
	vcover report -html mem_cov2

run_test2:
	vsim $(VSIMBATCH3) +UVM_OBJECTION_TRACE +UVM_TESTNAME= +UVM_VERBOSITY=UVM_MEDIUM -coverage -l s.log -sva -sv_seed random -novopt work.uart_agent_top
	vcover report -html mem_cov3

run_test3:
	vsim $(VSIMBATCH4) +UVM_OBJECTION_TRACE +UVM_TESTNAME=ram_even_addr_test +UVM_VERBOSITY=UVM_MEDIUM -coverage -l s.log -sva -sv_seed random -novopt work.uart_agent_top
	vcover report -html mem_cov4

clean:
	del /Q modelsim.* transcript* *log* vsim.wlf fcover* covhtml* mem_cov*
	rm -rf work
	clear
#clean:
#	rm -rf modelsim.* transcript* *log* work vsim.wlf fcover* covhtml* mem_cov*
#	clear	
report:
	vcover merge mem_cover mem_cov1 mem_cov2 mem_cov3 mem_cov4
	vcover report -html mem_cover

regress: clean run_test run_test1 
