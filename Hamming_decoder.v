module Hamming_decoder(data_in, ham_out);

input [6:0] data_in;
output [3:0] ham_out;
reg [3:0] ham_out;

wire c1,c2,c4;

//The data_in position:
// p1, p2, x3, p4, x2, x1, x0
//  6,  5,  4,  3,  2,  1,  0

//The ham_out position
//x3, x2, x1, x0
//4,  2,  1,  0

//c1=p1^x3^x2^x0 which is 6^4^2^0
//c2=p2^x3^x1^x0 which is 5^4^1^0
//c4=p4^x2^x1^X0 which is 3^2^1^0

assign c1=data_in[6]^data_in[4]^data_in[2]^data_in[0];
assign c2=data_in[5]^data_in[4]^data_in[1]^data_in[0];
assign c4=data_in[3]^data_in[2]^data_in[1]^data_in[0];

// 1, 2, 3, 4, 5, 6, 7
//ham_out = {3,5,6,7}
//There is two situations abotu ham_out

//One situation:
//when {c1,c2,c4} = 3'b011 which means error happen in position 3
//That means x3 is wrong, and we need to revise the bit and output them

always@(*)begin
    case({c1,c2,c4})
    3'b011:ham_out={~data_in[4], data_in[2], data_in[1], data_in[0]};
    3'b101:ham_out={data_in[4], ~data_in[2], data_in[1], data_in[0]};
    3'b110:ham_out={data_in[4], data_in[2], ~data_in[1], data_in[0]};
    3'b111:ham_out={data_in[4], data_in[2], data_in[1], ~data_in[0]};
    default:ham_out={data_in[4], data_in[2], data_in[1], data_in[0]};
    endcase
end

endmodule

