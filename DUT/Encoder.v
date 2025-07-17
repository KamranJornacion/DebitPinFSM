module priorityEncoder(
	input [3:0] in,
	output reg [1:0] out
	);
	
	
	always @(*)begin
      casez(in)
		4'b1???:out=3;
		4'b01??:out=2;
		4'b001?:out=1;
		4'b0000:out=0;
		default:begin
			out=1;
			end
		endcase
	end
	
endmodule