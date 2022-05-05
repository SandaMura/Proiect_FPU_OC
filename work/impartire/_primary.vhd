library verilog;
use verilog.vl_types.all;
entity impartire is
    port(
        f1              : in     vl_logic_vector(31 downto 0);
        f2              : in     vl_logic_vector(31 downto 0);
        result          : out    vl_logic_vector(31 downto 0)
    );
end impartire;
