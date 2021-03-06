module impartire(input [31:0]f1, 
                 input [31:0]f2,
                 output reg[31:0]result);
      


            //int man1;
            //int rawExp1 = f1.RawExponent;
            //uint sign1;
            //uint sign2;
            
           reg [31:0]sgn1;
           reg [31:0]sgn2; ///semnul este sgn[0];
reg [7:0]ex1;
reg [7:0]ex2;
reg [22:0]man1;
reg [22:0]man2;
reg[23:0] man;
reg[7:0] ex;
reg[31:0] sign;
  integer i;
  integer shift;
  integer i2;
  integer shift2;
   integer absMan;

always @(*) begin
  
       ex1 = f1[30:23];
       ex2 = f2[30:23];
       man1 = f1[22:0];
       man2 = f2[22:0];

       
            if (f1==32'h7fffffff || f2==32'h7fffffff)
            begin
                result = 32'h7fffffff; //NaN
            end
            if (ex1 == 0)
            begin
                // SubNorm
                sgn1 = f1>>31;
                //int rawMan1 = f1.RawMantissa;
                if (man1 == 0)
                begin
                    if (f2==32'h00000000)
                    begin
                        // 0 / 0
                        result = 32'h7fffffff;
                    end
                    else
                    begin
                        // 0 / f
                       result=32'h00000000;
                    end
              end

                /*int shift = clz(rawMan1 & 32'h00ffffff) - 8;  ///COUNT LEADING ZEROS
                
                man1 <<= shift;
                ex = 1 - shift;*/
                
            
              i=23;                
                while(man1[i]==0)
                begin
                  shift=shift+1;
                  i=i-1;
               end
              
              man1=man1<<shift;
              ex=1-shift;
              

                //Debug.Assert(rawMan1 >> MantissaBits == 1);
                man1 = ((man1 ^ sgn1) - sgn1);
          end
            else if (ex != 255)
            begin
                // Norm
                sgn1 = f1>>31;
                man1 = (((man1 | 32'h800000) ^ sgn1) - sgn1);
          end
            else
            begin
                // Non finite
                if (f1 ==32'h7f800000)
                begin
                    if (f2==32'h00000000)
                    begin
                        // Infinity / 0
                        result=32'h7f800000; //+inf
                  end

                    // +-Infinity / Infinity
                    result = 32'h7fffffff;
              end
                else if (f1 == 32'hff800000)
                begin
                    if (f2==32'h00000000)
                    begin
                        // -Infinity / 0
                        result = 32'hff800000; //-inf
                  end

                    // -Infinity / +-Infinity
                    result= 32'h7fffffff;
              end
                else
                begin
                    // NaN
                    result = f1;
              end
          end

           // int man2;
            //int rawExp2 = f2.RawExponent;
            if (ex2 == 0)
            begin
                // SubNorm
                sgn2 = f2>>31;
               //int rawMan2 = f2.RawMantissa;
                if (man2 == 0)
                begin
                    // f / 0
                    result = ((f1 ^ f2)>>31 | 32'h7f800000);
              end

                /*int shift = clz(man22 & 32'h00ffffff) - 8;
                rawMan2 <<= shift;
                rawExp2 = 1 - shift;*/
                
                
              i2=23;                
                while(man1[i]==0)
                begin
                  shift2=shift2+1;
                  i2=i2-1;
               end
              
              man2=man2<<shift2;
              ex=1-shift2;

                //Debug.Assert(rawMan2 >> MantissaBits == 1);
                man2 = ((man2 ^ sgn2) - sgn2);
          end
            else if (ex2 != 255)
            begin
                // Norm
                sgn2 = f2>>31;
                man2 = (((man2 | 32'h800000) ^ sgn2) - sgn2);
          end
            else
            begin
                // Non finite
                if (f2 == 32'h7f800000)
                begin
                    if (f1==32'h00000000)
                    begin
                        // 0 / Infinity
                        result = 32'h00000000;
                  end

                    if (sgn1 == 0)
                    begin
                        // f / Infinity
                        result= 32'h7f800000;
                  end
                    else
                    begin
                        // -f / Infinity
                        result = 32'hff800000;
                  end
              end
                else if (f2== 32'hff800000)
                begin
                    if (f1==0)
                    begin
                        // 0 / -Infinity
                        result=32'h7fffffff;
                  end

                    if (sgn1 == 1)
                    begin
                        // -f / -Infinity
                        result = 32'h7f800000;
                  end
                    else
                    begin
                        // f / -Infinity
                        result =  32'hff800000;
                  end
              end
                else
                begin
                    // NaN
                    result = 32'h7fffffff;
              end
          end
///??????????????????????????????????????????????????????????????????????
           // long longMan = (man1 << MantissaBits) / man2;
           $display("man1: %b", man1);
           $display("man2: %b", man2);
          
           man = {1'b1, man1 , 23'b0} / {23'b0,1'b1,man2};
            $display("mantisa dupa impartire: %b", man);
            //int man = (int)longMan;
            //Debug.Assert(man != 0);
           
            if(man[23]==1) absMan=-man;
            else absMan=man;
           // int rawExp = rawExp1 - rawExp2 + 127; //exponent bias
           ex = ex1 - ex2 + 127;
           $display("exponentul este: %b", ex);
            sign = man & 32'h80000000;

            if ((absMan & 32'h800000) == 0)
            begin
                absMan= absMan<< 1;
                ex=ex-1;
                $display("exponentul este: %b", ex);
          end

            //Debug.Assert(absMan >> MantissaBits == 1);
            if (ex >= 255)
            begin
                // Overflow
                result= sign ^ 32'h7f800000;
          end

            if (ex <= 0)
            begin
                // Subnorms/Underflow
                if (ex <= -24)
                begin
                    result =sign;
              end

                absMan=absMan>>( -ex + 1);
                ex = 0;
             end
             $display("exponentul este: %b", ex);
           // result = sign | (ex <<23) | (absMan & 32'h7FFFFF);
           $display("array sign: %b", sign);
           result={sign[0], ex, man[22:0]};
     
      
 
end
endmodule