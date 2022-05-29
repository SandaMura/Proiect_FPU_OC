library verilog;
use verilog.vl_types.all;
entity log_operation is
    port(
        x               : in     vl_logic_vector(31 downto 0);
        rez             : out    vl_logic_vector(31 downto 0)
    );
end log_operation;
