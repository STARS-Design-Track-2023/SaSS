// ************************************************************************************************
// Waveshaper
//   inputs: Q <- 8 bits from seq div the quotient
//           mode <- 3 bits from mode FSM to determine if synth should output off, square, saw,
//                   or triangle
//           count <- 19 bits from osc
//           divisor <- 19 bits from freq div table
//
//   output: sample <- 8 bit fed to PWM to determine duty cycle
//
//   Use: turns vaules from seq div into shaped waves
//
//        off         
//
//                   __________________________  
//
//
//        square     _____        ______
//                        |      |      |
//                        |______|      |______
//   
//        saw          /|  /|  /|  /|  /|  /|
//                    / | / | / | / | / | / | /
//                   /  |/  |/  |/  |/  |/  |/
//
//        triangle     /\    /\    /\    /\
//                    /  \  /  \  /  \  /  \
//                   /    \/    \/    \/    \
//
//
// ************************************************************************************************

module waveshaper(
    input logic [7:0] Q,
    input logic [2:0] mode,
    input logic [18:0] count, divisor,
    output logic [7:0] sample
);
    logic [8:0] b_sample;

    always_comb begin
        case(mode)
            0: b_sample = 0;                                //off
            1: b_sample = (count > divisor >> 1) ? 255 : 0; //square
            2: b_sample = {1'b0, Q};                        //saw
            3: begin                                        //triangle
                if(count < divisor >> 1)                    // |
                    b_sample = {1'b0, Q} << 1;              // |
                else                                        // |
                    b_sample = 510 - ({1'b0, Q} << 1);      //\ /
               end
            default: b_sample = 0;
        endcase
        sample = b_sample[7:0];
    end
endmodule