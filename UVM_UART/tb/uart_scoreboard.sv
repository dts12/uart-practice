class uart_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(uart_scoreboard)

	parameter uart_data_width = 8;
	parameter uart_addr_width = 3;
	//parameter uart_data_width = `UART_DATA_WIDTH;
	//parameter uart_addr_width = `UART_ADDR_WIDTH;
	uvm_tlm_analysis_fifo #(uart_transaction) uart0_fifo;
	uvm_tlm_analysis_fifo #(uart_transaction) uart1_fifo;

	uart_transaction uart0_mon_data;
	uart_transaction uart1_mon_data;

	logic [uart_data_width-1:0]txn0[$];
	logic [uart_data_width-1:0]rxn0[$];

	logic [uart_data_width-1:0]txn1[$];
	logic [uart_data_width-1:0]rxn1[$];

	int no_of_bits0;
	int no_of_bits1;

	extern function new(string name="uart_scoreboard",uvm_component parent);
	extern task run_phase(uvm_phase phase);
	extern task store_uart0_txn_rxn();
	extern task store_uart1_txn_rxn();
	extern task compare_uart0_txn_rxn();
	extern task compare_uart1_txn_rxn();
	extern task compare0_5bits();
	extern task compare0_6bits();
	extern task compare0_7bits();
	extern task compare0_8bits();
	extern task compare1_5bits();
	extern task compare1_6bits();
	extern task compare1_7bits();
	extern task compare1_8bits();

endclass

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function uart_scoreboard::new(string name="uart_scoreboard",uvm_component parent);
		super.new(name,parent);
		uart0_fifo=new("uart0_fifo",this);
	  uart1_fifo=new("uart1_fifo",this);		
	endfunction

	task uart_scoreboard::run_phase(uvm_phase phase);
			forever
				begin
					fork
						begin
					 		uart0_fifo.get(uart0_mon_data);	
							store_uart0_txn_rxn();
							compare_uart0_txn_rxn();
						end
						begin
							uart1_fifo.get(uart1_mon_data);
							store_uart1_txn_rxn();
							compare_uart1_txn_rxn();
						end
					join
				end
	endtask

	//Storing 
	task uart_scoreboard::store_uart0_txn_rxn();
		if(uart0_mon_data.we && uart0_mon_data.ctrl_reg==0 && ~uart0_mon_data.lcr_reg[7])
			txn0=uart0_mon_data.txn_reg_2sb;
		else if(~uart0_mon_data.we && uart0_mon_data.ctrl_reg==0 )
			rxn0=uart0_mon_data.rxn_reg_2sb;
	endtask

	task uart_scoreboard::store_uart1_txn_rxn();
		if(uart1_mon_data.we && uart1_mon_data.ctrl_reg==0 && ~uart1_mon_data.lcr_reg[7])
			txn1=uart1_mon_data.txn_reg_2sb;
		else if(~uart1_mon_data.we && uart1_mon_data.ctrl_reg==0)
			rxn1=uart1_mon_data.rxn_reg_2sb;
	endtask
	
	task uart_scoreboard::compare0_5bits();
		foreach(rxn0[i])
			if(rxn0[i][4:0]!=txn1[i][4:0])
				`uvm_fatal("UART0_SCOREBOARD","MISMATCH IN RECEIVED DATA,TRIGGER LEVEL 14 byte")
		$display("UART0:MATCH IN RECEIVED DATA, TRIGGER LEVEL 14 byte");
	endtask
	
	task uart_scoreboard::compare0_6bits();
		foreach(rxn0[i])
			if(rxn0[i][5:0]!=txn1[i][5:0])
				`uvm_fatal("UART0_SCOREBOARD","MISMATCH IN RECEIVED DATA,TRIGGER LEVEL 14 byte")
		$display("UART0:MATCH IN RECEIVED DATA, TRIGGER LEVEL 14 byte");
	endtask

	task uart_scoreboard::compare0_7bits();
		foreach(rxn0[i])
			if(rxn0[i][6:0]!=txn1[i][6:0])
				`uvm_fatal("UART0_SCOREBOARD","MISMATCH IN RECEIVED DATA,TRIGGER LEVEL 14 byte")
		$display("UART0:MATCH IN RECEIVED DATA, TRIGGER LEVEL 14 byte");
	endtask

	task uart_scoreboard::compare0_8bits();
		foreach(rxn0[i])
			if(rxn0[i][7:0]!=txn1[i][7:0])
				`uvm_fatal("UART0_SCOREBOARD","MISMATCH IN RECEIVED DATA,TRIGGER LEVEL 14 byte")
		$display("UART0:MATCH IN RECEIVED DATA, TRIGGER LEVEL 14 byte");
	endtask

	task uart_scoreboard::compare1_5bits();
		foreach(rxn0[i])
			if(rxn1[i][4:0]!=txn0[i][4:0])
				`uvm_fatal("UART1_SCOREBOARD","MISMATCH IN RECEIVED DATA,TRIGGER LEVEL 14 byte")
		$display("UART1:MATCH IN RECEIVED DATA, TRIGGER LEVEL 14 byte");
	endtask

	task uart_scoreboard::compare1_6bits();
		foreach(rxn0[i])
			if(rxn1[i][5:0]!=txn0[i][5:0])
				`uvm_fatal("UART1_SCOREBOARD","MISMATCH IN RECEIVED DATA,TRIGGER LEVEL 14 byte")
		$display("UART1:MATCH IN RECEIVED DATA, TRIGGER LEVEL 14 byte");
	endtask

	task uart_scoreboard::compare1_7bits();
		foreach(rxn0[i])
			if(rxn1[i][6:0]!=txn0[i][6:0])
				`uvm_fatal("UART1_SCOREBOARD","MISMATCH IN RECEIVED DATA,TRIGGER LEVEL 14 byte")
		$display("UART1:MATCH IN RECEIVED DATA, TRIGGER LEVEL 14 byte");
	endtask

	task uart_scoreboard::compare1_8bits();
		foreach(rxn0[i])
			if(rxn1[i][7:0]!=txn0[i][7:0])
				`uvm_fatal("UART1_SCOREBOARD","MISMATCH IN RECEIVED DATA,TRIGGER LEVEL 14 byte")
		$display("UART1:MATCH IN RECEIVED DATA, TRIGGER LEVEL 14 byte");
	endtask


	//Comparing
	task uart_scoreboard::compare_uart0_txn_rxn();
		if(uart0_mon_data.iir=='hC4)
			begin
				case(uart0_mon_data.fcr[7:6])
					2'b00: 
							if(rxn0.size()==1)
							begin
								case(uart0_mon_data.lcr_reg[1:0])
									2'b00:compare0_5bits();
									2'b01:compare0_6bits();
									2'b10:compare0_7bits();
									2'b11:compare0_8bits();
								endcase
							end
				2'b01:if(rxn0.size()==4)
							begin
								case(uart0_mon_data.lcr_reg[1:0])
									2'b00:compare0_5bits();									
									2'b01:compare0_6bits();
									2'b10:compare0_7bits();
									2'b11:compare0_8bits();
								endcase
							end
				2'b10:if(rxn0.size()==8)
							begin
								case(uart0_mon_data.lcr_reg[1:0])
									2'b00:compare0_5bits();									
									2'b01:compare0_6bits();
									2'b10:compare0_7bits();
									2'b11:compare0_8bits();
								endcase
							end
				2'b11:if(rxn0.size()==14)
							begin
							case(uart0_mon_data.lcr_reg[1:0])
									2'b00:compare0_5bits();									
									2'b01:compare0_6bits();
									2'b10:compare0_7bits();
									2'b11:compare0_8bits();
								endcase
							end
						default:	$display("In uart0 compare task default case");
				endcase
				`uvm_info("UART0_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart0_mon_data.sprint()),UVM_LOW) 										
				`uvm_info("UART1_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart1_mon_data.sprint()),UVM_LOW) 										
			end
		else if(uart0_mon_data.iir=='hCC)
			begin
				case(uart0_mon_data.lcr_reg[1:0])
					2'b00:if(rxn0[0][4:0]!=txn1[0][4:0])
									`uvm_fatal("UART0_SCOREBOARD","MISMATCH IN RECEIVED DATA,TIMEOUT INDICATION")
								else
									$display("UART0:MATCH IN RECEIVED DATA, TIMEOUT INDICATION");
					2'b01:if(rxn0[0][5:0]!=txn1[0][5:0])
									`uvm_fatal("UART0_SCOREBOARD","MISMATCH IN RECEIVED DATA,TIMEOUT INDICATION")
								else
									$display("UART0:MATCH IN RECEIVED DATA, TIMEOUT INDICATION");
					2'b10:if(rxn0[0][6:0]!=txn1[0][6:0])
									`uvm_fatal("UART0_SCOREBOARD","MISMATCH IN RECEIVED DATA,TIMEOUT INDICATION")
								else
									$display("UART0:MATCH IN RECEIVED DATA, TIMEOUT INDICATION");
					2'b11:if(rxn0[0][7:0]!=txn1[0][7:0])
									`uvm_fatal("UART0_SCOREBOARD","MISMATCH IN RECEIVED DATA,TIMEOUT INDICATION")
								else
									$display("UART0:MATCH IN RECEIVED DATA, TIMEOUT INDICATION");
				endcase
				`uvm_info("UART0_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart0_mon_data.sprint()),UVM_LOW) 
				`uvm_info("UART1_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart1_mon_data.sprint()),UVM_LOW) 
			end
		else if(uart0_mon_data.iir=='hC2)
			begin
				$display("UART0:THR EMPTY INTERRUPT,TRANSMITTING NEXT DATA");
				//$stop;
			end
		else if(uart0_mon_data.iir=='hC6 && uart0_mon_data.ctrl_reg==5)
			begin
				case(uart0_mon_data.lsr[4:1])
					4'b0001: `uvm_error("UART0_SCOREBOARD","ERROR IN RECEIVED DATA:OVERRUN ERROR")
					4'b0010: `uvm_error("UART0_SCOREBOARD","ERROR IN RECEIVED DATA:PARITY ERROR")
					4'b0100: `uvm_error("UART0_SCOREBOARD","ERROR IN RECEIVED DATA:FRAMING ERROR")
					4'b0110: `uvm_error("UART0_SCOREBOARD","ERROR IN RECEIVED DATA:PARITY AND FRAMING ERROR")
					4'b1000: `uvm_error("UART0_SCOREBOARD","ERROR IN RECEIVED DATA:BREAK INTERRUPT")
					default: begin 
											$display("uart0 lsr",uart0_mon_data.lsr);
										  `uvm_info("UART0_SCOREBOARD","ERROR IN RECEIVED DATA:DEFAULT",UVM_LOW)
									  end
				endcase
				`uvm_info("UART0_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart0_mon_data.sprint()),UVM_LOW) 
				`uvm_info("UART1_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart1_mon_data.sprint()),UVM_LOW) 
			end
	endtask

task uart_scoreboard::compare_uart1_txn_rxn();
		if(uart1_mon_data.iir=='hC4)
			begin
				case(uart1_mon_data.fcr[7:6])
					2'b00:if(rxn1.size()==1)
							begin
								case(uart1_mon_data.lcr_reg[1:0])
									2'b00:compare1_5bits();									
									2'b01:compare1_6bits();
									2'b10:compare1_7bits();
									2'b11:compare1_8bits();
								endcase
							end
				2'b01:if(rxn1.size()==4)
							begin
									case(uart1_mon_data.lcr_reg[1:0])
									2'b00:compare1_5bits();
									2'b01:compare1_6bits();
									2'b10:compare1_7bits();
									2'b11:compare1_8bits();
								endcase
							end
				2'b10:if(rxn1.size()==8)
							begin
									case(uart1_mon_data.lcr_reg[1:0])
									2'b00:compare1_5bits();
									2'b01:compare1_6bits();
									2'b10:compare1_7bits();
									2'b11:compare1_8bits();
								endcase
							end
				2'b11:if(rxn1.size()==14)
							begin
									case(uart1_mon_data.lcr_reg[1:0])
									2'b00:compare1_5bits();
									2'b01:compare1_6bits();
									2'b10:compare1_7bits();
									2'b11:compare1_8bits();
								endcase
							end
						default:	$display("In uart1 compare task default case");
				endcase
				`uvm_info("UART1_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart1_mon_data.sprint()),UVM_LOW) 										
				`uvm_info("UART0_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart0_mon_data.sprint()),UVM_LOW) 										
			end
		else if(uart1_mon_data.iir=='hCC)
			begin
				case(uart1_mon_data.lcr_reg[1:0])
					2'b00:if(rxn1[0][4:0]!=txn0[0][4:0])
									`uvm_fatal("UART1_SCOREBOARD","MISMATCH IN RECEIVED DATA,TIMEOUT INDICATION")
								else
									$display("UART1:MATCH IN RECEIVED DATA, TIMEOUT INDICATION");
					2'b01:if(rxn1[0][5:0]!=txn0[0][5:0])
									`uvm_fatal("UART1_SCOREBOARD","MISMATCH IN RECEIVED DATA,TIMEOUT INDICATION")
								else
									$display("UART0:MATCH IN RECEIVED DATA, TIMEOUT INDICATION");
					2'b10:if(rxn1[0][6:0]!=txn0[0][6:0])
									`uvm_fatal("UART1_SCOREBOARD","MISMATCH IN RECEIVED DATA,TIMEOUT INDICATION")
								else
									$display("UART0:MATCH IN RECEIVED DATA, TIMEOUT INDICATION");
					2'b11:if(rxn1[0][7:0]!=txn0[0][7:0])
									`uvm_fatal("UART1_SCOREBOARD","MISMATCH IN RECEIVED DATA,TIMEOUT INDICATION")
								else
									$display("UART0:MATCH IN RECEIVED DATA, TIMEOUT INDICATION");
				endcase
				`uvm_info("UART0_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart0_mon_data.sprint()),UVM_LOW) 
				`uvm_info("UART1_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart1_mon_data.sprint()),UVM_LOW) 
			end
		else if(uart1_mon_data.iir=='hC2)
			begin
				$display("UART1:THR EMPTY INTERRUPT,TRANSMITTING NEXT DATA");
				//$stop;
			end
		else if(uart1_mon_data.iir=='hC6 && uart1_mon_data.ctrl_reg==5)
			begin
				case(uart1_mon_data.lsr[4:1])
					4'b0001: `uvm_error("UART1_SCOREBOARD","ERROR IN RECEIVED DATA:OVERRUN ERROR")
					4'b0010: `uvm_error("UART1_SCOREBOARD","ERROR IN RECEIVED DATA:PARITY ERROR")
					4'b0100: `uvm_error("UART1_SCOREBOARD","ERROR IN RECEIVED DATA:FRAMING ERROR")
					4'b0110: `uvm_error("UART1_SCOREBOARD","ERROR IN RECEIVED DATA:PARITY AND FRAMING ERROR")
					4'b1000: `uvm_error("UART1_SCOREBOARD","ERROR IN RECEIVED DATA:BREAK INTERRUPT")
					default: begin 
										 $display("uart1 lsr",uart1_mon_data.lsr);
										 `uvm_info("UART1_SCOREBOARD","ERROR IN RECEIVED DATA:DEFAULT",UVM_LOW)
									 end
				endcase
				`uvm_info("UART0_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart0_mon_data.sprint()),UVM_LOW) 
				`uvm_info("UART1_SCOREBOARD",$sformatf("========Printing from scoreboard compare task========== \n %s",uart1_mon_data.sprint()),UVM_LOW) 
			end
	endtask

/*
	$display("UART0_SCOREBOARD ========================Printing from scoreboard====================== ");
								$display("txn0:",txn0);
		$display("UART0_SCOREBOARD ========================Printing from scoreboard====================== ");
				$display("rxn0:",rxn0);

			$display("UART1_SCOREBOARD ========================Printing from scoreboard====================== ");
								$display("txn1:",txn1);

	$display("UART1_SCOREBOARD ========================Printing from scoreboard====================== ");
						$display("rxn1:",rxn1);

			$display("In uart0 compare task %d",uart0_mon_data.fcr[7:6]);

			begin
												$display("UART0:MISMATCH IN RECEIVED DATA, TRIGGER LEVEL 1 byte");
												$display("txn1:",txn1);
												$display("rxn0:",rxn0);
											end

	//`uvm_info("UART0_SCOREBOARD",$sformatf("========================Printing from scoreboard====================== \n %s",uart0_mon_data.sprint()),UVM_HIGH)
	//`uvm_info("UART1_SCOREBOARD",$sformatf("========================Printing from scoreboard====================== \n %s",uart1_mon_data.sprint()),UVM_LOW) 

*/

	/*	if(uart0_mon_data.we && uart0_mon_data.ctrl_reg==3 && ~uart0_mon_data.lcr_reg[7])
			begin
			case(uart0_mon_data.lcr_reg[1:0])
			2'b00:no_of_bits1=5;
			2'b01:no_of_bits1=6;
			2'b10:no_of_bits1=7;
			2'b11:no_of_bits1=8;
			endcase
			display("=================uart1 no_of_bits %d",no_of_bits1);
			end
		else*/ 
