library verilog;
use verilog.vl_types.all;
entity uart_interface is
    generic(
        uart_data_width : integer := 32;
        uart_addr_width : integer := 5
    );
    port(
        clock           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of uart_data_width : constant is 1;
    attribute mti_svvh_generic_type of uart_addr_width : constant is 1;
end uart_interface;
