`timescale 1ns / 1ps

`define FREQ        10
`define BAUDRATE    19200

module tb_baudrate_gen();

//---signals/variables
reg     RESET;
reg     CLK;
//wire    [31:0] counter; // para visualizar el calor del contador en el diagrama de señales
wire    clk;
wire    reset;

//---assigns
assign clk      = CLK;
assign reset    = RESET;

//---instance 
baudrate_gen
#(
    .FREQ(`FREQ),
    .BAUDRATE(`BAUDRATE)
)
u_baudrate_gen
(
    .i_reset(RESET),
    .i_clk(CLK)
);

//---test body
initial
    begin   
        RESET   = 1'b1;
        CLK     = 1'b0;
        
#100
        RESET   = 1'b0;       
        
        
        
        
    end
    
always #5 CLK = ~CLK;    



endmodule
