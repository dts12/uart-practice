`timescale 1ns/10ps

module uart_verification_top;


import uart_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "timescale.v"

logic clock0,clock1;

//uart_interface duv_if0(clock0);                            ///////////**************************mistake
//uart_interface if1(clock1);
uart_interface if0(clock0);
uart_interface if1(clock1);

//uart_top
uart_top DUV_0(	.wb_clk_i(clock0), 
									.wb_rst_i(if0.wb_rst_i), 
									.wb_adr_i(if0.wb_adr_i), 
									.wb_dat_i(if0.wb_dat_i), 
									.wb_dat_o(if0.wb_dat_o), 
									.wb_we_i(if0.wb_we_i), 
									.wb_stb_i(if0.wb_stb_i), 
									.wb_cyc_i(if0.wb_cyc_i), 
									.wb_ack_o(if0.wb_ack_o), 
									.wb_sel_i(if0.wb_sel_i),
									// interrupt request
								  .int_o(if0.int_o),   
									// UART	signals serial input/output
									.stx_pad_o(if1.srx_pad_i), 
									.srx_pad_i(if1.stx_pad_o), 	
									//.stx_pad_o(if0.stx_pad_o), 
									//.srx_pad_i(if0.srx_pad_i), 	
								  // modem signals
									.rts_pad_o(if0.rts_pad_o),
									.cts_pad_i(if0.cts_pad_i),
									.dtr_pad_o(if0.dtr_pad_o), 
									.dsr_pad_i(if0.dsr_pad_i), 
									.ri_pad_i(if0.ri_pad_i), 
									.dcd_pad_i(if0.dcd_pad_i),
									.baud_o(if0.baud_o) );

////////////////////////////////////////////////wire ****************************

uart_top DUV_1(	.wb_clk_i(clock1), 
									.wb_rst_i(if1.wb_rst_i), 
									.wb_adr_i(if1.wb_adr_i), 
									.wb_dat_i(if1.wb_dat_i), 
									.wb_dat_o(if1.wb_dat_o), 
									.wb_we_i(if1.wb_we_i), 
									.wb_stb_i(if1.wb_stb_i), 
									.wb_cyc_i(if1.wb_cyc_i), 
									.wb_ack_o(if1.wb_ack_o), 
									.wb_sel_i(if1.wb_sel_i),
									// interrupt request
								  .int_o(if1.int_o),   
									// UART	signals serial input/output
									.stx_pad_o(if1.stx_pad_o), 
									.srx_pad_i(if1.srx_pad_i), 	
								  // modem signals
									.rts_pad_o(if1.rts_pad_o),
									.cts_pad_i(if1.cts_pad_i),
									.dtr_pad_o(if1.dtr_pad_o), 
									.dsr_pad_i(if1.dsr_pad_i), 
									.ri_pad_i(if1.ri_pad_i), 
									.dcd_pad_i(if1.dcd_pad_i),
									.baud_o(if1.baud_o) );

initial
	begin
		
		uvm_config_db #(virtual uart_interface) ::set(null,"*","vif0",if0); 	
		uvm_config_db #(virtual uart_interface) ::set(null,"*","vif1",if1); 
		
		run_test();

		//#1000;
		$finish;
	end

initial
	begin
		clock0=0;
		forever #50 clock0=~clock0;             //clock speed 10M
	end

initial
	begin
		clock1=0;
		forever #25 clock1=~clock1;            //clock speed 20M
	end

endmodule
