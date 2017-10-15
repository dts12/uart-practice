class uart_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
	
	`uvm_object_utils(uart_virtual_sequence)
	
	uart_env_cfg env_cfg;

	uart_virtual_sequencer v_seqr;
	uart_sequencer seqr[];

	uart_reset_sequence uart_reset_seqs[];
	
	uart0_baud_sequence uart0_baud_seqs;
	uart1_baud_sequence uart1_baud_seqs;

	uart0_halfduplex_p2s_sequence uart0_hd_p2s_seqs;
	uart1_halfduplex_s2p_sequence uart1_hd_s2p_seqs;

	uart0_halfduplex_p2s_5bit_sequence uart0_hd_p2s_5bit_seqs;
	uart1_halfduplex_s2p_5bit_sequence uart1_hd_s2p_5bit_seqs;
	
	uart0_fullduplex_p2s_sequence uart0_fd_p2s_seqs;
	uart1_fullduplex_s2p_sequence uart1_fd_s2p_seqs;
	
	uart0_fullduplex_parityerror_sequence uart0_fd_pe_seqs;
	uart1_fullduplex_parityerror_sequence uart1_fd_pe_seqs;

	uart0_fullduplex_framingerror_sequence uart0_fd_fe_seqs;
	uart1_fullduplex_framingerror_sequence uart1_fd_fe_seqs;
	
	uart0_fullduplex_breakinterrupt_sequence uart0_fd_bi_seqs;
	uart1_fullduplex_breakinterrupt_sequence uart1_fd_bi_seqs;

	uart0_fullduplex_overrun_sequence uart0_fd_oe_seqs;
	uart1_fullduplex_overrun_sequence uart1_fd_oe_seqs;
	
	uart0_fullduplex_timeout_sequence uart0_fd_to_seqs;
	uart1_fullduplex_timeout_sequence uart1_fd_to_seqs;

	uart0_fullduplex_thrempty_sequence uart0_fd_thre_seqs;
	uart1_fullduplex_thrempty_sequence uart1_fd_thre_seqs;


	extern function new(string name = "router_virtual_seqs");
	extern task body();

endclass:uart_virtual_sequence

function uart_virtual_sequence::new(string name = "router_virtual_seqs");
	super.new(name);
endfunction

task uart_virtual_sequence::body();
	if(!uvm_config_db #(uart_env_cfg)::get(null,get_full_name(),"uart_env_cfg",env_cfg))
		`uvm_fatal("VIRTUAL SEQS: ENV CONFIG","FAILED TO GET ENV CONFIG")

	if(!$cast(v_seqr,m_sequencer))
		`uvm_fatal("VIRTUAL SEQS","FAILED CASTING")
	
	uart_reset_seqs=new[env_cfg.no_of_agent];

	seqr=new[env_cfg.no_of_agent];
	foreach(seqr[i])                           
	seqr[i]=v_seqr.seqr[i];

endtask

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class uart_virtual_reset_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_reset_seqs)
	
	function new(string name = "uart_virtual_reset_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();

		foreach(uart_reset_seqs[i])   
			uart_reset_seqs[i]=uart_reset_sequence::type_id::create($sformatf("uart_reset_seqs[%0d]",i));
		
		fork
			uart_reset_seqs[0].start(seqr[0]);
			uart_reset_seqs[1].start(seqr[1]);
		join
	endtask

endclass

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class uart_virtual_baud_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_baud_seqs)
	
	function new(string name = "uart_virtual_baud_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();

			uart0_baud_seqs=uart0_baud_sequence::type_id::create("uart0_baud_seqs");
			uart1_baud_seqs=uart1_baud_sequence::type_id::create("uart1_baud_seqs");
		
		fork
			uart0_baud_seqs.start(seqr[0]);
			uart1_baud_seqs.start(seqr[1]);
		join
	endtask

endclass

/////////////////////////////////////////////////////////////////////   HALF DUPLEX  (8 bit) //////////////////////////////////////////////////////////////////////////////
class uart_virtual_halfduplex_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_halfduplex_seqs)
	
	function new(string name = "uart_virtual_halfduplex_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();

			uart0_hd_p2s_seqs=uart0_halfduplex_p2s_sequence::type_id::create("uart0_hd_p2s_seqs");
			uart1_hd_s2p_seqs=uart1_halfduplex_s2p_sequence::type_id::create("uart1_hd_s2p_seqs");
		
		fork
			uart0_hd_p2s_seqs.start(seqr[0]);
			uart1_hd_s2p_seqs.start(seqr[1]);
		join
	endtask

endclass

/////////////////////////////////////////////////////////////////////   HALF DUPLEX  (5bit) ////////////////////////////////////////////////////////////////////////
class uart_virtual_halfduplex_5bit_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_halfduplex_5bit_seqs)
	
	function new(string name = "uart_virtual_halfduplex_5bit_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();

			uart0_hd_p2s_5bit_seqs=uart0_halfduplex_p2s_5bit_sequence::type_id::create("uart0_hd_p2s_5bit_seqs");
			uart1_hd_s2p_5bit_seqs=uart1_halfduplex_s2p_5bit_sequence::type_id::create("uart1_hd_s2p_5bit_seqs");
		
		//fork
			uart0_hd_p2s_5bit_seqs.start(seqr[0]);
			uart1_hd_s2p_5bit_seqs.start(seqr[1]);
		//join
	endtask

endclass

//////////////////////////////////////////////////////////////////////   FULL DUPLEX    ////////////////////////////////////////////////////////////////////////////
class uart_virtual_fullduplex_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_fullduplex_seqs)
	
	function new(string name = "uart_virtual_fullduplex_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();

			uart0_fd_p2s_seqs=uart0_fullduplex_p2s_sequence::type_id::create("uart0_fd_p2s_seqs");
			uart1_fd_s2p_seqs=uart1_fullduplex_s2p_sequence::type_id::create("uart1_fd_s2p_seqs");
		
	//	repeat(2)
		begin
		fork
				uart0_fd_p2s_seqs.start(seqr[0]);
				uart1_fd_s2p_seqs.start(seqr[1]);
		join
		end
	endtask

endclass

////////////////////////////////////////////////////////////////////   FULL DUPLEX (PARITY ERROR)    ///////////////////////////////////////////////////////////////
class uart_virtual_fullduplex_parityerror_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_fullduplex_parityerror_seqs)
	
	function new(string name = "uart_virtual_fullduplex_parityerror_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();
			uart0_fd_pe_seqs=uart0_fullduplex_parityerror_sequence::type_id::create("uart0_fd_pe_seqs");
			uart1_fd_pe_seqs=uart1_fullduplex_parityerror_sequence::type_id::create("uart1_fd_pe_seqs");
		
	//repeat(2)
		begin
		fork
				uart0_fd_pe_seqs.start(seqr[0]);
				uart1_fd_pe_seqs.start(seqr[1]);
		join
		end
	endtask

endclass

////////////////////////////////////////////////////////////////////   FULL DUPLEX (FRAMING ERROR)    //////////////////////////////////////////////////////////////
class uart_virtual_fullduplex_framingerror_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_fullduplex_framingerror_seqs)
	
	function new(string name = "uart_virtual_fullduplex_framingerror_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();
			uart0_fd_fe_seqs=uart0_fullduplex_framingerror_sequence::type_id::create("uart0_fd_fe_seqs");
			uart1_fd_fe_seqs=uart1_fullduplex_framingerror_sequence::type_id::create("uart1_fd_fe_seqs");
		
	//repeat(2)
		begin
		fork
				uart0_fd_fe_seqs.start(seqr[0]);
				uart1_fd_fe_seqs.start(seqr[1]);
		join
		end
	endtask

endclass

////////////////////////////////////////////////////////////////////   FULL DUPLEX (BREAK INTERRUPT)    //////////////////////////////////////////////////////////////
class uart_virtual_fullduplex_breakinterrupt_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_fullduplex_breakinterrupt_seqs)
	
	function new(string name = "uart_virtual_fullduplex_breakinterrupt_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();
			uart0_fd_bi_seqs=uart0_fullduplex_breakinterrupt_sequence::type_id::create("uart0_fd_bi_seqs");
			uart1_fd_bi_seqs=uart1_fullduplex_breakinterrupt_sequence::type_id::create("uart1_fd_bi_seqs");
		
	//repeat(2)
		begin
		fork
				uart0_fd_bi_seqs.start(seqr[0]);
				uart1_fd_bi_seqs.start(seqr[1]);
		join
		end
	endtask

endclass

////////////////////////////////////////////////////////////////////   FULL DUPLEX (OVERRUN ERROR)    //////////////////////////////////////////////////////////////
class uart_virtual_fullduplex_overrun_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_fullduplex_overrun_seqs)
	
	function new(string name = "uart_virtual_fullduplex_overrun_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();
			uart0_fd_oe_seqs=uart0_fullduplex_overrun_sequence::type_id::create("uart0_fd_oe_seqs");
			uart1_fd_oe_seqs=uart1_fullduplex_overrun_sequence::type_id::create("uart1_fd_oe_seqs");
		
	//repeat(2)
		begin
		fork
				uart0_fd_oe_seqs.start(seqr[0]);
				uart1_fd_oe_seqs.start(seqr[1]);
		join
		end
	endtask

endclass

////////////////////////////////////////////////////////////////////   FULL DUPLEX (TIMEOUT)    //////////////////////////////////////////////////////////////
class uart_virtual_fullduplex_timeout_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_fullduplex_timeout_seqs)
	
	function new(string name = "uart_virtual_fullduplex_timeout_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();
			uart0_fd_to_seqs=uart0_fullduplex_timeout_sequence::type_id::create("uart0_fd_to_seqs");
			uart1_fd_to_seqs=uart1_fullduplex_timeout_sequence::type_id::create("uart1_fd_to_seqs");
		
	//repeat(2)
		begin
		fork
				uart0_fd_to_seqs.start(seqr[0]);
				uart1_fd_to_seqs.start(seqr[1]);
		join
		end
	endtask

endclass

////////////////////////////////////////////////////////////////////   FULL DUPLEX (THR EMPTY INTERRUPT)    //////////////////////////////////////////////////////////////
class uart_virtual_fullduplex_thrempty_seqs extends uart_virtual_sequence ;

	`uvm_object_utils(uart_virtual_fullduplex_thrempty_seqs)
	
	function new(string name = "uart_virtual_fullduplex_thrempty_seqs");
		super.new(name);
	endfunction

	task body();
		super.body();
			uart0_fd_thre_seqs=uart0_fullduplex_thrempty_sequence::type_id::create("uart0_fd_thre_seqs");
			uart1_fd_thre_seqs=uart1_fullduplex_thrempty_sequence::type_id::create("uart1_fd_thre_seqs");
		
	//repeat(2)
		begin
		fork
				uart0_fd_thre_seqs.start(seqr[0]);
				uart1_fd_thre_seqs.start(seqr[1]);
		join
		end
	endtask

endclass
