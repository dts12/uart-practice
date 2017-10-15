class uart_transaction extends uvm_sequence_item;
	`uvm_object_utils(uart_transaction)
	
	//parameter 							 uart_data_width = `UART_DATA_WIDTH;
	//parameter 							 uart_addr_width = `UART_ADDR_WIDTH;
	parameter 							 uart_data_width = 8;
	parameter 							 uart_addr_width = 3;
	rand bit wb_we_i;
	rand logic [uart_addr_width-1:0]ctrl_reg;      //Address
	rand logic [uart_data_width-1:0]txn_reg;
	logic [uart_data_width-1:0]rxn_reg;
//	logic [uart_data_width-1:0]ctrl_reg_temp;
	
	logic we;
	logic [7:0]ier;  
	logic [7:0]iir;  
	logic [7:0]fcr;
	logic [7:0]lcr_reg;
	logic [7:0]dlr;
	logic [7:0]lsr;
	logic [7:0]thr;
	logic [7:0]rb;
	logic [uart_data_width-1:0]txn_reg_2sb[$];
	logic [uart_data_width-1:0]rxn_reg_2sb[$];
	logic [3:0]no_of_bits;

	function new(string name="uart_transaction");
		super.new(name);
	endfunction

	extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	extern function void do_print(uvm_printer printer);
	/*
	function void postrandomize();
		ctrl_reg_temp=ctrl_reg;
	endfunction
	*/
endclass

function bit uart_transaction::do_compare (uvm_object rhs,uvm_comparer comparer);

 // handle for overriding the variable
    uart_transaction rhs_;

    if(!$cast(rhs_,rhs)) begin
    `uvm_fatal("do_compare","cast of the rhs object failed")
    return 0;
    end
    return super.do_compare(rhs,comparer) &&
		rxn_reg==rhs_.rxn_reg;

 endfunction:do_compare 

function void uart_transaction::do_print (uvm_printer printer);
    super.do_print(printer);
    printer.print_field( "crtl_reg", 		ctrl_reg, 	    uart_data_width,		 UVM_BIN		);
    printer.print_field( "we", 		we, 	    1,		 UVM_BIN		);

		printer.print_field( "lcr_reg", 		lcr_reg, 	    uart_data_width,		 UVM_BIN		);
		printer.print_field( "dlr", 		dlr, 	    uart_data_width,		 UVM_BIN		);	
		printer.print_field( "ier", 		ier, 	    uart_data_width,		 UVM_BIN		);
		printer.print_field( "fcr", 		fcr, 	    uart_data_width,		 UVM_BIN		);
		
		foreach(txn_reg_2sb[i])
		printer.print_field( $sformatf("txn_reg_2sb[%0d]",i), 		txn_reg_2sb[i], 	    uart_data_width,		 UVM_BIN		);

		printer.print_field( "iir", 		iir, 	    uart_data_width,		 UVM_BIN		);
		printer.print_field( "lsr", 		lsr, 	    uart_data_width,		 UVM_BIN		);
		
		foreach(rxn_reg_2sb[i])
		printer.print_field( $sformatf("rxn_reg_2sb[%0d]",i), 		rxn_reg_2sb[i], 	    uart_data_width,		 UVM_BIN		);

    printer.print_field( "txn_reg", 		txn_reg, 	    uart_data_width,		 UVM_DEC		);
    printer.print_field( "rxn_reg", 		rxn_reg, 	    uart_data_width,		 UVM_DEC		);
		printer.print_field( "txn_reg", 		txn_reg, 	    uart_data_width,		 UVM_HEX		);
    printer.print_field( "rxn_reg", 		rxn_reg, 	    uart_data_width,		 UVM_HEX		);
   
   
  endfunction:do_print

