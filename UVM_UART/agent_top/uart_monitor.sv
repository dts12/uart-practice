class uart_monitor extends uvm_monitor;
	
	`uvm_component_utils(uart_monitor)

	virtual uart_interface.MON vif;
	
	
	uvm_analysis_port #(uart_transaction) mon_ap;


	uart_agent_cfg agent_cfg;
	uart_transaction data2sb;
	extern function new(string name="uart_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();


endclass
	
	function uart_monitor::new(string name="uart_monitor",uvm_component parent);
		super.new(name,parent);
		mon_ap=new("analysis port",this);
	endfunction

	function void uart_monitor::build_phase(uvm_phase phase);
		if(!uvm_config_db #(uart_agent_cfg)::get(this,"","uart_agent_cfg",agent_cfg))
			`uvm_fatal("AGENT:ENV CONFIG","FAILED TO GET ENC_CFG")
		super.build_phase(phase);
	endfunction

	function void uart_monitor::connect_phase(uvm_phase phase);
		vif=agent_cfg.vif;
	endfunction

	task uart_monitor::run_phase(uvm_phase phase);
		//uart_transaction data2sb;
		data2sb= uart_transaction::type_id::create("data2sb");
		forever
			collect_data();
		endtask

	task uart_monitor::collect_data();	
		
		wait(vif.mon_cb.wb_ack_o)
			if(vif.mon_cb.wb_we_i)
				begin
					data2sb.we=vif.mon_cb.wb_we_i;
					if(vif.mon_cb.wb_adr_i==3)
						begin
							@(vif.mon_cb);	
							data2sb.ctrl_reg=vif.mon_cb.wb_adr_i;
							data2sb.lcr_reg=vif.mon_cb.wb_dat_i;	
							/*case(data2sb.lcr_reg[1:0])
								2'b00:data2sb.no_of_bits=5;
								2'b01:data2sb.no_of_bits=6;
								2'b10:data2sb.no_of_bits=7;
								2'b11:data2sb.no_of_bits=8;
							endcase*/
						end
					else if(vif.mon_cb.wb_adr_i==0)
						begin
							if(data2sb.lcr_reg[7])
								begin
									@(vif.mon_cb);	
									data2sb.ctrl_reg=vif.mon_cb.wb_adr_i;
									data2sb.dlr=vif.mon_cb.wb_dat_i;
								end
							else
								begin
									@(vif.mon_cb);	
									data2sb.ctrl_reg=vif.mon_cb.wb_adr_i;
									data2sb.txn_reg_2sb.push_back(vif.mon_cb.wb_dat_i);
									data2sb.txn_reg=vif.mon_cb.wb_dat_i;
								end
						end
					else if(vif.mon_cb.wb_adr_i==1)
						begin
							@(vif.mon_cb);	
							data2sb.ctrl_reg=vif.mon_cb.wb_adr_i;
							data2sb.ier=vif.mon_cb.wb_dat_i;
						end
					else if(vif.mon_cb.wb_adr_i==2)
						begin
							@(vif.mon_cb);	
							data2sb.ctrl_reg=vif.mon_cb.wb_adr_i;
							data2sb.fcr=vif.mon_cb.wb_dat_i;
						end
				end
			else if(~vif.mon_cb.wb_we_i)
				begin
					data2sb.we=vif.mon_cb.wb_we_i;
					if(vif.mon_cb.wb_adr_i==2)
						begin
							@(vif.mon_cb);	
							data2sb.ctrl_reg=vif.mon_cb.wb_adr_i;
							data2sb.iir=vif.mon_cb.wb_dat_o;
						end
					else if(vif.mon_cb.wb_adr_i==5)
						begin
							data2sb.ctrl_reg=vif.mon_cb.wb_adr_i;
							data2sb.lsr=vif.mon_cb.wb_dat_o;
							@(vif.mon_cb);	
							//$display(data2sb.lsr);
							//$stop;
						end
					else if(vif.mon_cb.wb_adr_i==0)
						begin
							@(vif.mon_cb);	
							data2sb.ctrl_reg=vif.mon_cb.wb_adr_i;
						  data2sb.rxn_reg_2sb.push_back(vif.mon_cb.wb_dat_o);
						end
				end
		mon_ap.write(data2sb);
		`uvm_info("UART_MONITOR",$sformatf("========================Printing from monitor====================== \n %s",data2sb.sprint()),UVM_LOW) 
	endtask
