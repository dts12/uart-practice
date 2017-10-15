class uart_driver extends uvm_driver #(uart_transaction);

	`uvm_component_utils(uart_driver)

	virtual uart_interface.DRV vif;
	
	uart_agent_cfg agent_cfg;

	extern function new(string name="uart_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(uart_transaction xtn);
	extern task drv_we_data_stb_cyc_sel(uart_transaction xtn);

endclass

	function uart_driver::new(string name="uart_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void uart_driver::build_phase(uvm_phase phase);
		if(!uvm_config_db #(uart_agent_cfg)::get(this,"","uart_agent_cfg",agent_cfg))
			`uvm_fatal("AGENT:ENV CONFIG","FAILED TO GET ENC_CFG")
		super.build_phase(phase);
	endfunction

	function void uart_driver::connect_phase(uvm_phase phase);
		vif=agent_cfg.vif;
	endfunction
	
	task uart_driver::run_phase(uvm_phase phase);
		//rsp= uart_transaction::type_id::create("rsp");
		//@(vif.drv_cb);
		
		vif.wb_rst_i<=1;
		repeat(2) @(vif.drv_cb);
		vif.wb_rst_i<=0;
		
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				//seq_item_port.item_done();
			end

	endtask

	task uart_driver::send_to_dut(uart_transaction xtn);
		
		@(vif.drv_cb);
		if(xtn.wb_we_i==0 && xtn.ctrl_reg==2)
			begin 
				wait(vif.drv_cb.int_o)
				drv_we_data_stb_cyc_sel(xtn);         						
				xtn.rxn_reg=vif.drv_cb.wb_dat_o;
				seq_item_port.put_response(xtn);
			end
		else
			drv_we_data_stb_cyc_sel(xtn);         						
			                                 
		`uvm_info("UART_DRIVER",$sformatf("========================Printing from driver====================== \n %s",xtn.sprint()),UVM_LOW)

	endtask
	
	task uart_driver::drv_we_data_stb_cyc_sel(uart_transaction xtn);
		vif.drv_cb.wb_adr_i<=xtn.ctrl_reg;
		vif.drv_cb.wb_we_i<=xtn.wb_we_i;                    							 ////////////vif.drv_cb.wb_we_i<=0; for batch mode output of reset      
		vif.drv_cb.wb_dat_i<=xtn.txn_reg;
		vif.drv_cb.wb_stb_i<=1;
		vif.drv_cb.wb_cyc_i<=1;
		vif.drv_cb.wb_sel_i<=1;
		wait(vif.drv_cb.wb_ack_o)
		vif.drv_cb.wb_we_i<=0;
		vif.drv_cb.wb_stb_i<=0;
		vif.drv_cb.wb_cyc_i<=0;        
		seq_item_port.item_done();
	endtask
