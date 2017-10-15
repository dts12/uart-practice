class uart_env_cfg extends uvm_object;

	`uvm_object_utils(uart_env_cfg)

	int no_of_dut=1;
	int no_of_agent_top=1;
	int no_of_agent=1;

	bit has_virtual_sequencer=1;
	bit has_scoreboard=1;
	bit has_coverage=1;

	bit full_duplex=1;


	uart_agent_cfg agent_cfg[];

	function new(string name="uart_env_cfg");
		super.new(name);
	endfunction

endclass
