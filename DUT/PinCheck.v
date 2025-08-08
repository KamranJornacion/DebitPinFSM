

module PinCheck #(parameter passkey = 4'b1010)(
    input [1:0] digit,
    input submit, reset, clk,
    output reg waiting, correct, incorrect,bug
);
    reg [2:0] state;
	reg update,verify;
	reg [2:0] dig_count;
	reg [7:0] password;
	reg firstDigit,secondDigit;
	reg right_wrong_in,right_wrong_out;
	 
//Instantiate LED holding
	 HoldLED holdLED(
		.clk(clk),
		.reset(right_wrong_in),
		.LED(right_wrong_out)
	 );

 //state reset
		always @(posedge clk or posedge reset) begin
		  if(reset) begin
				state <= 0;
				correct<=0;
				incorrect<=0;
				bug<=0;
		  end
		end
		
//pinloading
		always @(posedge clk) begin
			if(reset) begin
				password <= 0;
				update<=0;
				dig_count<=0;
				verify<=0;
			end else if(firstDigit) begin
				password <= {password[6:0],digit[1]};
				secondDigit<=1;
				firstDigit<=0;
			end else if(secondDigit) begin
				password <= {password[6:0],digit[0]};
				secondDigit<=0;
				dig_count<= dig_count+1;
				update<=1;
			end else if (submit) begin
				firstDigit<=1;
			end
		end


//fsm logic
		always @(posedge clk or posedge reset) begin
		  case(state)
			0:begin//Default state
				waiting<=1;
				state <= update;
				verify<=0;
			end
			1:begin//Digit read state
				if(dig_count==4) begin//if all digits are read, move to next state
					update <= 2;
					waiting<=0;
					verify<=1;
				end else begin
					update<=0;
				end
				state <=update;		
			end
			2:begin//all digits have been read, 
			//TODO: verified timing logic with timing chart, need to decide what state 2 is.
			//Next step would be verification so i need to think about what verification logic will be and how it should relate to flags like waiting or other leds
			//waiting turns to 0 when update is assigned 2. Is this ideal? state only changes 2 cycles after update changes this should be considered.
				if(password == passkey) begin
					state <=3;
				end else begin
					state<=4;
				end
				verify<=0;
			end
			
			3:begin//correct password
				right_wrong_in<=1;
				correct<=1;
				state<=5;
				
			end
			
			4:begin//incorrect password
				right_wrong_in<=1;
				incorrect<=1;
				state<=5;
			end
			
			5:begin//Holding LED
				right_wrong_in<=0;
				if(right_wrong_out!=1) begin
					state<=0;
					correct<=0;
					incorrect<=0;
				end
					
			end
			
			default:begin
				bug<=1;
			end
		  endcase
		end


    
    

    

endmodule