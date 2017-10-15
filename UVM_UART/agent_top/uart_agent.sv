class uart_agent extends uvm_agent;
	
	`uvm_component_utils(uart_agent)

	uart_agent_cfg agent_cfg;
	
	uart_driver drv;
	uart_sequencer seqr;
	uart_monitor mon;
	
	function new(string name="uart_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
			
		if(!uvm_config_db #(uart_agent_cfg)::get(this,"","uart_agent_cfg",agent_cfg))
			`uvm_fatal("AGENT:ENV CONFIG","FAILED TO GET ENC_CFG")

		super.build_phase(phase);

		mon=uart_monitor::type_id::create("mon",this);

		if(agent_cfg.is_active ==UVM_ACTIVE)
			begin
				drv=uart_driver::type_id::create("drv",this);
				seqr=uart_sequencer::type_id::create("seqr",this);
			end

	endfunction

	function void connect_phase(uvm_phase phase);
		if(agent_cfg.is_active==UVM_ACTIVE)
		begin
				drv.seq_item_port.connect(seqr.seq_item_export);	
		end

	endfunction

endclass

