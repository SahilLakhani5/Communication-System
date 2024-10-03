
module Hamming_decoder_tb();
reg err;
reg [6:0] data_in;
wire [3:0] ham_out;

Hamming_decoder DUT(data_in, ham_out);

task my_checker;
input [3:0] expected_out;
begin
    if(ham_out!==expected_out)begin//if the datapath_out is not the answer we expected
        $display("ERROR ** output is %b,expected %b",ham_out,expected_out);
        err=1'b1; //err=1, that means err happens      
    end
end
endtask

initial begin
err=1'b0;
#10;

data_in=7'b0101011;
#10;
$display("checking");
#10;
my_checker(4'b0010);
#10;

data_in=7'b0000001;
#10;
$display("checking");
#10;
my_checker(4'b0000);
#10;

data_in=7'b1001101;
#10;
$display("checking");
#10;
my_checker(4'b0100);

#10;

if(~err) $display("PASSED");//if there is no err, we can pass the testbench
    else $display("FAILED");//otherwise, we will fail it
    $stop;//because of the forever loop for clk, we need use stop to stop the testbench

end
endmodule
