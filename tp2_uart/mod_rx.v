`timescale 1ns / 1ps

module mod_rx
#(//---params
    parameter NB_DATA = 8 //tamaño del dato a recibir
)
(//---I/O
    input i_reset,
    input i_rx,
    input i_tick,
    
    output wire [NB_DATA-1:0] o_data,
    output wire o_ready,
    output wire [4:0] o_tick_count, //lo usamos para ver como esta el contador en determinado instante
    output wire [1:0] o_state,
    output wire [1:0] o_next_state
);

//---variables/assignments
localparam idle  = 2'b00;
localparam start = 2'b01;
localparam recv  = 2'b10;
localparam stop  = 2'b11;
reg [1:0] state;
reg [1:0] next_state;
reg [NB_DATA-1:0] shift_register;
reg [NB_DATA-1:0] data;
reg ready;
reg [3:0] data_pos;
reg [4:0] tick_count;


assign o_tick_count     = tick_count;
assign o_state          = state;
assign o_next_state     = next_state;
assign o_ready          = ready;
assign o_data           = data;

//-----------------------------------------------------------
//---body
//-----------------------------------------------------------

always @(posedge i_tick)
begin
    if(i_reset)
        begin
            state = 2'b00;
            next_state <= 2'b00;
            tick_count <= 5'b00000;
            shift_register <= {NB_DATA{1'b0}};
            data_pos <= {4'b0000};
            ready <= 1'b0;
        end
       
    else
        begin
            //state = next_state;
            tick_count = tick_count+1;
        end
        
end
   

//---next_state logic
always @(*)
case(state)
    idle: 
        begin
            if(i_rx == 1'b0)
                begin
                    next_state <= start; //si llega el bit de start (cero) pasa al siguente estado
                    tick_count <= 7; //setea el contador en 7 para que desborde a los 8 ticks en el siguiente estado
                end
            else
                next_state <= idle; //queda donde esta
                //tick_count <= 0;        
        end
       
    start:
        begin
            if(tick_count[4] ==1)
                begin
                    next_state <=recv;
                    tick_count <= 0;
                    //data_pos <= 0;
                end
            else
                next_state <=state;
                //tick_count <= tick_count;
                //data_pos <= 0;    
        end // start
            
            
            
            
            
    recv: 
        begin
           if(tick_count[4] == 1'b1 )
                begin
                    if(data_pos == NB_DATA-1)
                        begin
                            tick_count <= 0;
                            next_state <= stop;
                            shift_register = {i_rx, shift_register[NB_DATA-1:1]};
                            data_pos <=0;
                            //ready <= 0;
                        end
                     else
                        tick_count <= 0;
                        next_state <= recv;
                        shift_register = {i_rx, shift_register[NB_DATA-1:1]};
                        data_pos <= data_pos+1;
                        //ready <= 0;
                
           end
        end //recv

    
    stop:
        begin
            if (tick_count[4] == 1'b1)
                begin
                    if( i_rx == 1'b1)
                    begin
                        next_state <= idle;
                        shift_register<= shift_register;
                        ready <= 1;
                    end
                    else
                        next_state <= stop;
                        shift_register<= shift_register;
                        ready <= 0;
                end
            else 
                next_state <= stop;
                data<= shift_register;
                ready <= 0;
        end

    default: next_state = idle;
endcase


endmodule
