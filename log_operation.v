//# log2 OC

//[soft-float-starter-pack/Transcendental.cs at master · Kimbatt/soft-float-starter-pack](https://github.com/Kimbatt/soft-float-starter-pack/blob/master/SoftFloat/libm/Transcendental.cs)

//```verilog
/// <summary>
        /// Returns the base 2 logarithm of x
        /// </summary>
        
       /*  `define IVLN2HI_U32 32'h3fb8b000 // 1.4428710938e+00
          `define IVLN2LO_U32 32'hb9389ad4 // -1.7605285393e-04
          
          `define LG1_U32  32'h3f2aaaaa // 0.66666662693 /*  0xaaaaaa.0p-24*/
        //  `define LG2_U32  32'h3eccce13 // 0.40000972152 /*  0xccce13.0p-25 */
        //  `define LG3_U32  32'h3e91e9ee // 0.28498786688 /*  0x91e9ee.0p-25 */
        //  `define LG4_U32  32'h3e789e26 // 0.24279078841 /*  0xf89e26.0p-26 */

          
module log_operation (input [31:0]x_i, output [31:0]log_output);
        
          
          //  uint IVLN2HI_U32;
          `define IVLN2HI_U32 32'h3fb8b000 // 1.4428710938e+00
          `define IVLN2LO_U32 32'hb9389ad4 // -1.7605285393e-04
          
          `define LG1_U32  32'h3f2aaaaa // 0.66666662693 /*  0xaaaaaa.0p-24*/
          `define LG2_U32  32'h3eccce13 // 0.40000972152 /*  0xccce13.0p-25 */
          `define LG3_U32  32'h3e91e9ee // 0.28498786688 /*  0x91e9ee.0p-25 */
          `define LG4_U32  32'h3e789e26 // 0.24279078841 /*  0xf89e26.0p-26 */
          

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
            reg [31:0] produs;
            reg[31:0] log;
            
            
///functia de inmultire         
function [31:0]mul32;
                 
input [31:0]a,b;
///1-sgn, 8-exp, 35-man
reg sgna;
reg sgnb;
integer exa;///poate retine si denormalizate
integer exb;
reg [22:0]mana;
reg [22:0]manb;
reg a_n; //este a normalizat?
reg b_n;
reg [23:0]sa;//significand(cu tot cu hidden bit)
reg [23:0]sb;
integer ze;///daca e caz de overflow/underflow sa se retina
reg [47:0]sz;///pe 48 de biti pentru rez partial (inmultire significanti)
reg sgnz;
reg inf,den;

begin
//always @(*) begin
mana = a[22:0];
manb = b[22:0];
a_n = |(a[30:23]); //daca toti bitii exponentului sunt zero => denormalizat
b_n = |(b[30:23]);
exa = a[30:23];
exb = b[30:23];
sa = {a_n,mana};//significand(cu tot cu hidden bit)
sb = {b_n,manb};
sgna = a[31];
sgnb = b[31];
exa = exa - 127;
exb = exb - 127;
inf=0;
den=0;
//daca e denormalizat
///shiftez !!!!!!
if(a_n == 0) begin
exa = exa + 1;
casex(sa)
24'b01??????????????????????: begin sa = sa<<1; exa = exa-1; end
24'b001?????????????????????: begin sa = sa<<2; exa = exa-2; end
24'b0001????????????????????: begin sa = sa<<3; exa = exa-3; end
24'b00001???????????????????: begin sa = sa<<4; exa = exa-4; end
24'b000001??????????????????: begin sa = sa<<5; exa = exa-5; end
24'b0000001?????????????????: begin sa = sa<<6; exa = exa-6; end
24'b00000001????????????????: begin sa = sa<<7; exa = exa-7; end
24'b000000001???????????????: begin sa = sa<<8; exa = exa-8; end
24'b0000000001??????????????: begin sa = sa<<9; exa = exa-9; end
24'b00000000001?????????????: begin sa = sa<<10; exa = exa-10; end
24'b000000000001????????????: begin sa = sa<<11; exa = exa-11; end
24'b0000000000001???????????: begin sa = sa<<12; exa = exa-12; end
24'b00000000000001??????????: begin sa = sa<<13; exa = exa-13; end
24'b000000000000001?????????: begin sa = sa<<14; exa = exa-14; end
24'b0000000000000001????????: begin sa = sa<<15; exa = exa-15; end
24'b00000000000000001???????: begin sa = sa<<16; exa = exa-16; end
24'b000000000000000001??????: begin sa = sa<<17; exa = exa-17; end
24'b0000000000000000001?????: begin sa = sa<<18; exa = exa-18; end
24'b00000000000000000001????: begin sa = sa<<19; exa = exa-19; end
24'b000000000000000000001???: begin sa = sa<<20; exa = exa-20; end
24'b0000000000000000000001??: begin sa = sa<<21; exa = exa-21; end
24'b00000000000000000000001?: begin sa = sa<<22; exa = exa-22; end
24'b000000000000000000000001: begin sa = sa<<23; exa = exa-23; end
24'b000000000000000000000000: begin exa=0; end
 
endcase
end


if(b_n == 0) begin
exb = exb + 1;
casex(sb)
24'b01??????????????????????: begin sb = sb<<1; exb = exb-1; end
24'b001?????????????????????: begin sb = sb<<2; exb = exb-2; end
24'b0001????????????????????: begin sb = sb<<3; exb = exb-3; end
24'b00001???????????????????: begin sb = sb<<4; exb = exb-4; end
24'b000001??????????????????: begin sb = sb<<5; exb = exb-5; end
24'b0000001?????????????????: begin sb = sb<<6; exb = exb-6; end
24'b00000001????????????????: begin sb = sb<<7; exb = exb-7; end
24'b000000001???????????????: begin sb = sb<<8; exb = exb-8; end
24'b0000000001??????????????: begin sb = sb<<9; exb = exb-9; end
24'b00000000001?????????????: begin sb = sb<<10; exb = exb-10; end
24'b000000000001????????????: begin sb = sb<<11; exb = exb-11; end
24'b0000000000001???????????: begin sb = sb<<12; exb = exb-12; end
24'b00000000000001??????????: begin sb = sb<<13; exb = exb-13; end
24'b000000000000001?????????: begin sb = sb<<14; exb = exb-14; end
24'b0000000000000001????????: begin sb = sb<<15; exb = exb-15; end
24'b00000000000000001???????: begin sb = sb<<16; exb = exb-16; end
24'b000000000000000001??????: begin sb = sb<<17; exb = exb-17; end
24'b0000000000000000001?????: begin sb = sb<<18; exb = exb-18; end
24'b00000000000000000001????: begin sb = sb<<19; exb = exb-19; end
24'b000000000000000000001???: begin sb = sb<<20; exb = exb-20; end
24'b0000000000000000000001??: begin sb = sb<<21; exb = exb-21; end
24'b00000000000000000000001?: begin sb = sb<<22; exb = exb-22; end
24'b000000000000000000000001: begin sb = sb<<23; exb = exb-23; end
24'b000000000000000000000000: begin exb=0; end
endcase
end
ze = exa + exb;
sz = sa * sb;
$display ("%d", ze); 
//cazuri 01.xx 1x.xx
if(sz[47])begin
  $display("hgxsdvw");
sz[1] = sz[0]|sz[1];
sz = sz>>1;
ze = ze+1;
end
///round
if(sz[22] == 1'b0)begin
//round down
end else if(sz[22] == 1'b1 && (|sz[21:0])) begin
//round up
sz = sz + {{24{1'b0}},1'b1,{23{1'b0}}};
end else begin
///to even
if(sz[22] == 1'b1)
sz = sz + {{24{1'b0}},1'b1,{23{1'b0}}};
end
if(sz[47])begin
sz = sz>>1;
ze = ze+1;
end
if(ze >= 128) begin
//inf
inf = 1;
ze = 128;
end
if(ze < -126) begin
//den
den=1;
sz = sz>>(-126-ze);
ze=-127;
end
sgnz = sgna^sgnb;
ze = ze + 127;
if(sz==0)
ze=0;
if(inf) mul32 = {sgnz,ze[7:0],{23{1'b0}}};
else mul32 = {sgnz,ze[7:0],sz[45:23]};
//end
end
endfunction
  

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
                
                
           // end             
        


  
          // reg [31:0] produs;
          produs=inmultire(x, x1p25f);
          x=produs;
          // inmultire instanta(.a(x_i), .b(x1p25f), .mul32(x));
    
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
            //end

            /* reduce x into [sqrt(2)/2, sqrt(2)] */
            ix=ix + 32'h3f800000 - 32'h3f3504f3;
            k =k  + (ix >> 23) - 32'h7f;
            ix = (ix & 32'h007fffff) + 32'h3f3504f3;
            ui = ix;
            x = ui;

            //f = x - 32'h3F800000; //x-1
            f=x + 32'hbf800000;
            s = f / (2.0 + f);
            //z = s * s;
            z=mul32(s, s);
            //w = z * z;
            w=mul32(z, z);
            t1 = mul32(w, (32'h3eccce13+ mul32(w, 32'h3e789e26)));
            t2 = mul32(z, (32'h3f2aaaaa +mul32(w, 32'h3e91e9ee)));
            r = t2 + t1;
            //hfsq = 0.5 * f * f;
            hfsq=mul32(0.5, f);
            hfsq=mul32(hfsq, f);

            hi = f - hfsq;
            ui = hi;
            ui =ui & 32'hfffff000;
            hi = ui;
            lo = f - hi - hfsq + mul32(s, (hfsq + r));
            log = mul32((lo + hi), 32'hb9389ad4) + mul32(lo, 32'h3fb8b000) + mul32(hi, 32'h3fb8b000) + k;
           
           //log_output=log;
           
         end 
endmodule
        
//```

//[GitHub - SandaMura/Proiect_FPU_OC at Branch_sapt7](https://github.com/SandaMura/Proiect_FPU_OC/tree/Branch_sapt7)