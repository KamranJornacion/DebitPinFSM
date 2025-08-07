`ifndef 
    `define passkey  4'b1010
`endif



module top();

    parameter passkey = `passkey;

    logic [3:0] digits;
    logic clk, reset, submit, waiting, correct, incorrect, bug;
    

    DebitPin #(passkey) debitpin(
        .digit_switches(digits),
        .clk(clk),
        .reset(reset),
        .submit(submit),
        .waiting(waiting),
        .correct(correct),
        .incorrect(incorrect),
        .bug(bug)
    );


    task DigitSubmission();//implement this testbench
        
        
        
        initial begin
        //randomize passkey selection

        //for each digit
            //submit random digit

            //observe statemachine progression
        
        //assert desired passkey matches input

        end

    endtask


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);

        @(negedge clk);
            reset = 1;
        @(negedge clk);
            reset = 0;

        DigitSubmission();


        $finish();
    end

endmodule