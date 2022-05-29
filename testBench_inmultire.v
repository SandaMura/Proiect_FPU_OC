module testBench_inmutire();
   reg [31:0]a, b;
  wire [31:0]p;

  inmultire instanta(.a(a), .b(b), .mul32(p));
  
  initial begin
    a=32'h41b1999a;
    b=32'h41300000; 
  end
endmodule  