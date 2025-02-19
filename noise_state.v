`define Sa 1'b0
//Sa state is the good_channel state

`define Sb 1'b1
//Sb state is the bad_channel state

module noise_state(clk, reset, data_in, rand_int, data_out);
input clk,reset;
input [15:0] data_in;
input [7:0] rand_int;
output [15:0] data_out;
reg [22:0] dataout;


wire present_state, state_next_reset;
reg state_next;
assign state_next_reset=reset?state_next:`Sa;

vDFFe #(1) U1(.clk(clk), .in(state_next), .out(present_state));
//The D flip flop

//We use the matlab to measure the power for input and output
//The purpose for that is to find the coefficient of a between input and output
//The equation:

// (a^2)*(power_in) = (power_out)

//For Good channel:
// power_in=0.2489
// power_out=0.2567
// a=sqrt(0.2567/0.2489)=1.015548

//For Bad channel:
// power_in=0.2489
// power_out=0.3742
// a=sqrt(0.3742/0.2489)=1.226138

always@(*)begin
    case(present_state)
    `Sa:{state_next, dataout}={((rand_int<=8'b00000010)?`Sb:`Sa), data_in*7'b1_000001};
    //when rand_int <= 2, we move to the bad_channel state
    //otherwise we stay in the good_channel

    `Sb:{state_next, dataout}={((rand_int<=8'b00011000)?`Sa:`Sb), data_in*7'b1_001110};
    //when rand_int <= 24, we move to the good_channel state
    //otherwise we stay in the bad_channel

    default:{state_next, dataout}={17{1'bx}};
    //avoid the missed situation and inferred latch

    endcase
end

assign data_out=dataout[22:7];

endmodule









