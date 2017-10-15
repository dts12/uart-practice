
class uart_sequencer extends uvm_sequencer #(uart_transaction);

	`uvm_component_utils(uart_sequencer)
	
	function new(string name="uart_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

endclass
