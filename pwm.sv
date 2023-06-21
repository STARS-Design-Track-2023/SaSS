

module pwm (input logic [7:0]comb_waveform, input logic clk, n_rst, output logic pwm_o);

    logic [7:0]count, next_count; // Delaring local use variables, count stores current count and next_count is for flip-flop

    always_ff @ (posedge clk, negedge n_rst) begin
        if(n_rst)
            count <= next_count;
        else
            count <= 0; // Count resets to zero if reset
    end

    always_comb begin

        next_count = (count == 8'd255) ? 8'd0 : (count + 1); // If the count = 255 it wraps to zero, if not it adds 1

        if(count < comb_waveform)
            pwm_o = 1; // PWM 1 when its count is less than inputted value from waveform combiner
        else
            pwm_o = 0; // PWM 0 when its count is greater than or equal to inputted value from waveform combiner

    end

endmodule