`timescale 1ns / 1ps

`define NB_DATA     8
`define FREQ        10
`define BAUDRATE    192000

module tb_mod_rx(

    );
    
//---signals/variables
reg Tb_Clk;
reg Tb_Data;
reg Tb_Reset;
    
wire tb_clk;
wire tb_data;  
wire tb_reset;
wire tb_tick_wire;

assign tb_clk = Tb_Clk;
assign tb_data = Tb_Data;
assign tb_reset = Tb_Reset;

//--------------------------------------------    
//---instancias mod_rx, baudrate_gen
//--------------------------------------------
mod_rx
#(
    .NB_DATA(`NB_DATA)
)
u_mod_rx
(   
    .i_reset(tb_reset),
    .i_rx(tb_data),
    .i_tick(tb_tick_wire)
);

baudrate_gen
//parameter FREQ                  = 10,   // [MegaHertz]
//parameter BAUDRATE              = 19200  // BR
#(
    .FREQ(`FREQ),
    .BAUDRATE(`BAUDRATE)
)
u_baudrate_gen
(
    .i_clk(tb_clk),//input i_clk,
    .i_reset(tb_reset),//input i_reset,
    
    //output o_tick
    .o_tick(tb_tick_wire)
);

//--------------------------------------------
//---test body
//--------------------------------------------

initial
    begin
        Tb_Clk = 1'b0;
        Tb_Data = 1'b1;
        Tb_Reset = 1'b1;
        
        #100
        Tb_Reset = 1'b0;
        
        #40
        Tb_Data = 1'b0;
        
        
        #10000
        $finish();
            
    end
    
always #5 Tb_Clk = ~ Tb_Clk;  //equivale a una frecuencia de 100 MHz,  T=10 ns
    
endmodule
