class uart_coverage extends uvm_scoreboard;

	`uvm_component_utils(uart_coverage)

	uvm_tlm_analysis_fifo #(uart_transaction) uart0_fifo;
	uvm_tlm_analysis_fifo #(uart_transaction) uart1_fifo;

	uart_transaction uart0_mon_data;
	uart_transaction uart1_mon_data;

	uart_transaction cov_data0;
	uart_transaction cov_data1;

	extern function new(string name="uart_coverage",uvm_component parent);
	//extern function void coverage_new();
	extern task run_phase(uvm_phase phase);
	//extern task uart0_coverage();
	//extern task uart1_coverage();


	covergroup uart0_coverage;
	//covergroup ctrl0_reg_coverage;
		option.per_instance=1;
		UART0_CTRL_REG:coverpoint cov_data0.ctrl_reg{ bins rb_thr = {0} ;
																									bins ier = {1};
																									bins iir_fcr = {2};
																									bins lcr = {3};
																									bins lsr ={5};
																									}
	//endgroup:ctrl0_reg_coverage

	//covergroup txn0_coverage;
		//option.per_instance=1;
		UART0_TXN_REG:coverpoint cov_data0.txn_reg {bins b0 = {[0:31]};
																								bins b1 = {[32:63]};
																								bins b2 = {[64:95]};
																								bins b3 = {[96:127]};
																								bins b4 = {[128:159]};
																								bins b5 = {[160:191]};
																								bins b6 = {[192:223]};
																								bins b7 = {[224:255]}; }
	//endgroup:txn0_coverage
	
	//covergroup lcr0_reg_coverage;
		//option.per_instance=1;
		//Number of bits in each character
		UART0_LCR_REG_0:coverpoint cov_data0.lcr_reg[1:0] {	bins bits_5 = {0};
																												bins bits_6 = {1};
																												bins bits_7 = {2};
																												bins bits_8 = {3}; }
		//Number of generated stop bits
		UART0_LCR_REG_1:coverpoint cov_data0.lcr_reg[2] {	bins stop_bit_1 = {0};
																											bins stop_bit_2 = {1}; }
		//Parity enable
		UART0_LCR_REG_2:coverpoint cov_data0.lcr_reg[3] {	bins no_parity = {0};
																											bins parity    = {1}; }
		//Even Parity select
		UART0_LCR_REG_3:coverpoint cov_data0.lcr_reg[4] {	bins odd_parity = {0};
																											bins even_parity    = {1}; }
		//Stick parity bit
		UART0_LCR_REG_4:coverpoint cov_data0.lcr_reg[5] {	bins no_stick_parity = {0};
																											bins stick_parity    = {1}; }
		//Break control bit
		UART0_LCR_REG_5:coverpoint cov_data0.lcr_reg[6] {	bins break_en = {0};
																											bins break_dis    = {1}; }
		//Divisor latch access bit
		UART0_LCR_REG_6:coverpoint cov_data0.lcr_reg[7] {	bins dl_reg_access = {0};
																											bins normal_reg_access    = {1}; }
	//endgroup:lcr0_reg_coverage

	//covergroup ier0_reg_coverage;
		//option.per_instance=1;
		UART0_IER_REG_0:coverpoint cov_data0.ier[0] {bins rda_dis = {0};
																								bins rda_en = {1};}
		UART0_IER_REG_1:coverpoint cov_data0.ier[1] {bins thre_dis = {0};
																								bins thre_en = {1};}
		UART0_IER_REG_2:coverpoint cov_data0.ier[2] {bins rls_dis = {0};
																								bins rls_en = {1};}			
		UART0_IER_REG_3:cross UART0_IER_REG_0, UART0_IER_REG_1, UART0_IER_REG_2;
	//endgroup:ier0_reg_coverage

	//covergroup fcr0_reg_coverage;
		//option.per_instance=1;
		UART0_FCR_REG_0:coverpoint cov_data0.fcr[1] {	bins rst_rf_en = {0};
																									bins rst_rf_dis = {1};}
		UART0_FCR_REG_1:coverpoint cov_data0.fcr[2] {	bins rst_tf_en = {0};
																									bins rst_tf_dis = {1};}
		UART0_FCR_REG_2:coverpoint cov_data0.fcr[7:6] {	bins trggr_lvl_1 = {0};
																										bins trggr_lvl_4 = {1};
																										bins trggr_lvl_8 = {2};
																										bins trggr_lvl_14 = {3}; }																				
	//endgroup:fcr0_reg_coverage

	//covergroup iir0_reg_coverage;
		//option.per_instance=1;
		UART0_IIR_REG:coverpoint cov_data0.iir[3:0] {	bins rls_int = {6};
																									bins rda_int = {4};
																									bins ti_int = {12};
																									bins thre_int = {2}; }
	//endgroup:iir0_reg_coverage

	//covergroup lsr0_reg_coverage;
		//option.per_instance=1;
		UART0_LSR_REG:coverpoint cov_data0.lsr[4:1] {	bins oe = {1};
																									bins pe = {2,6};
																									bins fe = {4,6};
																									bins bi = {8}; }
	//endgroup:lsr0_reg_coverage
	endgroup
	
	covergroup uart1_coverage;
	//covergroup ctrl1_reg_coverage;
		option.per_instance=1;																							
		UART1_CTRL_REG:coverpoint cov_data1.ctrl_reg{ bins rb_thr = {0} ;
																									bins ier = {1};
																									bins iir_fcr = {2};
																									bins lcr = {3};
																									bins lsr ={5};
																									}
	//endgroup:ctrl1_reg_coverage

	//covergroup txn1_coverage;
	//option.per_instance=1;
		UART1_TXN_REG:coverpoint cov_data1.txn_reg {bins b0 = {[0:31]};
																								bins b1 = {[32:63]};
																								bins b2 = {[64:95]};
																								bins b3 = {[96:127]};
																								bins b4 = {[128:159]};
																								bins b5 = {[160:191]};
																								bins b6 = {[192:223]};
																								bins b7 = {[224:255]}; }
	//endgroup:txn1_coverage
	
	//covergroup lcr1_reg_coverage;
		//option.per_instance=1;
		//Number of bits in each character
		UART1_LCR_REG_0:coverpoint cov_data1.lcr_reg[1:0] {	bins bits_5 = {0};
																												bins bits_6 = {1};
																												bins bits_7 = {2};
																												bins bits_8 = {3}; }
		//Number of generated stop bits
		UART1_LCR_REG_1:coverpoint cov_data1.lcr_reg[2] {	bins stop_bit_1 = {0};
																											bins stop_bit_2 = {1}; }
		//Parity enable
		UART1_LCR_REG_2:coverpoint cov_data1.lcr_reg[3] {	bins no_parity = {0};
																											bins parity    = {1}; }
		//Even Parity select
		UART1_LCR_REG_3:coverpoint cov_data1.lcr_reg[4] {	bins odd_parity = {0};
																											bins even_parity    = {1}; }
		//Stick parity bit
		UART1_LCR_REG_4:coverpoint cov_data1.lcr_reg[5] {	bins no_stick_parity = {0};
																											bins stick_parity    = {1}; }
		//Break control bit
		UART1_LCR_REG_5:coverpoint cov_data1.lcr_reg[6] {	bins break_en = {0};
																											bins break_dis    = {1}; }
		//Divisor latch access bit
		UART1_LCR_REG_6:coverpoint cov_data1.lcr_reg[7] {	bins dl_reg_access = {0};
																											bins normal_reg_access    = {1}; }
	//endgroup:lcr1_reg_coverage
	
	//covergroup ier1_reg_coverage;
		//option.per_instance=1;
		UART1_IER_REG_0:coverpoint cov_data1.ier[0] {bins rda_dis = {0};
																								bins rda_en = {1};}
		UART1_IER_REG_1:coverpoint cov_data1.ier[1] {bins thre_dis = {0};
																								bins thre_en = {1};}
		UART1_IER_REG_2:coverpoint cov_data1.ier[2] {bins rls_dis = {0};
																								bins rls_en = {1};}			
		UART1_IER_REG_3:cross UART1_IER_REG_0, UART1_IER_REG_1, UART1_IER_REG_2;
	//endgroup:ier1_reg_coverage
	
	//covergroup fcr1_reg_coverage;
		//option.per_instance=1;
		UART1_FCR_REG_0:coverpoint cov_data1.fcr[1] {	bins rst_rf_en = {0};
																									bins rst_rf_dis = {1};}
		UART1_FCR_REG_1:coverpoint cov_data1.fcr[2] {	bins rst_tf_en = {0};
																									bins rst_tf_dis = {1};}
		UART1_FCR_REG_2:coverpoint cov_data1.fcr[7:6] {	bins trggr_lvl_1 = {0};
																										bins trggr_lvl_4 = {1};
																										bins trggr_lvl_8 = {2};
																										bins trggr_lvl_14 = {3}; }					
	//endgroup:fcr1_reg_coverage
	
	//covergroup iir1_reg_coverage;
		//option.per_instance=1;
		UART1_IIR_REG:coverpoint cov_data1.iir[3:0] {	bins rls_int = {6};
																									bins rda_int = {4};
																									bins ti_int = {12};
																									bins thre_int = {2}; }
	//endgroup:iir1_reg_coverage
	
	//covergroup lsr1_reg_coverage;
		//option.per_instance=1;
		UART1_LSR_REG:coverpoint cov_data1.lsr[4:1] {	bins oe = {1};
																									bins pe = {2,6};
																									bins fe = {4,6};
																									bins bi = {8}; }
	//endgroup:lsr1_reg_coverage
	
	endgroup


endclass

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function uart_coverage::new(string name="uart_coverage",uvm_component parent);
		super.new(name,parent);
		uart0_fifo=new("uart0_fifo",this);
	  uart1_fifo=new("uart1_fifo",this);		
		//coverage_new();
	//endfunction
	
	//function void uart_coverage::coverage_new();
		//uart0
		/*
		ctrl0_reg_coverage=new();
		lcr0_reg_coverage=new();
		txn0_coverage=new();
		ier0_reg_coverage=new();  
		fcr0_reg_coverage=new();
		iir0_reg_coverage=new();  
		//dl0_reg_coverage=new();
		lsr0_reg_coverage=new();
		//uart1
		ctrl1_reg_coverage=new();
		lcr1_reg_coverage=new();
		txn1_coverage=new();
		ier1_reg_coverage=new();  
		fcr1_reg_coverage=new();
		iir1_reg_coverage=new();  
		//dl1_reg_coverage=new();
		lsr1_reg_coverage=new();*/

		uart0_coverage=new();
		uart1_coverage=new();
	endfunction
	
	task uart_coverage::run_phase(uvm_phase phase);
			forever
				begin
					fork
						begin
					 		uart0_fifo.get(uart0_mon_data);	
							//uart0_coverage();
							cov_data0=uart0_mon_data;
							//if(cov_data0.lsr[2]) begin
							//cov_data0.print();
							//$stop; 
							//end
							uart0_coverage.sample();
						end
						begin
							uart1_fifo.get(uart1_mon_data);
							cov_data1=uart1_mon_data;
							//uart1_coverage();
							//if(cov_data1.lsr[2]) begin
						//	cov_data1.print();
							//$stop; 
						//	end
							uart1_coverage.sample();
						end
					join
				end
	endtask
/*	
	//Coverage
	task uart_coverage::uart0_coverage();
		cov_data0=uart0_mon_data;
		ctrl0_reg_coverage.sample();
		lcr0_reg_coverage.sample();
		//foreach(cov_data1.txn_reg_2sb[i])
		txn0_coverage.sample();
		ier0_reg_coverage.sample();
		fcr0_reg_coverage.sample();
		iir0_reg_coverage.sample();
		lsr0_reg_coverage.sample();

	endtask
	
	task uart_coverage::uart1_coverage();
		cov_data1=uart1_mon_data;
		ctrl1_reg_coverage.sample();
		lcr1_reg_coverage.sample();
		//foreach(cov_data1.txn_reg_2sb[i])
		txn1_coverage.sample();
		ier1_reg_coverage.sample();
		fcr1_reg_coverage.sample();
		iir1_reg_coverage.sample();
		lsr1_reg_coverage.sample();

	endtask
*/
/*
`uvm_info("UART0_COVERAGE",$sformatf("========================Printing from COVERAGE====================== \n %s",uart0_mon_data.sprint()),UVM_LOW)
`uvm_info("UART1_COVERAGE",$sformatf("========================Printing from COVERAGE====================== \n %s",uart1_mon_data.sprint()),UVM_LOW)
*/
