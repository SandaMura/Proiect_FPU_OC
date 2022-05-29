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

          
module log_operation (input [31:0]x_i, output reg [31:0]log_output);
        
          
        //  uint IVLN2HI_U32;
          `define IVLN2HI_U32 32'h3fb8b000 // 1.4428710938e+00 // log e
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
            reg gata;
            real aux;
            real aux_s;
            
            
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
            //$display ("%d", ze); 
            //cazuri 01.xx 1x.xx
            if(sz[47])begin
              
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
            
            
///functia de adunare
function [31:0]add_sum;

input [31:0]a,b;
//output reg [31:0]sum;

///1-sgn, 8-exp, 23-man
reg sgna;
reg sgnb;
reg [7:0]exa;
reg [7:0]exb;
reg [22:0]mana;
reg [22:0]manb;
reg a_n; //este a normalizat?
reg b_n;
reg [23:0]sa;//significand(cu tot cu hidden bit)
reg [23:0]sb;
integer ze;///daca e caz de overflow sa se retina
reg [24:0]sz;///pe 37 de biti pentru cout
reg sgnz;
reg g,r,s;
reg R,S;
reg inf,den;
reg snan;
reg s2sw,s3cm,s5cm;
integer d;
//always @(*)

begin
  
  //always @(*) begin
mana = a[22:0];
manb = b[22:0];
a_n = |(a[30:23]); //daca toti bitii exponentului sunt zero => denormalizat
b_n = |(b[30:23]);

exa = a[30:23];
exb = b[30:23];
///daca e denormalizat !!!!!!!!
if((|exa)==0) exa = exa+1;
if((|exb)==0) exb = exb+1;
sa = {a_n,mana};//significand(cu tot cu hidden bit)
sb = {b_n,manb};
sgna = a[31];
sgnb = b[31];
s2sw=0;
s3cm=0;
s5cm=0;
inf=0; den=0;
snan=0;
ze = exa;
$display("a_n=%b b_n=%b",a_n,b_n);
$display("exa: %b, exb: %b",exa, exb);
if(exa<exb) begin
//swap
///$display("kgvc");
ze = exb;
exa = b[31:23];
exb = a[31:23];

 
if((|exa)==0) exa = exa+1;
if((|exb)==0) exb = exb+1;
  
$display("exa: %b, exb: %b",exa, exb); 

sa = {b_n,manb};//significand(cu tot cu hidden bit)
sb = {a_n,mana};
sgna = b[31];
sgnb = a[31];
s2sw = 1;
end
$display("sa=%b\nsb=%b\n",sa,sb);
ze = ze - 127;
d = exa - exb;
//$display("\n%d",d);
if(sgna != sgnb)begin
sb = ~sb+1;
s3cm = 1;
end
///step 4
{sb,g,r,s} = {sb,g,r,s}>>d;
if(s3cm) begin
sb = sb | ({24{1'b1}}<<(24-d));
if(d>=36)
sb = {36{1'b1}};
end
///step 5
$display("inainte de adunarea din pas 5:\nsa=%b\nsb=%b",sa,sb);
sz = sa + sb;
$display("dupa adunarea din pas 5\nsz=%b",sz);
if(sgna != sgnb) begin
if(sz[24]) begin sz[24] = 1'b0; end
else begin sz = ~sz + 1; sz[24] = 1'b0; s5cm = 1;
            $display("dupa ultimul else din pas5: %d", sz); end
end

///step 6
///36 35. 34 33 ..... 0
///NU fac overflow
if(sz[24]) begin //daca e generat cout il pastrez pt ca semnele suunt egale
R = sz[0];
S = g|r|s;
sz = sz>>1;
sz[24]=0;
ze = ze+1;
$display ("exponent z dupa ze+1 step6(sz[24]=1): %b", ze);
$display ("signif z dupa ze+1 step6(sz[24]=1): %b", sz);
end 
 else if(sz[23]) begin
R = g;
S = r|s;
$display ("exponent z dupa ze+1 step6: %b", ze);
end else if(sz==25'b0 && g==1'b0) begin
R = 0;S = 0;sz = 0; ze = 0;
end else begin
$display("ze before case=%b",ze);
casex(sz)
25'b001??????????????????????: begin R = r;S = s;sz = sz<<1;sz[0]=g;ze = ze-1; end
25'b0001?????????????????????: begin R = 0;S = 0;sz = sz<<2; ze = ze-2; end
25'b00001????????????????????: begin R = 0;S = 0;sz = sz<<3; ze = ze-3; end
25'b000001???????????????????: begin R = 0;S = 0;sz = sz<<4; ze = ze-4; end
25'b0000001??????????????????: begin R = 0;S = 0;sz = sz<<5; ze = ze-5; end
25'b00000001?????????????????: begin R = 0;S = 0;sz = sz<<6; ze = ze-6; end
25'b000000001????????????????: begin R = 0;S = 0;sz = sz<<7; ze = ze-7; end
25'b0000000001???????????????: begin R = 0;S = 0;sz = sz<<8; ze = ze-8; end
25'b00000000001??????????????: begin R = 0;S = 0;sz = sz<<9; ze = ze-9; end
25'b000000000001?????????????: begin R = 0;S = 0;sz = sz<<10; ze = ze-10; end
25'b0000000000001????????????: begin R = 0;S = 0;sz = sz<<11; ze = ze-11; end
25'b00000000000001???????????: begin R = 0;S = 0;sz = sz<<12; ze = ze-12; end
25'b000000000000001??????????: begin R = 0;S = 0;sz = sz<<13; ze = ze-13; end
25'b0000000000000001?????????: begin R = 0;S = 0;sz = sz<<14; ze = ze-14; end
25'b00000000000000001????????: begin R = 0;S = 0;sz = sz<<15; ze = ze-15; end
25'b000000000000000001???????: begin R = 0;S = 0;sz = sz<<16; ze = ze-16; end
25'b0000000000000000001??????: begin R = 0;S = 0;sz = sz<<17; ze = ze-17; end
25'b00000000000000000001?????: begin R = 0;S = 0;sz = sz<<18; ze = ze-18; end
25'b000000000000000000001????: begin R = 0;S = 0;sz = sz<<19; ze = ze-19; end
25'b0000000000000000000001???: begin R = 0;S = 0;sz = sz<<20; ze = ze-20; end
25'b00000000000000000000001??: begin R = 0;S = 0;sz = sz<<21; ze = ze-21; end
25'b000000000000000000000001?: begin R = 0;S = 0;sz = sz<<22; ze = ze-22; end
25'b0000000000000000000000001: begin R = 0;S = 0;sz = sz<<23; ze = ze-23; end
25'b0000000000000000000000000: begin R = 0;S = 0;sz = sz<<23; ze = ze-24; end

endcase
$display ("exponent z dupa case: %b", ze);
$display("signifigantul z dupa case: %b",sz);
end
//$display("ze=%d",ze);
if(ze>=128) begin
inf=1;
ze=127;
end
if(ze<-126) begin
///denormalized
den=1;
sz = sz>>(-126-ze);
ze=-127;
end
$display("dupa normalizare: %b",sz);
//step 8
if(R & (S | sz[0])) sz = sz+1;
if(sz[24]) begin
sz = sz>>1;
ze = ze+1;
$display ("exponent z dupa ze+1 step 8: %b", ze);
end
if(ze>=128) begin
inf=1;
ze=127;
end
//$display("%b",sz);
///step 9
if(s2sw) begin
sgnz = b[31];
end else begin
if(s5cm) begin
sgnz = b[31];
end else begin
sgnz = a[31];
end
end
ze = ze + 127;
//$display("%d",ze);
if(sz==0)
ze=0;
snan = ((&a[30:23]) && (|a[22:0])) || ((&b[30:23]) && (|b[22:0]));
///step 10
$display("exponent z in pas 10: %b",ze);
$display("signifigantul z in pas 10: %b",sz);
if(inf) add_sum = {sgnz,ze[7:0],{23{1'b0}}};
else add_sum = {sgnz,ze[7:0],sz[22:0]};
if(snan)
add_sum = 31'h7f800001;
end

endfunction

{///functia de adunare
function [31:0]add_sum;

input [31:0]a,b;
//output reg [31:0]sum;

///1-sgn, 8-exp, 23-man
reg sgna;
reg sgnb;
reg [7:0]exa;
reg [7:0]exb;
reg [22:0]mana;
reg [22:0]manb;
reg a_n; //este a normalizat?
reg b_n;
reg [23:0]sa;//significand(cu tot cu hidden bit)
reg [23:0]sb;
integer ze;///daca e caz de overflow sa se retina
reg [24:0]sz;///pe 37 de biti pentru cout
reg sgnz;
reg g,r,s;
reg R,S;
reg inf,den;
reg snan;
reg s2sw,s3cm,s5cm;
integer d;
//always @(*)

begin
  
  //always @(*) begin
mana = a[22:0];
manb = b[22:0];
a_n = |(a[30:23]); //daca toti bitii exponentului sunt zero => denormalizat
b_n = |(b[30:23]);

exa = a[30:23];
exb = b[30:23];
///daca e denormalizat !!!!!!!!
if((|exa)==0) exa = exa+1;
if((|exb)==0) exb = exb+1;
sa = {a_n,mana};//significand(cu tot cu hidden bit)
sb = {b_n,manb};
sgna = a[31];
sgnb = b[31];
s2sw=0;
s3cm=0;
s5cm=0;
inf=0; den=0;
snan=0;
ze = exa;
$display("a_n=%b b_n=%b",a_n,b_n);
$display("exa: %b, exb: %b",exa, exb);
if(exa<exb) begin
//swap
///$display("kgvc");
ze = exb;
exa = b[31:23];
exb = a[31:23];

 
if((|exa)==0) exa = exa+1;
if((|exb)==0) exb = exb+1;
  
$display("exa: %b, exb: %b",exa, exb); 

sa = {b_n,manb};//significand(cu tot cu hidden bit)
sb = {a_n,mana};
sgna = b[31];
sgnb = a[31];
s2sw = 1;
end
$display("sa=%b\nsb=%b\n",sa,sb);
ze = ze - 127;
d = exa - exb;
//$display("\n%d",d);
if(sgna != sgnb)begin
sb = ~sb+1;
s3cm = 1;
end
///step 4
{sb,g,r,s} = {sb,g,r,s}>>d;
if(s3cm) begin
sb = sb | ({24{1'b1}}<<(24-d));
if(d>=36)
sb = {36{1'b1}};
end
///step 5
$display("inainte de adunarea din pas 5:\nsa=%b\nsb=%b",sa,sb);
sz = sa + sb;
$display("dupa adunarea din pas 5\nsz=%b",sz);
if(sgna != sgnb) begin
if(sz[24]) begin sz[24] = 1'b0; end
else begin sz = ~sz + 1; sz[24] = 1'b0; s5cm = 1;
            $display("dupa ultimul else din pas5: %d", sz); end
end

///step 6
///36 35. 34 33 ..... 0
///NU fac overflow
if(sz[24]) begin //daca e generat cout il pastrez pt ca semnele suunt egale
R = sz[0];
S = g|r|s;
sz = sz>>1;
sz[24]=0;
ze = ze+1;
$display ("exponent z dupa ze+1 step6(sz[24]=1): %b", ze);
$display ("signif z dupa ze+1 step6(sz[24]=1): %b", sz);
end 
 else if(sz[23]) begin
R = g;
S = r|s;
$display ("exponent z dupa ze+1 step6: %b", ze);
end else if(sz==25'b0 && g==1'b0) begin
R = 0;S = 0;sz = 0; ze = 0;
end else begin
$display("ze before case=%b",ze);
casex(sz)
25'b001??????????????????????: begin R = r;S = s;sz = sz<<1;sz[0]=g;ze = ze-1; end
25'b0001?????????????????????: begin R = 0;S = 0;sz = sz<<2; ze = ze-2; end
25'b00001????????????????????: begin R = 0;S = 0;sz = sz<<3; ze = ze-3; end
25'b000001???????????????????: begin R = 0;S = 0;sz = sz<<4; ze = ze-4; end
25'b0000001??????????????????: begin R = 0;S = 0;sz = sz<<5; ze = ze-5; end
25'b00000001?????????????????: begin R = 0;S = 0;sz = sz<<6; ze = ze-6; end
25'b000000001????????????????: begin R = 0;S = 0;sz = sz<<7; ze = ze-7; end
25'b0000000001???????????????: begin R = 0;S = 0;sz = sz<<8; ze = ze-8; end
25'b00000000001??????????????: begin R = 0;S = 0;sz = sz<<9; ze = ze-9; end
25'b000000000001?????????????: begin R = 0;S = 0;sz = sz<<10; ze = ze-10; end
25'b0000000000001????????????: begin R = 0;S = 0;sz = sz<<11; ze = ze-11; end
25'b00000000000001???????????: begin R = 0;S = 0;sz = sz<<12; ze = ze-12; end
25'b000000000000001??????????: begin R = 0;S = 0;sz = sz<<13; ze = ze-13; end
25'b0000000000000001?????????: begin R = 0;S = 0;sz = sz<<14; ze = ze-14; end
25'b00000000000000001????????: begin R = 0;S = 0;sz = sz<<15; ze = ze-15; end
25'b000000000000000001???????: begin R = 0;S = 0;sz = sz<<16; ze = ze-16; end
25'b0000000000000000001??????: begin R = 0;S = 0;sz = sz<<17; ze = ze-17; end
25'b00000000000000000001?????: begin R = 0;S = 0;sz = sz<<18; ze = ze-18; end
25'b000000000000000000001????: begin R = 0;S = 0;sz = sz<<19; ze = ze-19; end
25'b0000000000000000000001???: begin R = 0;S = 0;sz = sz<<20; ze = ze-20; end
25'b00000000000000000000001??: begin R = 0;S = 0;sz = sz<<21; ze = ze-21; end
25'b000000000000000000000001?: begin R = 0;S = 0;sz = sz<<22; ze = ze-22; end
25'b0000000000000000000000001: begin R = 0;S = 0;sz = sz<<23; ze = ze-23; end
25'b0000000000000000000000000: begin R = 0;S = 0;sz = sz<<23; ze = ze-24; end

endcase
$display ("exponent z dupa case: %b", ze);
$display("signifigantul z dupa case: %b",sz);
end
//$display("ze=%d",ze);
if(ze>=128) begin
inf=1;
ze=127;
end
if(ze<-126) begin
///denormalized
den=1;
sz = sz>>(-126-ze);
ze=-127;
end
$display("dupa normalizare: %b",sz);
//step 8
if(R & (S | sz[0])) sz = sz+1;
if(sz[24]) begin
sz = sz>>1;
ze = ze+1;
$display ("exponent z dupa ze+1 step 8: %b", ze);
end
if(ze>=128) begin
inf=1;
ze=127;
end
//$display("%b",sz);
///step 9
if(s2sw) begin
sgnz = b[31];
end else begin
if(s5cm) begin
sgnz = b[31];
end else begin
sgnz = a[31];
end
end
ze = ze + 127;
//$display("%d",ze);
if(sz==0)
ze=0;
snan = ((&a[30:23]) && (|a[22:0])) || ((&b[30:23]) && (|b[22:0]));
///step 10
$display("exponent z in pas 10: %b",ze);
$display("signifigantul z in pas 10: %b",sz);
if(inf) add_sum = {sgnz,ze[7:0],{23{1'b0}}};
else add_sum = {sgnz,ze[7:0],sz[22:0]};
if(snan)
add_sum = 31'h7f800001;
end

endfunction


}




///functia de adunare
function [31:0]add_sum;

input [31:0]a,b;
//output reg [31:0]sum;

///1-sgn, 8-exp, 23-man
reg sgna;
reg sgnb;
reg [7:0]exa;
reg [7:0]exb;
reg [22:0]mana;
reg [22:0]manb;
reg a_n; //este a normalizat?
reg b_n;
reg [23:0]sa;//significand(cu tot cu hidden bit)
reg [23:0]sb;
integer ze;///daca e caz de overflow sa se retina
reg [24:0]sz;///pe 37 de biti pentru cout
reg sgnz;
reg g,r,s;
reg R,S;
reg inf,den;
reg snan;
reg s2sw,s3cm,s5cm;
integer d;
//always @(*)

begin
  
  //always @(*) begin
mana = a[22:0];
manb = b[22:0];
a_n = |(a[30:23]); //daca toti bitii exponentului sunt zero => denormalizat
b_n = |(b[30:23]);

exa = a[30:23];
exb = b[30:23];
///daca e denormalizat !!!!!!!!
if((|exa)==0) exa = exa+1;
if((|exb)==0) exb = exb+1;
sa = {a_n,mana};//significand(cu tot cu hidden bit)
sb = {b_n,manb};
sgna = a[31];
sgnb = b[31];
s2sw=0;
s3cm=0;
s5cm=0;
inf=0; den=0;
snan=0;
ze = exa;
$display("a_n=%b b_n=%b",a_n,b_n);
$display("exa: %b, exb: %b",exa, exb);
if(exa<exb) begin
//swap
///$display("kgvc");
ze = exb;
exa = b[31:23];
exb = a[31:23];

 
if((|exa)==0) exa = exa+1;
if((|exb)==0) exb = exb+1;
  
$display("exa: %b, exb: %b",exa, exb); 

sa = {b_n,manb};//significand(cu tot cu hidden bit)
sb = {a_n,mana};
sgna = b[31];
sgnb = a[31];
s2sw = 1;
end
$display("sa=%b\nsb=%b\n",sa,sb);
ze = ze - 127;
d = exa - exb;
//$display("\n%d",d);
if(sgna != sgnb)begin
sb = ~sb+1;
s3cm = 1;
end
///step 4
{sb,g,r,s} = {sb,g,r,s}>>d;
if(s3cm) begin
sb = sb | ({24{1'b1}}<<(24-d));
if(d>=36)
sb = {36{1'b1}};
end
///step 5
$display("inainte de adunarea din pas 5:\nsa=%b\nsb=%b",sa,sb);
sz = sa + sb;
$display("dupa adunarea din pas 5\nsz=%b",sz);
if(sgna != sgnb) begin
if(sz[24]) begin sz[24] = 1'b0; end
else begin sz = ~sz + 1; sz[24] = 1'b0; s5cm = 1;
            $display("dupa ultimul else din pas5: %d", sz); end
end

///step 6
///36 35. 34 33 ..... 0
///NU fac overflow
if(sz[24]) begin //daca e generat cout il pastrez pt ca semnele suunt egale
R = sz[0];
S = g|r|s;
sz = sz>>1;
sz[24]=0;
ze = ze+1;
$display ("exponent z dupa ze+1 step6(sz[24]=1): %b", ze);
$display ("signif z dupa ze+1 step6(sz[24]=1): %b", sz);
end 
 else if(sz[23]) begin
R = g;
S = r|s;
$display ("exponent z dupa ze+1 step6: %b", ze);
end else if(sz==25'b0 && g==1'b0) begin
R = 0;S = 0;sz = 0; ze = 0;
end else begin
$display("ze before case=%b",ze);
casex(sz)
25'b001??????????????????????: begin R = r;S = s;sz = sz<<1;sz[0]=g;ze = ze-1; end
25'b0001?????????????????????: begin R = 0;S = 0;sz = sz<<2; ze = ze-2; end
25'b00001????????????????????: begin R = 0;S = 0;sz = sz<<3; ze = ze-3; end
25'b000001???????????????????: begin R = 0;S = 0;sz = sz<<4; ze = ze-4; end
25'b0000001??????????????????: begin R = 0;S = 0;sz = sz<<5; ze = ze-5; end
25'b00000001?????????????????: begin R = 0;S = 0;sz = sz<<6; ze = ze-6; end
25'b000000001????????????????: begin R = 0;S = 0;sz = sz<<7; ze = ze-7; end
25'b0000000001???????????????: begin R = 0;S = 0;sz = sz<<8; ze = ze-8; end
25'b00000000001??????????????: begin R = 0;S = 0;sz = sz<<9; ze = ze-9; end
25'b000000000001?????????????: begin R = 0;S = 0;sz = sz<<10; ze = ze-10; end
25'b0000000000001????????????: begin R = 0;S = 0;sz = sz<<11; ze = ze-11; end
25'b00000000000001???????????: begin R = 0;S = 0;sz = sz<<12; ze = ze-12; end
25'b000000000000001??????????: begin R = 0;S = 0;sz = sz<<13; ze = ze-13; end
25'b0000000000000001?????????: begin R = 0;S = 0;sz = sz<<14; ze = ze-14; end
25'b00000000000000001????????: begin R = 0;S = 0;sz = sz<<15; ze = ze-15; end
25'b000000000000000001???????: begin R = 0;S = 0;sz = sz<<16; ze = ze-16; end
25'b0000000000000000001??????: begin R = 0;S = 0;sz = sz<<17; ze = ze-17; end
25'b00000000000000000001?????: begin R = 0;S = 0;sz = sz<<18; ze = ze-18; end
25'b000000000000000000001????: begin R = 0;S = 0;sz = sz<<19; ze = ze-19; end
25'b0000000000000000000001???: begin R = 0;S = 0;sz = sz<<20; ze = ze-20; end
25'b00000000000000000000001??: begin R = 0;S = 0;sz = sz<<21; ze = ze-21; end
25'b000000000000000000000001?: begin R = 0;S = 0;sz = sz<<22; ze = ze-22; end
25'b0000000000000000000000001: begin R = 0;S = 0;sz = sz<<23; ze = ze-23; end
25'b0000000000000000000000000: begin R = 0;S = 0;sz = sz<<23; ze = ze-24; end

endcase
$display ("exponent z dupa case: %b", ze);
$display("signifigantul z dupa case: %b",sz);
end
//$display("ze=%d",ze);
if(ze>=128) begin
inf=1;
ze=127;
end
if(ze<-126) begin
///denormalized
den=1;
sz = sz>>(-126-ze);
ze=-127;
end
$display("dupa normalizare: %b",sz);
//step 8
if(R & (S | sz[0])) sz = sz+1;
if(sz[24]) begin
sz = sz>>1;
ze = ze+1;
$display ("exponent z dupa ze+1 step 8: %b", ze);
end
if(ze>=128) begin
inf=1;
ze=127;
end
//$display("%b",sz);
///step 9
if(s2sw) begin
sgnz = b[31];
end else begin
if(s5cm) begin
sgnz = b[31];
end else begin
sgnz = a[31];
end
end
ze = ze + 127;
//$display("%d",ze);
if(sz==0)
ze=0;
snan = ((&a[30:23]) && (|a[22:0])) || ((&b[30:23]) && (|b[22:0]));
///step 10
$display("exponent z in pas 10: %b",ze);
$display("signifigantul z in pas 10: %b",sz);
if(inf) add_sum = {sgnz,ze[7:0],{23{1'b0}}};
else add_sum = {sgnz,ze[7:0],sz[22:0]};
if(snan)
add_sum = 31'h7f800001;
end

endfunction






always @(*) begin
  gata=0;
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
                    gata=1; //NEGATIVE INFINITE
                end

                if ((ix >> 31) > 0)
                begin
                    //return (x - x) / 0.0; /* log(-#) = NaN */
                    log =  32'h7fffffff;
                    gata=1;  //NaN
                end

                /* subnormal number, scale up x */
                k = add_sum(k, 25);
                
                
           // end             
        


  
          // reg [31:0] produs;
          produs=mul32(x, x1p25f);
          x=produs;
          // inmultire instanta(.a(x_i), .b(x1p25f), .mul32(x));
    
              //  x = x*x1p25f;
                
                
          
                ui = x;
                ix = ui;
            end
            else if (ix >= 32'h7f800000)
             begin
               if(gata==0)begin
                log = x;
                gata=1; //NEGATIVE INFINITE
              end
             end
                 else if (ix == 32'h3f800000)
                 begin
                  if(gata==0)begin
                log = 32'h00000000; 
                gata=1;//ZERO
                   end
                 end
            //end

            /* reduce x into [sqrt(2)/2, sqrt(2)] */
            ix=add_sum(add_sum(ix, 32'h3f800000), ~32'h3f3504f3);
            k =add_sum(add_sum(k, (ix >> 23)),   ~32'h7f);
            ix = (ix & 32'h007fffff) + 32'h3f3504f3;
            ui = ix;
            x = ui;

            //f = x - 32'h3F800000; //x-1
            f=add_sum(x, 32'hbf800000);
                     
              aux=$bitstoreal(f);
                    // $bitstoreal(f);
            aux_s = aux / ((1.50463276905e-36)+aux);
            //$realtobits(s);
            //$realtobits(f);
            //z = s * s;
            s=$bitstoreal(aux_s);
            z=mul32(s, s);
            //z=s*s;
            //w = z * z;
            w=mul32(z, z);
            t1 = mul32(w, add_sum(32'h3eccce13, mul32(w, 32'h3e789e26)));
            t2 = mul32(z, add_sum(32'h3f2aaaaa, mul32(w, 32'h3e91e9ee)));
            r = add_sum(t2,t1);
            //hfsq = 0.5 * f * f;
            hfsq=mul32(0.5, f);
            hfsq=mul32(hfsq, f);

            hi = add_sum(f, ~hfsq);
            ui = hi;
            ui =ui & 32'hfffff000;
            hi = ui;
            lo = add_sum(f, ~add_sum(hi, ~add_sum(hfsq, mul32(s, add_sum(hfsq, r)))));
            if(gata==0)
              begin log =add_sum(add_sum(mul32(add_sum(lo, hi), 32'hb9389ad4), mul32(lo, 32'h3fb8b000)), add_sum(mul32(hi, 32'h3fb8b000), k)); end
           
           log_output=log;
    
         end 
endmodule
        
//```

//[GitHub - SandaMura/Proiect_FPU_OC at Branch_sapt7](https://github.com/SandaMura/Proiect_FPU_OC/tree/Branch_sapt7)