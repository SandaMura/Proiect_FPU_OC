library verilog;
use verilog.vl_types.all;
entity inmultire is
    port(
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        mul32           : out    vl_logic_vector(31 downto 0)
    );
end inmultire;
