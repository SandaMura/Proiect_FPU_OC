library verilog;
use verilog.vl_types.all;
entity add_sub27 is
    port(
        add             : in     vl_logic;
        opa             : in     vl_logic_vector(26 downto 0);
        opb             : in     vl_logic_vector(26 downto 0);
        sum             : out    vl_logic_vector(26 downto 0);
        co              : out    vl_logic
    );
end add_sub27;
