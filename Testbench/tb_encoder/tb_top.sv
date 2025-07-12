`timescale 10ns/100ps //timescale precision

module testbench();
	import uvm_pkg::*;
	
  
  encoder_if enc_if();
  
  priorityEncoder dut_enc(
    .in(enc_if.in),
    .out(end_if.out)
  );
  
  
  

	initial begin
      
    end



endmodule