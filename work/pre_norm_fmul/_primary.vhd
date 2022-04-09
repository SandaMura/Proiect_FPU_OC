library verilog;
use verilog.vl_types.all;
entity pre_norm_fmul is
    port(
        clk             : in     vl_logic;
        fpu_op          : in     vl_logic_vector(2 downto 0);
        opa             : in     vl_logic_vector(31 downto 0);
        opb             : in     vl_logic_vector(31 downto 0);
        fracta          : out    vl_logic_vector(23 downto 0);
        fractb          : out    vl_logic_vector(23 downto 0);
        exp_out         : out    vl_logic_vector(7 downto 0);
        sign            : out    vl_logic;
        sign_exe        : out    vl_logic;
        inf             : out    vl_logic;
        exp_ovf         : out    vl_logic_vector(1 downto 0);
        underflow       : out    vl_logic_vector(2 downto 0)
    );
end pre_norm_fmul;
