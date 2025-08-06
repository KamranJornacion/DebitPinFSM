
module HoldLED #(parameter length= 250_000_000)(
	input clk,reset,
	output reg LED
	);
	
	reg [27:0] counter;
	
	always @(posedge clk)begin
		if(reset) begin
			counter<=0;
			LED <=1;
			

		end else if(counter<length)begin
			LED<=1;
			counter<= counter+1;
		end else begin
			LED<=0;
		end
		
	end
endmodule