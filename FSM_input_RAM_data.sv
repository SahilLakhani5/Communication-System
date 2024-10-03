module FSM_input(clk, data_to_RAM, data_from_transmission, address, write_enable, finished, start);

	input clk;
	input [31:0] data_from_transmission;
	input start;
	
	output write_enable;
	output [31:0] data_to_RAM;
	output finished;
	output [15:0] address;
	
	logic [3:0] state;
	logic [31:0] counter = 32'b0;
	
	logic [32:0] saved_data = 32'b0;
	
	parameter [3:0] Idle = 4'b0000;
	parameter [3:0] Writing_data = 4'b0001;
	parameter [3:0] Increment_address = 4'b0010;
	parameter [3:0] Flash_finish = 4'b1010;
	
	assign finished = state[3] ? 1'b1 : 1'b0;
	assign data_to_RAM = state[0] ? saved_data : 32'bx;
	assign write_enable = state[0] ? 1'b1 : 1'b0;
	assign address = state[0] ? counter : 15'bx;
	
	always_ff @(posedge clk) begin
		casex(state)
			Idle: begin
					if(start) begin
						state <= Writing_data;
						saved_data = data_from_transmission;
					end
					else state <= Idle;
			      end
			Writing_data:
					state <= Increment_address;
			Increment_address: begin
					counter <= counter + 32'd1;
					state <= Flash_finish;
									 end
			Flash_finish: state <= Idle;
			default: state <= Idle;
		endcase
	end
	
endmodule
			
	