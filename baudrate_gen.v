`timescale 1ns / 1ps

module baudrate_gen
#(
    parameter FREQ                  = 10,   // [MegaHertz]
    parameter BAUDRATE              = 19200  // BR
 )
 
 (
    //---inputs 
    input i_clk,
    input i_reset,
    
    //---outputs
    output o_tick
    
 );
 
 //---signals/variables
 localparam        SAMP_SIG = FREQ*10**6/(16*BAUDRATE);     //calculo FREQ/16*BR
 reg [clog2(SAMP_SIG)-1:0]        count;
 reg               tick;
 
 
 //---assigns
 assign o_tick=tick;
 
 
 //---body
 always @(posedge i_clk, posedge i_reset)
     if (i_reset)
        begin
            count <= 0;
            tick  <= 0; 
        end
     
     else if (count < SAMP_SIG)
        begin    
            count = count +1;
            tick <= 0;
        end        
     else
        begin
            tick <= 1;              
            count <= 0;
        end

//devuleve el log base 2 del argumento        
function integer clog2;
      input integer   depth;
      for (clog2=0; depth>0; clog2=clog2+1)
        depth = depth >> 1;
   endfunction // clog2        
        
endmodule
