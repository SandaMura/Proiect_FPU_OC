library verilog;
use verilog.vl_types.all;
entity div_r2 is
    port(
        clk             : in     vl_logic;
        opa             : in     vl_logic_vector(49 downto 0);
        opb             : in     vl_logic_vector(23 downto 0);
        quo             : out    vl_logic_vector(49 downto 0);
        \rem\           : out    vl_logic_vector(49 downto 0)
    );
end div_r2;
