`ifndef passkey
    `define passkey  8'b10100101
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

    function automatic logic [1:0] encode (input logic [3:0] in);
        casez(in)
            4'b1???:encode = 2'd3;
            4'b01??:encode = 2'd2;
            4'b001?:encode = 2'd1;
            4'b0001:encode = 2'd0;
            default: encode = 2'bxx;
        endcase
    endfunction

     function automatic logic [3:0] decode (input logic [1:0] in);
        casez(in)
            2'd3:decode = 4'b1000;
            2'd2:decode = 4'b0100;
            2'd1:decode = 4'b0010;
            2'd0:decode = 4'b0001;
            default: decode = 4'bx;
        endcase
    endfunction

    task DigitSubmission();//implement this testbench
        static bit [3:0] allowed_digits [0:3];
        logic [15:0] password;
        begin
            
            allowed_digits[0] = 4'b1000;
            allowed_digits[1] = 4'b0100;
            allowed_digits[2] = 4'b0010;
            allowed_digits[3] = 4'b0001;
            //for each digit
            repeat(24) @(posedge clk) begin
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
                    //allow pincheck logic to update
                    repeat(2) begin
                        @(negedge clk);
                    end
                    //observe statemachine progression
                    $display("T=%0t,passowrd = %0b,encode=%0b",$time,password[15:12],encode(password[15:12]));
                    $display("passowrd = %0b,encode=%0b",password[11:8],encode(password[11:8]));
                    $display("passowrd = %0b,encode=%0b",password[7:4],encode(password[7:4]));
                    $display("passowrd = %0b,encode=%0b",password[3:0],encode(password[3:0]));
                end
                assert(encode(password[15:12]) ==debitpin.pinchk.password[7:6]);
                assert(encode(password[11:8]) ==debitpin.pinchk.password[5:4]);
                assert(encode(password[7:4]) ==debitpin.pinchk.password[3:2]);
                assert(encode(password[3:0]) ==debitpin.pinchk.password[1:0]);
            end
        end

    endtask

   
    task PasswordVerification();
    begin
            logic [15:0] password;
            
            password[15:12] = decode(passkey[7:6]);
            password[11:8] = decode(passkey[5:4]);
            password[7:4] = decode(passkey[3:2]);
            password[3:0] = decode(passkey[1:0]);

            repeat(4) @(posedge clk) begin
                //randomize passkey selection
                bit [3:0] digit;


                //submit random digit
                digits = password[15:12];
                password = {password[11:0],4'b0};

                @(posedge clk);
                    submit = 1;
                @(negedge clk);
                    submit = 0;
                //allow pincheck logic to update
                repeat(2) begin
                    @(negedge clk);
                end
                //observe statemachine progression
                $display("T=%0t,passowrd = %0b",$time,password);
                
            end
            assert(password==0);        
            assert(debitpin.pinchk.dig_count==4);
            
            @(negedge clk);
                assert(debitpin.pinchk.dig_count == 0); 
                assert(debitpin.pinchk.verify == 1);
                assert(waiting==0);    
            @(negedge clk); 
                assert(debitpin.pinchk.state==3);
            @(negedge clk); 
                assert(debitpin.pinchk.state==5);
                assert(correct==1);
                assert(incorrect ==0);
                assert(bug==0);
        end
    endtask

     task WrongPasswordVerification();
    begin
            logic [15:0] password;
            logic [7:0] attempt;
            
            repeat(24) @(posedge clk) begin
                
                do begin 
                    attempt = $urandom();
                end while (attempt == passkey);

                password[15:12] = decode(attempt[7:6]);
                password[11:8] = decode(attempt[5:4]);
                password[7:4] = decode(attempt[3:2]);
                password[3:0] = decode(attempt[1:0]);

                repeat(4) @(posedge clk) begin
                    //randomize passkey selection
                    bit [3:0] digit;


                    //submit random digit
                    digits = password[15:12];
                    password = {password[11:0],4'b0};

                    @(posedge clk);
                        submit = 1;
                    @(negedge clk);
                        submit = 0;
                    //allow pincheck logic to update
                    repeat(2) begin
                        @(negedge clk);
                    end
                    //observe statemachine progression
                    $display("T=%0t,passowrd = %0b",$time,password);
                    
                end
            assert(password==0);        
            assert(debitpin.pinchk.dig_count==4);
            
            @(negedge clk);
                assert(debitpin.pinchk.dig_count == 0); 
                assert(debitpin.pinchk.verify == 1);
                assert(waiting==0);    
            @(negedge clk); 
                assert(debitpin.pinchk.state==4);
            @(negedge clk); 
                assert(debitpin.pinchk.state==5);
                assert(correct==0);
                assert(incorrect ==1);
                assert(bug==0);
            end
        end
    endtask


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars();
        $dumpvars(0,debitpin.pinchk);

        @(negedge clk);
            reset = 1;
        @(negedge clk);
            reset = 0;

        // DigitSubmission();


        //PasswordVerification();

        WrongPasswordVerification();

        $finish();
    end

endmodule

//TODO: Testbench for pinverify low key is correct but the state update mechanism is convoluted and could be simplified. Aim to do so next time. Specifically
//The state oscilalted bwteen 0 and 1 and so it creates a cycle delay before it can move on to state 2/3
//may be an issue may not- but see if i can simplify logic