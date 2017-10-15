class uart_test_base_sequence extends uvm_sequence #(uart_transaction);
	
	`uvm_object_utils(uart_test_base_sequence)
		
	//uart_transaction rsp;

	extern function new(string name = "uart_test_base_sequence");
	extern task uart_set_baud(int dl_value);
	extern task uart_set_lcr(int lcr_value);
	extern task uart_set_ier(int ier_value);
	extern task uart_set_fcr(int fcr_value);
	extern task uart_transmit_data(int i);
	extern task uart_read_iir();
	extern task uart_receive_data(uart_transaction rsp,int i);

endclass:uart_test_base_sequence

function uart_test_base_sequence::new(string name = "uart_test_base_sequence");
	super.new(name);
endfunction
	
	task uart_test_base_sequence::uart_set_baud(int dl_value);
		req=uart_transaction::type_id::create("req");
			//LCR configure
				start_item(req);
				$display("UART1:Writing to the Line control register");
				assert(req.randomize() with {ctrl_reg==3;txn_reg==8'b10000000;wb_we_i==1;});
				finish_item(req);

			  //DL configure
				start_item(req);
				$display("UART1:Writing to the Divisor Latch register");
				assert(req.randomize() with {ctrl_reg==0;txn_reg==dl_value;wb_we_i==1;});
				finish_item(req);
	endtask;

	task uart_test_base_sequence::uart_set_lcr(int lcr_value);
		req=uart_transaction::type_id::create("req");
			//LCR configure
			start_item(req);
			$display("UART0:Writing to the Line control register");
			assert(req.randomize() with {ctrl_reg==3;txn_reg==lcr_value;wb_we_i==1;});
			finish_item(req);
	endtask
	
	task uart_test_base_sequence::uart_set_ier(int ier_value);
		//IER configure
		start_item(req);
		$display("UART0:Writing to the Interrupt Enable register");
		assert(req.randomize() with {ctrl_reg==1;txn_reg==ier_value;wb_we_i==1;});
		finish_item(req);
	endtask
	
	task uart_test_base_sequence::uart_set_fcr(int fcr_value);
		//FCR configure
		start_item(req);
		$display("UART0:Writing to the FIFO control register");
		assert(req.randomize() with {ctrl_reg==2;txn_reg==fcr_value;wb_we_i==1;});
		finish_item(req);
	endtask

	task uart_test_base_sequence::uart_transmit_data(int i);
	//THR configure
				//for(int i=0;i<{$random%6};i++)
				repeat(i)	
					begin
						start_item(req);
						$display("UART0:Writing to the Transmitting holding register");
						assert(req.randomize() with {ctrl_reg==0;wb_we_i==1;});
						finish_item(req);
     			end
	endtask
	
	task uart_test_base_sequence::uart_read_iir();
		//IIR 
				start_item(req);
				assert(req.randomize() with {ctrl_reg==2;wb_we_i==0;});
				finish_item(req);
	endtask


	task uart_test_base_sequence::uart_receive_data(uart_transaction rsp,int i);
		req=uart_transaction::type_id::create("req");

				if(rsp.rxn_reg==8'b11000110)
					begin
						//LSR
						start_item(req);
						$display("UART0:Reading the line status register");
						assert(req.randomize() with {ctrl_reg==5;wb_we_i==0;});
						finish_item(req);
					end
				else if(rsp.rxn_reg==8'b11000100)
					begin
						//Receiver buffer
						repeat(i)
						begin
						start_item(req);
						$display("UART0:Reading from receiver buffer");
						assert(req.randomize() with {ctrl_reg==0;wb_we_i==0;});
						finish_item(req);
						end
					end
				else if(rsp.rxn_reg==8'b11001100)
					begin
						//Receiver buffer
						start_item(req);
						$display("UART0:Timeout indication:read from receiver buffer");
						assert(req.randomize() with {ctrl_reg==0;wb_we_i==0;});
						finish_item(req);
					end
				else if(rsp.rxn_reg==8'b11000010)
					begin
						//THR
						start_item(req);
						$display("UART0:THR is empty");
						assert(req.randomize() with {ctrl_reg==0;wb_we_i==1;});
						finish_item(req);
					end
       
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class uart0_baud_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart0_baud_sequence)

	function new(string name = "uart0_baud_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
			  uart_set_baud(5);
			 	uart_set_lcr(8'b00001011);
			end
	endtask
	
endclass

class uart1_baud_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart1_baud_sequence)

	function new(string name = "uart1_baud_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
			  uart_set_baud(10);
				uart_set_lcr(8'b00001011);
			end
	endtask
	
endclass

//////////////////////////////////////////////////////////////////     HALF DUPLEX (8bit) (8 bytes trigger level)   //////////////////////////////////////////////////////////////////////

class uart0_halfduplex_p2s_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart0_halfduplex_p2s_sequence)

	function new(string name = "uart0_halfduplex_p2s_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
		rsp=uart_transaction::type_id::create("rsp");
			begin
			  uart_set_baud(5);
				uart_set_lcr(8'b00001011);
				uart_set_ier(8'b00000111);
				uart_set_fcr(8'b10000110);
				uart_transmit_data(8);
			end
	endtask
	
endclass

class uart1_halfduplex_s2p_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart1_halfduplex_s2p_sequence)

	function new(string name = "uart1_halfduplex_s2p_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
			  uart_set_baud(10);
				uart_set_lcr(8'b00001011);
				uart_set_ier(8'b00000101);
				uart_set_fcr(8'b10000110);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,8);
			end
	endtask
	
endclass

//////////////////////////////////////////////////////////////////     HALF DUPLEX (5bit) (4 bytes trigger level)   //////////////////////////////////////////////////////////////////////

class uart0_halfduplex_p2s_5bit_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart0_halfduplex_p2s_5bit_sequence)

	function new(string name = "uart0_halfduplex_p2s_5bit_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
		rsp=uart_transaction::type_id::create("rsp");
			begin
			  uart_set_baud(5);
				uart_set_lcr(8'b00001000);
				uart_set_ier(8'b00000111);
				uart_set_fcr(8'b01000110);
				uart_transmit_data(4);
			end
	endtask
	
endclass

class uart1_halfduplex_s2p_5bit_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart1_halfduplex_s2p_5bit_sequence)

	function new(string name = "uart1_halfduplex_s2p_5bit_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
			  uart_set_baud(10);
			  uart_set_lcr(8'b00001000);
				uart_set_ier(8'b00000101);
				uart_set_fcr(8'b01000110);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

/////////////////////////////////////////////////////////////     FULL DUPLEX (8bit) (14bytes trigger level)   //////////////////////////////////////////////////////////////////////////////////

class uart0_fullduplex_p2s_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart0_fullduplex_p2s_sequence)

	function new(string name = "uart0_fullduplex_p2s_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
		rsp=uart_transaction::type_id::create("rsp");
			begin
				uart_set_baud(5);
				uart_set_lcr(8'b00001011);
				uart_set_ier(8'b00000101);
				uart_set_fcr(8'b11000110);
				uart_transmit_data(14);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,14);
		end
	endtask
	
endclass

class uart1_fullduplex_s2p_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart1_fullduplex_s2p_sequence)

	function new(string name = "uart1_fullduplex_s2p_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
				uart_set_baud(10);
			 	uart_set_lcr(8'b00001011);
 				uart_set_ier(8'b00000101);
				uart_set_fcr(8'b11000110);
				uart_transmit_data(14);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,14);
			end
	endtask
	
endclass

/////////////////////////////////////////////////////////////     FULL DUPLEX (PARITY ERROR) (1 byte triggerlevel)   ////////////////////////////////////////////////////////////////////

class uart0_fullduplex_parityerror_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart0_fullduplex_parityerror_sequence)

	function new(string name = "uart0_fullduplex_parityerror_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
		rsp=uart_transaction::type_id::create("rsp");
			begin
			  uart_set_baud(5);
				uart_set_lcr(8'b00001011);
				uart_set_ier(8'b00000101);
				uart_set_fcr(8'b00000110);
				uart_transmit_data(1);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,1);
			end
	endtask
	
endclass

class uart1_fullduplex_parityerror_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart1_fullduplex_parityerror_sequence)

	function new(string name = "uart1_fullduplex_parityerror_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
			  uart_set_baud(10);
				uart_set_lcr(8'b00011011);
			  uart_set_ier(8'b00000101);
				uart_set_fcr(8'b00000110);
				uart_transmit_data(1);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,1);
				end
	endtask
	
	
endclass

/////////////////////////////////////////////////////////////     FULL DUPLEX (FRAMING ERROR)    ///////////////////////////////////////////////////////////////////

class uart0_fullduplex_framingerror_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart0_fullduplex_framingerror_sequence)

	function new(string name = "uart0_fullduplex_framingerror_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
		rsp=uart_transaction::type_id::create("rsp");
			begin
			  uart_set_baud(5);
				uart_set_lcr(8'b00001011);
			  uart_set_ier(8'b00000101);
				uart_set_fcr(8'b01000110);
				uart_transmit_data(4);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

class uart1_fullduplex_framingerror_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart1_fullduplex_framingerror_sequence)

	function new(string name = "uart1_fullduplex_framingerror_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
			 	uart_set_baud(10);
				uart_set_lcr(8'b00001010);
			  uart_set_ier(8'b00000101);
				uart_set_fcr(8'b01000110);
				uart_transmit_data(4);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

/////////////////////////////////////////////////////////////     FULL DUPLEX (BREAK INTERRUPT)    ///////////////////////////////////////////////////////////////////

class uart0_fullduplex_breakinterrupt_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart0_fullduplex_breakinterrupt_sequence)

	function new(string name = "uart0_fullduplex_breakinterrupt_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
		rsp=uart_transaction::type_id::create("rsp");
			begin
			  uart_set_baud(5);
				uart_set_lcr(8'b00001011);
			  uart_set_ier(8'b00000101);
				uart_set_fcr(8'b01000110);
				uart_transmit_data(4);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

class uart1_fullduplex_breakinterrupt_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart1_fullduplex_breakinterrupt_sequence)

	function new(string name = "uart1_fullduplex_breakinterrupt_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
				uart_set_baud(10);
				uart_set_lcr(8'b01001011);
			  uart_set_ier(8'b00000101);  
				uart_set_fcr(8'b01000110);
				uart_transmit_data(4);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

/////////////////////////////////////////////////////////////     FULL DUPLEX (OVERRUN ERROR) (7bit)   //////////////////////////////////////////////////////////////////////////////////

class uart0_fullduplex_overrun_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart0_fullduplex_overrun_sequence)

	function new(string name = "uart0_fullduplex_overrun_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
		rsp=uart_transaction::type_id::create("rsp");
			begin
			  uart_set_baud(5);
				uart_set_lcr(8'b00001010);
				uart_set_ier(8'b00000100);
				uart_set_fcr(8'b01000110);
				uart_transmit_data(17);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

class uart1_fullduplex_overrun_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart1_fullduplex_overrun_sequence)

	function new(string name = "uart1_fullduplex_overrun_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
			 	uart_set_baud(10);
				uart_set_lcr(8'b00001010);
				uart_set_ier(8'b00000100);
				uart_set_fcr(8'b01000110);
				uart_transmit_data(17);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

/////////////////////////////////////////////////////////////     FULL DUPLEX (TIMEOUT) (6bit)   ////////////////////////////////////////////////////////////////////////

class uart0_fullduplex_timeout_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart0_fullduplex_timeout_sequence)

	function new(string name = "uart0_fullduplex_timeout_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
		rsp=uart_transaction::type_id::create("rsp");
			begin
			  uart_set_baud(5);
				uart_set_lcr(8'b00001001);
			  uart_set_ier(8'b00000101);
				uart_set_fcr(8'b01000110);
				uart_transmit_data(3);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

class uart1_fullduplex_timeout_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart1_fullduplex_timeout_sequence)

	function new(string name = "uart1_fullduplex_timeout_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
			  uart_set_baud(10);
				uart_set_lcr(8'b00001001);
				uart_set_ier(8'b00000101);
				uart_set_fcr(8'b01000110);
				uart_transmit_data(1);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

/////////////////////////////////////////////////////////////     FULL DUPLEX (THR EMPTY INTERRUPT)    ///////////////////////////////////////////////////////////////////

class uart0_fullduplex_thrempty_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart0_fullduplex_thrempty_sequence)

	function new(string name = "uart0_fullduplex_thrempty_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
		rsp=uart_transaction::type_id::create("rsp");
			begin
			  uart_set_baud(5);
				uart_set_lcr(8'b00001011);
				uart_set_ier(8'b00000111);
				uart_set_fcr(8'b01000110);
				uart_transmit_data(4);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

class uart1_fullduplex_thrempty_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart1_fullduplex_thrempty_sequence)

	function new(string name = "uart1_fullduplex_thrempty_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin
			  uart_set_baud(10);
				uart_set_lcr(8'b00001011);
				uart_set_ier(8'b00000111);
				uart_set_fcr(8'b01000110);
				uart_transmit_data(4);
				uart_read_iir();
				get_response(rsp);
				uart_receive_data(rsp,4);
			end
	endtask
	
endclass

//////////////////////////////////////////////////////////////////////reset//////////////////////////////////////////////////////////////////////////////////////////

class uart_reset_sequence extends uart_test_base_sequence;
	
	`uvm_object_utils(uart_reset_sequence)

	function new(string name = "uart_reset_sequence");
		super.new(name);
	endfunction

	task body();
		req=uart_transaction::type_id::create("req");
			begin

			  //IER
				start_item(req);
				assert(req.randomize() with {ctrl_reg==1;wb_we_i==0;});
				//`uvm_info("UART_SEQUENCE",$sformatf("RANDOMIZED DATA \n %s", req.sprint()),UVM_LOW) 
				finish_item(req);
				
				//IIR
				start_item(req);
				assert(req.randomize() with {ctrl_reg==2;wb_we_i==0;});
				//`uvm_info("UART_SEQUENCE",$sformatf("RANDOMIZED DATA \n %s", req.sprint()),UVM_LOW) 
				finish_item(req);

				//LCR
				start_item(req);
				assert(req.randomize() with {ctrl_reg==3;wb_we_i==0;});
				//`uvm_info("UART_SEQUENCE",$sformatf("RANDOMIZED DATA \n %s", req.sprint()),UVM_LOW) 
				finish_item(req);
				
				//LSR
				start_item(req);
				assert(req.randomize() with {ctrl_reg==5;wb_we_i==0;});
				//`uvm_info("UART_SEQUENCE",$sformatf("RANDOMIZED DATA \n %s", req.sprint()),UVM_LOW) 
				finish_item(req);

			end
	endtask
	
endclass

//`uvm_info("UART0_SEQUENCE",$sformatf("GET RESPONSE RSP: \n %s", rsp.sprint()),UVM_LOW) 
//`uvm_info("UART1_SEQUENCE",$sformatf("GET RESPONSE RSP: \n %s", rsp.sprint()),UVM_LOW)
