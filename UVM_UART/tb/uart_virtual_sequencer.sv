class uart_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

	`uvm_component_utils(uart_virtual_sequencer)

	uart_env_cfg env_cfg;

	uart_sequencer seqr[];
	
	function new(string name="uart_virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		
		if(!uvm_config_db #(uart_env_cfg)::get(this,"","uart_env_cfg",env_cfg))
			`uvm_fatal("VIRTUAL_SEQUENCER:ENV CONFIG","FAILED TO GET ENC_CFG")
		
		seqr=new[env_cfg.no_of_agent];

		super.build_phase(phase);
	
	endfunction

endclass
