module test_log();
   reg [31:0]x;
  wire [31:0]rez;

  LOG2 inst(.x(x), .rez(rez));
  
  initial begin
    x=32'h41000000;
  
  end
endmodule  