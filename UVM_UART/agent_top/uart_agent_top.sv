class uart_agent_top extends uart_env;
	
	`uvm_component_utils(uart_agent_top)

	uart_env_cfg env_cfg;

	uart_agent agent[];
	
	function new(string name="uart_agent_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		
		if(!uvm_config_db #(uart_env_cfg)::get(this,"","uart_env_cfg",env_cfg))
			`uvm_fatal("AGENT_TOP:ENV CONFIG","FAILED TO GET ENC_CFG")
		agent=new[env_cfg.no_of_agent];
		
		super.build_phase(phase);
		
		foreach(agent[i])
				agent[i]=uart_agent::type_id::create($sformatf("agent[%0d]",i),this);

	endfunction

endclass
