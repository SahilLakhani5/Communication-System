module My_circuit(write_ready, address, data_in, address_out);
input write_ready;
input [15:0] address;
input [15:0] data_in;

output reg [15:0] address_out;

reg [2:0] counter=3'd0;
wire signed [23:0] rom_correct;

assign rom_correct={data_in, 8'd0};

always@(posedge write_ready)begin
    if(counter<3'd5)begin
    counter=counter+3'd1;
	 address_out=address;
    end else begin
        counter=3'd0;
        address_out=address_out+16'b1;
    end
end

endmodule
