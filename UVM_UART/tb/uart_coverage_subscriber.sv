class uart_coverage_subscriber extends uvm_subscriber #(uart_transaction);

`uvm_component_utils(uart_coverage_subscriber)

	//uart_transaction uart_mon_data;

	uart_transaction cov_data;

	extern function new(string name="uart_coverage_subscriber",uvm_component parent);
	extern function void write(uart_transaction t);
	//extern task run_phase(uvm_phase phase);


	covergroup uart_coverage;
	//covergroup ctrl_reg_coverage;
		option.per_instance=1;
		option.name="UART COVERAGE";
		UART_CTRL_REG:coverpoint cov_data.ctrl_reg{ bins rb_thr = {0};
																								bins ier    = {1};
																								bins iir_fcr= {2};
																								bins lcr    = {3};
																								bins lsr    = {5}; }
	//endgroup:ctrl_reg_coverage

	//covergroup txn_coverage;
		//option.per_instance=1;
		UART_TXN_REG:coverpoint cov_data.txn_reg {  bins b0 = {[0:31]};
																								bins b1 = {[32:63]};
																								bins b2 = {[64:95]};
																								bins b3 = {[96:127]};
																								bins b4 = {[128:159]};
																								bins b5 = {[160:191]};
																								bins b6 = {[192:223]};
																								bins b7 = {[224:255]}; }
	//endgroup:txn_coverage
	
	//covergroup lcr_reg_coverage;
		//option.per_instance=1;
		//Number of bits in each character
		UART_LCR_REG_0:coverpoint cov_data.lcr_reg[1:0] {	bins bits_5 = {0};
																											bins bits_6 = {1};
																											bins bits_7 = {2};
																											bins bits_8 = {3}; }
		//Number of generated stop bits
		UART_LCR_REG_1:coverpoint cov_data.lcr_reg[2] {	bins stop_bit_1 = {0};
																										bins stop_bit_2 = {1}; }
		//Parity enable
		UART_LCR_REG_2:coverpoint cov_data.lcr_reg[3] {	bins no_parity = {0};
																										bins parity    = {1}; }
		//Even Parity select
		UART_LCR_REG_3:coverpoint cov_data.lcr_reg[4] {	bins odd_parity = {0};
																										bins even_parity= {1}; }
		//Stick parity bit
		UART_LCR_REG_4:coverpoint cov_data.lcr_reg[5] {	bins no_stick_parity = {0};
																										bins stick_parity    = {1}; }
		//Break control bit
		UART_LCR_REG_5:coverpoint cov_data.lcr_reg[6] {	bins break_en = {0};
																										bins break_dis= {1}; }
		//Divisor latch access bit
		UART_LCR_REG_6:coverpoint cov_data.lcr_reg[7] {	bins dl_reg_access     = {0};
																										bins normal_reg_access = {1}; }
	//endgroup:lcr_reg_coverage

	//covergroup ier_reg_coverage;
		//option.per_instance=1;
		UART_IER_REG_0:coverpoint cov_data.ier[0] {	bins rda_dis = {0};
																								bins rda_en  = {1};}
		UART_IER_REG_1:coverpoint cov_data.ier[1] {	bins thre_dis = {0};
																								bins thre_en  = {1};}
		UART_IER_REG_2:coverpoint cov_data.ier[2] {	bins rls_dis = {0};
																								bins rls_en  = {1};}			
	//	UART_IER_REG_3:cross UART_IER_REG_0, UART_IER_REG_1, UART_IER_REG_2;
	//endgroup:ier_reg_coverage

	//covergroup fcr_reg_coverage;
		//option.per_instance=1;
		UART_FCR_REG_0:coverpoint cov_data.fcr[1] {	bins rst_rf_en  = {0};
																								bins rst_rf_dis = {1};}
		UART_FCR_REG_1:coverpoint cov_data.fcr[2] {	bins rst_tf_en  = {0};
																								bins rst_tf_dis = {1};}
		UART_FCR_REG_2:coverpoint cov_data.fcr[7:6] {	bins trggr_lvl_1  = {0};
																									bins trggr_lvl_4  = {1};
																									bins trggr_lvl_8  = {2};
																									bins trggr_lvl_14 = {3}; }																				
	//endgroup:fcr0_reg_coverage

	//covergroup iir_reg_coverage;
		//option.per_instance=1;
		UART_IIR_REG:coverpoint cov_data.iir[3:0] {	bins rls_int  = {6};
																								bins rda_int  = {4};
																								bins ti_int   = {12};
																								bins thre_int = {2}; }
	//endgroup:iir_reg_coverage

	//covergroup lsr_reg_coverage;
		//option.per_instance=1;
		UART_LSR_REG:coverpoint cov_data.lsr[4:1] {	bins oe = {1};
																								bins pe = {2,6};
																								bins fe = {4,6};
																								bins bi = {8}; }
	//endgroup:lsr_reg_coverage
	endgroup
	
endclass

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function uart_coverage_subscriber::new(string name="uart_coverage_subscriber",uvm_component parent);
		super.new(name,parent);
		uart_coverage=new();
	endfunction

	function void uart_coverage_subscriber::write(uart_transaction t);
			cov_data=t;
			uart_coverage.sample();
	endfunction


/*	
	task uart_coverage_subscriber::run_phase(uvm_phase phase);
			forever
				begin
					 		uart_fifo.get(uart_mon_data);	
							cov_data=uart_mon_data;
							uart_coverage.sample();
				end
	endtask
*/
	
