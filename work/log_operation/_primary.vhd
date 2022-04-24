library verilog;
use verilog.vl_types.all;
entity log_operation is
    port(
        x_i             : in     vl_logic_vector(31 downto 0);
        log_output      : out    vl_logic_vector(31 downto 0)
    );
end log_operation;
