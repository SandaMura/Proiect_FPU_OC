module test_log();
   reg [31:0]x_i;
  wire [31:0]log_output;

  log_operation inst(.x_i(x_i), .log_output(log_output));
  
  initial begin
    x_i=32'h41000000;
  
  end
endmodule  