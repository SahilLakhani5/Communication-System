module counter #(parameter NUM = 179) (
  input clk, rst_n,
  output logic trigger
);

  integer count = 0;

  always_ff @(posedge clk) begin
    trigger <= 1'b0;

    if (count == NUM) begin
      count <= 0;
      trigger <= 1'b1;
    end

    else if (!rst_n) begin
      count <= 0;
      trigger <= 1'b0;
    end
    
    else begin
      count <= count + 1;
      trigger <= 1'b0;
    end
  end

  
endmodule