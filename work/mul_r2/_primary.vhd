library verilog;
use verilog.vl_types.all;
entity mul_r2 is
    port(
        clk             : in     vl_logic;
        opa             : in     vl_logic_vector(23 downto 0);
        opb             : in     vl_logic_vector(23 downto 0);
        prod            : out    vl_logic_vector(47 downto 0)
    );
end mul_r2;
