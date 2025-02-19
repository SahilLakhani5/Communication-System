module Hamming_encoder(data_in, ham_out);

    input [3:0] data_in;
    output [6:0] ham_out;

    // The code position is 
    // p1, p2, x3, p4, x2, x1, x0

    // The data position:
    // x3,         x2,         x1,         x0
    // data_in[3], data_in[2], data_in[1], data_in[0]

    // p1=x3^x2^x0 which is data_in[3]^data_in[2]^data_in[0]
    // p2=x3^x1^x0 which is data_in[3]^data_in[1]^data_in[0]
    // p4=x2^x1^x0 which is data_in[2]^data_in[1]^data_in[0]

    // ham_out is:
    // p1, p2, x3,         p4, x2,         x1,         x0
    // p1, p2, data_in[3], p4, data_in[2], data_in[1], data_in[0]
  
    wire p1,p2,p4;
    
    assign p1 = data_in[3] ^ data_in[2] ^ data_in[0];
    assign p2 = data_in[3] ^ data_in[1] ^ data_in[0];
    assign p4 = data_in[2] ^ data_in[1] ^ data_in[0];
    
    assign ham_out = {p1, p2, data_in[3], p4, data_in[2], data_in[1], data_in[0]};
endmodule





