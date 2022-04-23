//# log2 OC

//[soft-float-starter-pack/Transcendental.cs at master � Kimbatt/soft-float-starter-pack](https://github.com/Kimbatt/soft-float-starter-pack/blob/master/SoftFloat/libm/Transcendental.cs)

//```verilog
/// <summary>
        /// Returns the base 2 logarithm of x
        /// </summary>
        
         `define IVLN2HI_U32 32'h3fb8b000 // 1.4428710938e+00
          `define IVLN2LO_U32 32'hb9389ad4 // -1.7605285393e-04
          
          `define LG1_U32  32'h3f2aaaaa // 0.66666662693 /*  0xaaaaaa.0p-24*/
          `define LG2_U32  32'h3eccce13 // 0.40000972152 /*  0xccce13.0p-25 */
          `define LG3_U32  32'h3e91e9ee // 0.28498786688 /*  0x91e9ee.0p-25 */
          `define LG4_U32  32'h3e789e26 // 0.24279078841 /*  0xf89e26.0p-26 */
 
          
        module log_operation (input [31:0]x_i, output [31:0]log);
        
          
          //  uint IVLN2HI_U32;
          

            /* |(log(1+s)-log(1-s))/s - Lg(s)| < 2**-34.24 (~[-4.95e-11, 4.97e-11]). */
            
            reg [31:0]x1p25f = 32'h4c000000; // 0x1p25f === 2 ^ 25

            reg [31:0] ui; //uint
            reg [31:0] hfsq;
            reg [31:0] f;
            reg [31:0] s;
            reg [31:0] z;
            reg [31:0] r;
            reg [31:0] w;
            reg [31:0] t1;
            reg [31:0] t2;
            reg [31:0] hi;
            reg [31:0] lo;
            
            reg [31:0] ix; //uint 
            reg[31:0] k;         //int
            reg [31:0] x;
  

always @(*) begin
    x=x_i;
            ui = x;
    
            ix = ui;
            k = 0;
            if (ix < 32'h00800000 || (ix >> 31) > 0)
            begin
                /* x < 2**-126  */
                if (ix << 1 == 0)
                begin
                    //return -1. / (x * x); /* log(+-0)=-inf */
                    log= 32'hff80000;
                    break; //NEGATIVE INFINITE
                end

                if ((ix >> 31) > 0)
                begin
                    //return (x - x) / 0.0; /* log(-#) = NaN */
                    log =  32'h7fffffff;
                    break;  //NaN
              end

                /* subnormal number, scale up x */
                k = k-25;
                
                
 end             
            ///FUNCTIE DE INMULTIRE
    
    inmultire instanta(.a(x_i), .b(x1p25f), .mul32(x));
    
              //  x = x*x1p25f;
                
                
          
                ui = x;
                ix = ui;
          end
            else if (ix >= 32'h7f800000)
            begin
                log = x;
                break;
          end
            else if (ix == 32'h3f800000)
            begin
                log = 32'h00000000; 
                break;//ZERO
          end

            /* reduce x into [sqrt(2)/2, sqrt(2)] */
            ix += 32'h3f800000 - 32'h3f3504f3;
            k += (int)(ix >> 23) - 0x7f;
            ix = (ix & 32'h007fffff) + 32'h3f3504f3;
            ui = ix;
            x = ui;

            f = x - 32'h3F800000;
            s = f / ((sfloat)2.0f + f);
            z = s * s;
            w = z * z;
            t1 = w * (LG2_U32 + w * LG4_U32);
            t2 = z * (LG1_U32 + w * LG3_U32);
            r = t2 + t1;
            hfsq = 0.5f * f * f;

            hi = f - hfsq;
            ui = hi;
            ui =ui & 32'hfffff000;
            hi = ui;
            lo = f - hi - hfsq + s * (hfsq + r);
            log = (lo + hi) * IVLN2LO_U32 + lo * IVLN2HI_U32 + hi * IVLN2HI_U32 + k;
           
           
         end 
          endmodule;
        
//```

//[GitHub - SandaMura/Proiect_FPU_OC at Branch_sapt7](https://github.com/SandaMura/Proiect_FPU_OC/tree/Branch_sapt7)