library verilog;
use verilog.vl_types.all;
entity pre_norm is
    port(
        clk             : in     vl_logic;
        rmode           : in     vl_logic_vector(1 downto 0);
        add             : in     vl_logic;
        opa             : in     vl_logic_vector(31 downto 0);
        opb             : in     vl_logic_vector(31 downto 0);
        opa_nan         : in     vl_logic;
        opb_nan         : in     vl_logic;
        fracta_out      : out    vl_logic_vector(26 downto 0);
        fractb_out      : out    vl_logic_vector(26 downto 0);
        exp_dn_out      : out    vl_logic_vector(7 downto 0);
        sign            : out    vl_logic;
        nan_sign        : out    vl_logic;
        result_zero_sign: out    vl_logic;
        fasu_op         : out    vl_logic
    );
end pre_norm;
