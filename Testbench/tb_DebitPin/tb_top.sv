`ifndef passkey
    `define passkey  4'b1010
`endif


//Iverilog doesn't support constraints and random variable type :(
// class digit_item;

//     randc bit [3:0] digit;

//     constraint digit_lim {((digit == 4'b1000)||(digit == 4'b0100)||(digit == 4'b0010)||(digit == 4'b0001));}

//     function void print(string tag="");
//         $display("T=%0t [%s] digit=%0d",$time,digit);
//     endfunction
// endclass

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
        static bit [3:0] allowed_digits [0:3];
        logic [15:0] password;
        begin
            
            allowed_digits[0] = 4'b1000;
            allowed_digits[1] = 4'b0100;
            allowed_digits[2] = 4'b0010;
            allowed_digits[3] = 4'b0001;
            //for each digit
            repeat(24) begin
                password = 16'b0;

                repeat(4) begin
                    //randomize passkey selection
                    bit [3:0] digit;
                    digit = allowed_digits[$urandom_range(0, 3)];

                    //Track digits submitted
                    password = {password[11:0],digit};

                    //submit random digit
                    digits = digit;
                    @(posedge clk);
                        submit = 1;
                    @(negedge clk);
                        submit = 0;
                    //observe statemachine progression
                    $display("T=%0t,Sumbit = %0b,digits=%0b",$time,submit,digits);
                end
                assert(password ==debitpin.pinchk.password);
            end
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