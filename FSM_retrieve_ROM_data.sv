module FSM_retrieve(data_from_ROM, address_for_ROM, data_from_ROM_out, clk, start, finish);

// This module is used to get data from the ROM IP block
// It has a start and a finish signal however since it is the first block that is used in the system, it boots up
// with a virtual high start signal so that the module starts immediately.
// Getting data from the ROM block takes 2 cycles. One to assert the address, one wait signal and
// one outputting cycle

  input clk, start;
  input [31:0] data_from_ROM;
  
  output [15:0] address_for_ROM;
  output [31:0] data_from_ROM_out;
  output finish;
  
  logic [3:0] state;
  
  logic [31:0] addr_increment = 32'b0;
  
  parameter [3:0] Idle = 4'b0000;
  parameter [3:0] Sending_Addr = 4'b1001;
  parameter [3:0] Wait = 4'b0010;
  parameter [3:0] CollectROMdata = 4'b0011;
  parameter [3:0] Flash_finish = 4'b0100;
  
  assign address_for_ROM = state[3] ? addr_increment[15:0] : 15'bx;
  assign data_from_ROM_out = (state == CollectROMdata) ? data_from_ROM : 32'bx;
  assign finish = (state == Flash_finish) ? 1'b1 : 1'b0;
  
	always_ff @(posedge clk) begin
		case(state)
			Idle:	if(start) state <= Sending_Addr;
					else state <= Idle;
			Sending_Addr: 
					state <= Wait;
			Wait:
					state <= CollectROMdata;
			CollectROMdata: begin
					addr_increment <= addr_increment + 32'd1;
					state <= Flash_finish;
								end
			Flash_finish:
					state <= Idle;
			default: state <= Sending_Addr;
		endcase
	end
	
endmodule
