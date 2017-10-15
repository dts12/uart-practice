class uart_agent_cfg extends uvm_object;

	`uvm_object_utils(uart_agent_cfg)

	virtual uart_interface vif;

	uvm_active_passive_enum is_active=UVM_ACTIVE;

	function new(string name="uart_agent_cfg");
		super.new(name);
	endfunction

endclass
