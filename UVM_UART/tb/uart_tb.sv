class uart_tb extends uvm_env;

	`uvm_component_utils(uart_tb)
	
	uart_env_cfg env_cfg;

	uart_virtual_sequencer vseqr;
	uart_agent_top agent_top;
	uart_scoreboard sb;
	//uart_coverage uart_cvrg;
	uart_coverage_subscriber uart_cvrg[];

	extern function new(string name="uart_tb",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

	function uart_tb::new(string name="uart_tb",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void uart_tb::build_phase(uvm_phase phase);
	
		if(!uvm_config_db #(uart_env_cfg)::get(this,"","uart_env_cfg",env_cfg))
			`uvm_fatal("TB:ENV CONFIG","FAILED TO GET ENC_CFG")

		uart_cvrg=new[env_cfg.no_of_agent];

		foreach(env_cfg.agent_cfg[i])
			uvm_config_db #(uart_agent_cfg) ::set(this,$sformatf("agent_top.agent[%0d]*",i),"uart_agent_cfg",env_cfg.agent_cfg[i]); 	

		super.build_phase(phase);

		agent_top=uart_agent_top::type_id::create("agent_top",this);
		
		if(env_cfg.has_virtual_sequencer)
			begin
				vseqr=uart_virtual_sequencer::type_id::create("vseqr",this);
			end
	
		if(env_cfg.has_scoreboard)
			sb=uart_scoreboard::type_id::create("sb",this);
/*
		if(env_cfg.has_coverage)
			uart_cvrg=uart_coverage::type_id::create("uart_cvrg",this);
*/
		if(env_cfg.has_coverage)
			foreach(uart_cvrg[i])
				uart_cvrg[i]=uart_coverage_subscriber::type_id::create($sformatf("uart_cvrg[%0d]",i),this);

	endfunction

	function void uart_tb::connect_phase(uvm_phase phase);
	
	if(env_cfg.has_virtual_sequencer)
		begin
		
			if(env_cfg.no_of_agent)
				begin
					foreach(agent_top.agent[i])
						vseqr.seqr[i]=agent_top.agent[i].seqr;
				end
		end

	if(env_cfg.has_scoreboard)
		begin
			//foreach(agent_top.agent[i])
				agent_top.agent[0].mon.mon_ap.connect(sb.uart0_fifo.analysis_export);
				agent_top.agent[1].mon.mon_ap.connect(sb.uart1_fifo.analysis_export);
		end
/*
	if(env_cfg.has_coverage)
		begin
			//foreach(agent_top.agent[i])
				agent_top.agent[0].mon.mon_ap.connect(uart_cvrg.uart0_fifo.analysis_export);
				agent_top.agent[1].mon.mon_ap.connect(uart_cvrg.uart1_fifo.analysis_export);
		end
*/
	
	if(env_cfg.has_coverage)
		begin
			foreach(agent_top.agent[i])
				agent_top.agent[i].mon.mon_ap.connect(uart_cvrg[i].analysis_export);
		end

	endfunction
