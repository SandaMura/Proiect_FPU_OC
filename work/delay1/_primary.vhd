library verilog;
use verilog.vl_types.all;
entity delay1 is
    generic(
        N               : integer := 1
    );
    port(
        clk             : in     vl_logic;
        \in\            : in     vl_logic_vector;
        \out\           : out    vl_logic_vector
    );
end delay1;
