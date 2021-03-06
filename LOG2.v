   
   ///coeficientii din seria Taylor
   
   //intregul numar este reprezentat pe 32 de biti
   
   `define ln2 44'b001111110011000101110010000101111
`define minus1 44'hbf800000
`define one    44'h3f800000
`define neg    44'h80000000
`define np5    44'h3f000000
`define one3   44'h3eaaaaab
`define one4   44'h3e800000
`define one5   44'h3e4ccccd
`define one6   44'h3e2aaaab
`define one7   44'h3e124925
`define one8   44'h3e000000
`define one9   44'h3de38e39
`define one10  44'h3dcccccd
       
module LOG2 (input [31:0]x, output reg [31:0]rez);
  
 // input [31:0]x;
  //output reg [31:0]rez;
  
  reg sgna;
  integer exa,i;///poate retine si denormalizate
  reg [22:0]mana;
  reg a_n;  //este a normalizat?
  reg [23:0]sa;//significand(cu tot cu hidden bit)
  
  reg [31:0]y;
  
  reg inf,den;
  reg snan;
  reg [31:0]rez_ln;
  
  
  reg [31:0] exp_ln2,m,m_1,f,mp2,mp3,mp4,mp5,mp6,mp7,mp8,mp9;
  
  localparam  [511:0]one_sim1 = { //one_sim1 este declarat pe cati biti am nevoie : 32 * 16
  32'b0011111101111000001111100000111,   // 1/ 
  32'b0011111101101010000011101010000,
  32'b0011111101011101011001111100100,
  32'b0011111101010010000011010010000,
  32'b0011111101000111110011100000110,
  32'b0011111100111110100000101111101,
  32'b0011111100110110000010110110000,
  32'b0011111100101110010011000100001,
  
  32'b0011111100100111001011110000011,
  32'b0011111100100000101000001010000,
  32'b0011111100011010100100001110011,
  32'b0011111100010100111100100000100,
  32'b0011111100001111101110000010001,
  32'b0011111100001010110110001111001,
  32'b0011111100000110010010111000101,
  32'b0011111100000010000010000010000};
  
  localparam  [511:0] ln_sim1 = {
  32'b0011110011111100000101001101100,
  32'b0011110110110111100001101001010,
  32'b0011111000010100101010101001011,
  32'b0011111001001010100100101101010,
  32'b0011111001111101110010001100001,
  32'b0011111010010111010001110001010,
  32'b0011111010101110100011011110110,
  32'b0011111011000100110100011001110,
  
  32'b0011111011011010001001111011101,
  32'b0011111011101110101000110101000,
  32'b0011111100000001001010101001011,
  32'b0011111100001010101001100001111,
  32'b0011111100010011110010101111000,
  32'b0011111100011100100111110000011,
  32'b0011111100100101001001111100001,
  32'b0011111100101101011010100000001};
  
  
  ///functia de inmultire         
function [31:0]mul;
                 
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
if(inf) mul = {sgnz,ze[7:0],{23{1'b0}}};
else mul = {sgnz,ze[7:0],sz[45:23]};
//end
end
endfunction


///functia de adunare
function [31:0]add;

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
if(inf) add= {sgnz,ze[7:0],{23{1'b0}}};
else add= {sgnz,ze[7:0],sz[22:0]};
if(snan)
add = 31'h7f800001;
end

endfunction



  always @(*) begin
    sgna = x[31];
    mana = x[22:0];
    a_n = |(x[30:23]);
    exa = x[30:23];
    exa = exa - 127;
    sa = {a_n,mana};
    
    if(a_n == 0) begin
      exa = exa + 1;
      casex(sa)   //pentru normalizare
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
    
    
    //a este normalizat
    
    if(sa<24'b1011010100000100111100110) begin //comparat cu radical din 2
      
      m = {1'b0,8'b01111111,sa[22:0]}; //exponentul este 0 + bias pt ca este intre 1 si 2
      
      
      i = sa[22:19];  ///folosesc primele cifre de dupa virgula ca sa aleg valori din tabelul cu log gata calculat
      i = 15 - i;      //indexul din tabel
      
      m = mul(m,one_sim1[44*i +: 44]);  //tabelul one_sim1 contine inversul la fiecare val
      
      //Calculul din seria Taylor
      m_1 = add(m,`minus1);
      mp2 = mul(m_1,m_1);
      mp3 = mul(mp2,m_1);
      mp4 = mul(mp3,m_1);
      mp5 = mul(mp4,m_1);
      mp6 = mul(mp5,m_1);
      mp7 = mul(mp6,m_1);
      mp8 = mul(mp7,m_1);
      mp9 = mul(mp8,m_1);
      
      //calculez f
      f = add(  `one,   `neg^(mul(`np5,m_1))    );
      f = add(f,  mul(`one3,mp2));
      f = add(f,  `neg^mul(`one4,mp3));
      f = add(f,  mul(`one5,mp4));
      f = add(f,  `neg^mul(`one6,mp5));
      f = add(f,  mul(`one7,mp6));
      f = add(f,  `neg^mul(`one8,mp7));
      f = add(f,  mul(`one9,mp8));
      f = add(f,  `neg^mul(`one10,mp9));
      
      
      
      y = mul(m_1,f);   //inmultesc cu (M-1) dupa seria Taylor
      y = add(y,ln_sim1[32*i +: 32]);  //adun logaritmul gata calculat din tabel //de la 32i pana la 32(i+1)
      exp_ln2 = mul(`ln2,$bitstoreal(exa)); //inmultesc cu 1/ln2
      rez = add(exp_ln2,y);
      if(sa==0)
        rez=32'hff800000;
      
      /*$display("m=%h",m);
      $display("m-1=%h",m_1);
      $display("f=%h",f);
      $display("`neg^mul(`np5,m_1)=%h",`neg^mul(`np5,m_1));
      
      $display("y=%h",y);
      $display("eln2=%h",exp_ln2);
      $display("rez=%h",rez);*/
    end else begin
      
      m = {1'b0,8'b01111110,sa[22:0]}; //am impartit m la 2, deci exponentul este cu 1 mai mic
      //$display("m=%h",m);
      
      
      i = sa[22:19];
      i = 15 - i;
      
      m = mul(m,44'h00800000000|one_sim1[44*i +: 44]);//impart la 2 one_sim1
      //$display("m=%h",m);
      
      m_1 = add(m,`minus1);
      mp2 = mul(m_1,m_1);
      mp3 = mul(mp2,m_1);
      mp4 = mul(mp3,m_1);
      mp5 = mul(mp4,m_1);
      mp6 = mul(mp5,m_1);
      mp7 = mul(mp6,m_1);
      mp8 = mul(mp7,m_1);
      mp9 = mul(mp8,m_1);
      
      //calculez f
      f = add(  `one,   `neg^(mul(`np5,m_1))    );
      f = add(f,  mul(`one3,mp2));
      f = add(f,  `neg^mul(`one4,mp3));
      f = add(f,  mul(`one5,mp4));
      f = add(f,  `neg^mul(`one6,mp5));
      f = add(f,  mul(`one7,mp6));
      f = add(f,  `neg^mul(`one8,mp7));
      f = add(f,  mul(`one9,mp8));
      //$display("%h",f);
      f = add(f,  `neg^mul(`one10,mp9));
      //$display("%h",f);
      
      
      y = mul(m_1,f);
      
      y = add(y,ln_sim1[32*i +: 32]);///adun ln(sim/2) = ln(sim)-ln 2
      y = add(y,`neg^`ln2);
      
      exp_ln2 = mul(`ln2,i2f(exa+1));
      rez = add(exp_ln2,y);
      if(sa==0)
        rez=32'hff800000;
      
      
    end //if
    
    // 1/ln(2) = 1.44269504089= 0x3fb8aa3b = 00111111101110001010101000111011
   ///apoi trebuie sa impart rezultatul cu 10^(-38)

   //rez=mul(mul(rez_ln, 32'h3fb8aa3b), e-38);
   rez=mul(mul(rez_ln, 32'h3fb8aa3b), 32'h006ce3ee);
  
  end//always

  
  
  
endmodule
  
  
        
        
        