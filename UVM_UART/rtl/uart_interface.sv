interface uart_interface(input bit clock);

parameter 							 uart_data_width = `UART_DATA_WIDTH;
parameter 							 uart_addr_width = `UART_ADDR_WIDTH;

logic 								 wb_clk_i;
// WISHBONE interface
logic 								 wb_rst_i;
logic [uart_addr_width-1:0] 	 wb_adr_i;
logic [uart_data_width-1:0] 	 wb_dat_i;
logic [uart_data_width-1:0] 	 wb_dat_o;
logic 								 wb_we_i;
logic 								 wb_stb_i;
logic 								 wb_cyc_i;
logic [3:0]							 wb_sel_i;
logic 								 wb_ack_o;
logic 								 int_o;

// UART	signals
logic 								 srx_pad_i;
logic 								 stx_pad_o;
logic 								 rts_pad_o;
logic 								 cts_pad_i;
logic 								 dtr_pad_o;
logic 								 dsr_pad_i;
logic 								 ri_pad_i;
logic 								 dcd_pad_i;

// optional baudrate output

logic	baud_o;

  clocking drv_cb @(posedge clock);
    default input #1 output #0;
    output wb_rst_i;
	output wb_adr_i;
	output wb_dat_i;
	input wb_dat_o;
	output 								 wb_we_i;
	output 								 wb_stb_i;
	output								 wb_cyc_i;
	output wb_sel_i;
	input 								 wb_ack_o;
	input 								 int_o;
  endclocking

  clocking mon_cb @(posedge clock);
    default input #1 output #0;
    input wb_rst_i;
	input wb_adr_i;
	input wb_dat_i;
	input wb_dat_o;
	input 								 wb_we_i;
	input 								 wb_stb_i;
	input 								 wb_cyc_i;
	input wb_sel_i;
	input 								 wb_ack_o;
	input 								 int_o;
  endclocking

  modport DRV (clocking drv_cb,output wb_rst_i);
  modport MON (clocking mon_cb);

endinterface