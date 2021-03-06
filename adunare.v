
module add_fl_22(a, b, sum);
input [31:0]a,b;
output reg [31:0]sum;
///1-sgn, 8-exp, 35-man
reg sgna;
reg sgnb;
reg [7:0]exa;
reg [7:0]exb;
wire [22:0]mana = a[22:0];
wire [22:0]manb = b[22:0];
wire a_n = |(a[30:23]); //este a normalizat?
wire b_n = |(b[30:23]);
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
always @(*) begin
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
25'b00000000000000000000000000: begin R = 0;S = 0;sz = sz<<23; ze = ze-24; end

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
if(inf) sum = {sgnz,ze[7:0],{23{1'b0}}};
else sum = {sgnz,ze[7:0],sz[22:0]};
if(snan)
sum = 31'h7f800001;
end
endmodule

