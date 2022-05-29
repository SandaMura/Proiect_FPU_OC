module testBench_impartire();
   reg [31:0]a, b;
  wire [31:0]c;

  impartire instanta(.f1(a), .f2(b), .result(c));
  
  initial begin
   a=32'h45c37371;
    b=32'h4158f5c3; 
  end
endmodule  