module vending_machine_18105070(
    input clk,              // Clock signal
    input rst,              // Reset signal
    input [1:0]in,          // Input coin: 01 = 5 rs, 10 = 10 rs
    output reg out,         // Output signal for dispensing the item (bottle)
    output reg [1:0] change // Change returned: 01 = 5 rs, 10 = 10 rs
);

// State encoding
parameter s0 = 2'b00; // State 0: No money inserted
parameter s1 = 2'b01; // State 1: 5 rs inserted
parameter s2 = 2'b10; // State 2: 10 rs inserted

// Current and next state registers
reg [1:0] c_state, n_state;

// State transition logic
always @(posedge clk) begin
    if (rst == 1) begin
        c_state = 0;           // Reset current state to s0
        n_state = 0;           // Reset next state to s0
        change = 2'b00;        // No change returned
    end else begin
        c_state = n_state;     // Update current state to next state
    end

    case(c_state)
        s0: // State 0: 0 rs inserted
            if (in == 0) begin
                n_state = s0;     // Stay in state 0
                out = 0;          // No item dispensed
                change = 2'b00;   // No change returned
            end else if (in == 2'b01) begin
                n_state = s1;     // Move to state 1 (5 rs inserted)
                out = 0;          // No item dispensed
                change = 2'b00;   // No change returned
            end else if (in == 2'b10) begin
                n_state = s2;     // Move to state 2 (10 rs inserted)
                out = 0;          // No item dispensed
                change = 2'b00;   // No change returned
            end

        s1: // State 1: 5 rs inserted
            if (in == 0) begin
                n_state = s0;     // Return to state 0
                out = 0;          // No item dispensed
                change = 2'b01;   // Return 5 rs as change
            end else if (in == 2'b01) begin
                n_state = s2;     // Move to state 2 (10 rs inserted)
                out = 0;          // No item dispensed
                change = 2'b00;   // No change returned
            end else if (in == 2'b10) begin
                n_state = s0;     // Return to state 0
                out = 1;          // Dispense item (bottle)
                change = 2'b00;   // No change returned
            end

        s2: // State 2: 10 rs inserted
            if (in == 0) begin
                n_state = s0;     // Return to state 0
                out = 0;          // No item dispensed
                change = 2'b10;   // Return 10 rs as change
            end else if (in == 2'b01) begin
                n_state = s0;     // Return to state 0
                out = 1;          // Dispense item (bottle)
                change = 2'b00;   // No change returned
            end else if (in == 2'b10) begin
                n_state = s0;     // Return to state 0
                out = 1;          // Dispense item (bottle)
                change = 2'b01;   // Return 5 rs as change
            end
    endcase
end

endmodule
