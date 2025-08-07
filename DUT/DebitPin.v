

module DebitPin #(parameter passkey = 4'b1010)(
    input digit_switches[3:0],
    input clk, reset, submit,
    output reg waiting, correct, incorrect,bug
);

    wire [1:0] digit;

    priorityEncoder priority_enc(
        .in(digit_switches),
        .out(digit)

    );

    PinCheck pinchk(
        .digit(digit),
        .submit(submit), .reset(reset), .clk(clk),
        .waiting(waiting), .correct(correct), .incorrect(incorrect),.bug(bug)
    );


endmodule