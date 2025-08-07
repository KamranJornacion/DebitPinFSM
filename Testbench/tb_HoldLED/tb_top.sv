`ifndef cycle
    `define cycle 250
`endif



module top();

    logic clk, reset, LED;
    parameter cycle = `cycle;


  
  HoldLED #(cycle) dut_HL (
    .clk(clk),
    .reset(reset),
    .LED(LED)
  );
  

    task watchLED();
        
        
        @(posedge clk);
            reset = 1;
        @(negedge clk);
            reset = 0;
        repeat(cycle*2) @(posedge clk) begin
            $display("LED: = %b, Clk = %b,reset =%b",LED,clk,reset);
            
        end

    endtask

    task resetLED();

        @(posedge clk);
            reset = 1;
        @(negedge clk);
            reset = 0;
        
        repeat(cycle*4) @(posedge clk) begin
            reset = $urandom_range(0,1);
            $display("LED: = %b, Clk = %b,reset =%b",LED,clk,reset);
        end


    endtask


  	initial begin
      clk = 0;
      forever #5 clk = ~clk;
    end
  
	initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
        $dumpvars(0,dut_HL);

        //Tests if LED will hold for entire cycle
        watchLED();
        
        //Tests how module responds to randomly timed resets
        resetLED();
      
        $finish;
    end


endmodule