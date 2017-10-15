class uart_base_test extends uvm_test;

	`uvm_component_utils(uart_base_test)

	uart_env_cfg env_cfg;
	uart_agent_cfg agent_cfg[];

	int no_of_dut=2;
	int no_of_agent_top=1;
	int no_of_agent=2;

	bit has_virtual_sequencer=1;
	bit has_scoreboard=1;
	bit has_coverage=1;

	uart_tb env;

	function new(string name="uart_base_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		
		env_cfg=uart_env_cfg::type_id::create("env_cfg");
		env_cfg.agent_cfg=new[no_of_agent];
		agent_cfg=new[no_of_agent];
		
		foreach(agent_cfg[i])
				begin
					agent_cfg[i]=uart_agent_cfg::type_id::create($sformatf("agent_cfg[%0d]",i));
					if(!uvm_config_db #(virtual uart_interface)::get(this,"",$sformatf("vif%0d",i),agent_cfg[i].vif))
						`uvm_fatal("TEST:VIF CONFIG","FAILED TO GET VIF TO AGENT_CFG")
					agent_cfg[i].is_active=UVM_ACTIVE;
					env_cfg.agent_cfg[i]=agent_cfg[i];
				end

		env_cfg.no_of_dut=no_of_dut;
		env_cfg.no_of_agent=no_of_agent;
		env_cfg.has_virtual_sequencer=has_virtual_sequencer;
		env_cfg.has_scoreboard=has_scoreboard;
		env_cfg.has_coverage=has_coverage;

		uvm_config_db #(uart_env_cfg)::set(this,"*","uart_env_cfg",env_cfg);

		super.build_phase(phase);
		env=uart_tb::type_id::create("env",this);
	
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
endclass

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class uart_first_test extends uart_base_test;
	
	`uvm_component_utils(uart_first_test)
	
	uart_virtual_reset_seqs vseqs;

	function new(string name = "uart_first_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_reset_seqs::type_id::create("vseqs");
		vseqs.start(env.vseqr);
		//#1000;
		phase.drop_objection(this);
	endtask

endclass

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class uart_baud_test extends uart_base_test;
	
	`uvm_component_utils(uart_baud_test)
	
	uart_virtual_baud_seqs vseqs;

	function new(string name = "uart_baud_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_baud_seqs::type_id::create("vseqs");
		vseqs.start(env.vseqr);
		#5000;
		phase.drop_objection(this);
	endtask

endclass

////////////////////////////////////////////////////////////////   HALF DUPLEX (8 bit)   ////////////////////////////////////////////////////////////////

class uart_halfduplex_test extends uart_base_test;
	
	`uvm_component_utils(uart_halfduplex_test)
	
	uart_virtual_halfduplex_seqs vseqs;

	function new(string name = "uart_halfduplex_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_halfduplex_seqs::type_id::create("vseqs");
		vseqs.start(env.vseqr);
		#500000;
		phase.drop_objection(this);
	endtask

endclass

////////////////////////////////////////////////////////////////   HALF DUPLEX (5 bit)   ////////////////////////////////////////////////////////////////

class uart_halfduplex_5bit_test extends uart_base_test;
	
	`uvm_component_utils(uart_halfduplex_5bit_test)
	
	uart_virtual_halfduplex_5bit_seqs vseqs;

	function new(string name = "uart_halfduplex_5bit_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_halfduplex_5bit_seqs::type_id::create("vseqs");
		vseqs.start(env.vseqr);
		#500000;
		phase.drop_objection(this);
	endtask

endclass

//////////////////////////////////////////////////////////////   FULL DUPLEX     //////////////////////////////////////////////////////////////////

class uart_fullduplex_test extends uart_base_test;
	
	`uvm_component_utils(uart_fullduplex_test)
	
	uart_virtual_fullduplex_seqs vseqs;

	function new(string name = "uart_fullduplex_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_fullduplex_seqs::type_id::create("vseqs");
	//	repeat(2)
		vseqs.start(env.vseqr);
		#4000000;
		phase.drop_objection(this);
	endtask

endclass

/////////////////////////////////////////////////////////////    FULL DUPLEX (PARITY ERROR)    ///////////////////////////////////////////////////////////////////

class uart_fullduplex_parityerror_test extends uart_base_test;
	
	`uvm_component_utils(uart_fullduplex_parityerror_test)
	
	uart_virtual_fullduplex_parityerror_seqs vseqs;

	function new(string name = "uart_fullduplex_parityerror_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_fullduplex_parityerror_seqs::type_id::create("vseqs");
	//	repeat(2)
		vseqs.start(env.vseqr);
		#4000000;
		phase.drop_objection(this);
	endtask

endclass

/////////////////////////////////////////////////////////////    FULL DUPLEX (FRAMING ERROR)    ///////////////////////////////////////////////////////////////////

class uart_fullduplex_framingerror_test extends uart_base_test;
	
	`uvm_component_utils(uart_fullduplex_framingerror_test)
	
	uart_virtual_fullduplex_framingerror_seqs vseqs;

	function new(string name = "uart_fullduplex_framingerror_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_fullduplex_framingerror_seqs::type_id::create("vseqs");
	//	repeat(2)
		vseqs.start(env.vseqr);
		#4000000;
		phase.drop_objection(this);
	endtask

endclass

/////////////////////////////////////////////////////////////    FULL DUPLEX (BREAK INTERRUPT)    //////////////////////////////////////////////////////////////////

class uart_fullduplex_breakinterrupt_test extends uart_base_test;
	
	`uvm_component_utils(uart_fullduplex_breakinterrupt_test)
	
	uart_virtual_fullduplex_breakinterrupt_seqs vseqs;

	function new(string name = "uart_fullduplex_breakinterrupt_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_fullduplex_breakinterrupt_seqs::type_id::create("vseqs");
	//	repeat(2)
		vseqs.start(env.vseqr);
		#4000000;
		phase.drop_objection(this);
	endtask

endclass

/////////////////////////////////////////////////////////////    FULL DUPLEX (OVERRUN ERROR)    //////////////////////////////////////////////////////////////////

class uart_fullduplex_overrun_test extends uart_base_test;
	
	`uvm_component_utils(uart_fullduplex_overrun_test)
	
	uart_virtual_fullduplex_overrun_seqs vseqs;

	function new(string name = "uart_fullduplex_overrun_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_fullduplex_overrun_seqs::type_id::create("vseqs");
	//	repeat(2)
		vseqs.start(env.vseqr);
		#4000000;
		phase.drop_objection(this);
	endtask

endclass

/////////////////////////////////////////////////////////////    FULL DUPLEX (TIMEOUT)    //////////////////////////////////////////////////////////////////

class uart_fullduplex_timeout_test extends uart_base_test;
	
	`uvm_component_utils(uart_fullduplex_timeout_test)
	
	uart_virtual_fullduplex_timeout_seqs vseqs;

	function new(string name = "uart_fullduplex_timeout_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_fullduplex_timeout_seqs::type_id::create("vseqs");
	//	repeat(2)
		vseqs.start(env.vseqr);
		#4000000;
		phase.drop_objection(this);
	endtask

endclass

/////////////////////////////////////////////////////////////    FULL DUPLEX (THR EMPTY INTERRUPT)    //////////////////////////////////////////////////////////////////

class uart_fullduplex_thrempty_test extends uart_base_test;
	
	`uvm_component_utils(uart_fullduplex_thrempty_test)
	
	uart_virtual_fullduplex_thrempty_seqs vseqs;

	function new(string name = "uart_fullduplex_thrempty_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqs=uart_virtual_fullduplex_thrempty_seqs::type_id::create("vseqs");
	//	repeat(2)
		vseqs.start(env.vseqr);
		#4000000;
		phase.drop_objection(this);
	endtask

endclass

