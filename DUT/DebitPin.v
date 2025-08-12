

module DebitPin #(parameter passkey = 8'b10100101)(
    input [3:0] digit_switches,
    input clk, reset, submit,
    output reg waiting, correct, incorrect,bug
);

    wire [1:0] digit;

    priorityEncoder priority_enc(
        .in(digit_switches),
        .out(digit)

    );

    PinCheck #(passkey) pinchk(
        .digit(digit),
        .submit(submit), .reset(reset), .clk(clk),
        .waiting(waiting), .correct(correct), .incorrect(incorrect),.bug(bug)
    );


endmodule