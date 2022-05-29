module testBench_adunare();
   reg [31:0]a, b;
  wire [31:0]sum;

  add_fl_22 instanta(.a(a), .b(b), .sum(sum));
  
  initial begin
    a=32'h40800000; //4
    b=32'h5621b01d; //6
  end
endmodule  
