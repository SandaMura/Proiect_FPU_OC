library verilog;
use verilog.vl_types.all;
entity add_fl_22 is
    port(
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        sum             : out    vl_logic_vector(31 downto 0)
    );
end add_fl_22;
