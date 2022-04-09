library verilog;
use verilog.vl_types.all;
entity post_norm is
    generic(
        f2i_emax        : integer := 157
    );
    port(
        clk             : in     vl_logic;
        fpu_op          : in     vl_logic_vector(2 downto 0);
        opas            : in     vl_logic;
        sign            : in     vl_logic;
        rmode           : in     vl_logic_vector(1 downto 0);
        fract_in        : in     vl_logic_vector(47 downto 0);
        exp_in          : in     vl_logic_vector(7 downto 0);
        exp_ovf         : in     vl_logic_vector(1 downto 0);
        opa_dn          : in     vl_logic;
        opb_dn          : in     vl_logic;
        rem_00          : in     vl_logic;
        div_opa_ldz     : in     vl_logic_vector(4 downto 0);
        output_zero     : in     vl_logic;
        \out\           : out    vl_logic_vector(30 downto 0);
        ine             : out    vl_logic;
        overflow        : out    vl_logic;
        underflow       : out    vl_logic;
        f2i_out_sign    : out    vl_logic
    );
end post_norm;
