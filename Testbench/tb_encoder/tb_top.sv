import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "tb_transaction.sv"
	`include "Interface\encoder_if.sv"
    `include "tb_driver.sv"
	`include "tb_monitor.sv"
	`include "tb_sequencer.sv"
	`include "tb_env.sv"
	`include "tb_sequence.sv"
 	`include "tb_test.sv"
    `include "DUT\Encoder.v"

    


`timescale 10ns/100ps //timescale precision

module testbench();

  	
	
  
  encoder_if enc_if();
  
  priorityEncoder dut_enc(
    .in(enc_if.in),
    .out(enc_if.out)
  );
  
  
  

	initial begin
      
      $dumpfile("dump.vcd");
      $dumpvars(0,dut_enc);
      uvm_config_db#(virtual encoder_if)::set(null,"*", "encoder_if", enc_if);
      
      run_test("encoder_test");
      
    end



endmodule
