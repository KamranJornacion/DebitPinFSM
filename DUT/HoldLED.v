
module HoldLED #(parameter length= 250_000_000)(
	input clk,reset_n,
	output LED
	);
	
	reg [27:0] counter;
	
	always @(posedge clk or negedge reset_n)begin
		if(~reset_n) begin
			counter<= 0;

		end else if(counter<length)begin
			counter<= counter+1;
		end else begin
			counter<= length;
		end
		
	end
	
	assign LED = (counter < length);
	
	
endmodule 
