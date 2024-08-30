## Finite State Machines (FSM) and Mealy Machines

### Finite State Machines (FSM)
A **Finite State Machine (FSM)** is a computational model used to design systems that can be in one of a finite number of states at any given time. FSMs transition from one state to another based on inputs, making them useful for modeling sequential logic, control systems, and various computational processes.

FSMs are categorized into two main types:

- **Moore Machine**: Outputs depend only on the current state.
- **Mealy Machine**: Outputs depend on both the current state and the current input.

### Mealy Machine
A **Mealy Machine** is a type of FSM where the output is determined by the current state and the input. This makes it more responsive to inputs, as the output can change immediately with the input, without waiting for a state transition.

**Key Points:**

- Outputs are associated with transitions rather than states.
- Mealy machines often require fewer states than Moore machines for the same task.
  ![image](https://github.com/user-attachments/assets/c6480938-c9a2-407e-b8cf-3c485ed7f276)
 


## Vending Machine Verilog Code

This Verilog module implements a simple vending machine that accepts coins and dispenses an item with the appropriate change. The vending machine accepts two types of coins: 5 rs and 10 rs, and dispenses a single item when the total amount is sufficient.

```verilog
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
```
## Vending Machine Verilog Code Test Bench 

This Verilog module implements a simple vending machine that accepts coins and dispenses an item with appropriate change. It accepts two types of coins: 5 rs and 10 rs, and dispenses an item when the total amount is sufficient.

### Module Description

```verilog
// Testbench for vending_machine_18105070
module vending_machine_tb;

// Inputs
reg clk;       // Clock signal
reg [1:0] in;  // Input coin: 01 = 5 rs, 10 = 10 rs
reg rst;       // Reset signal

// Outputs
wire out;      // Output signal for dispensing the item (bottle)
wire [1:0] change; // Change returned: 01 = 5 rs, 10 = 10 rs

// Instantiate the Unit Under Test (UUT)
vending_machine_18105070 uut (
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(out),
    .change(change)
);

initial begin
    // Initialize Inputs and Set Up Waveform Dumping
    $dumpfile("vending_machine_18105070.vcd"); // Specify the VCD file for waveform viewing
    $dumpvars(0, vending_machine_tb);          // Dump all variables from the testbench module
    
    rst = 1;  // Apply reset initially to set the FSM to its initial state
    clk = 0;  // Initialize clock signal to 0
    #6 rst = 0;  // Release reset after some time to start the FSM operation
    
    in = 2;   // Insert a 10 rs coin
    #19 in = 2; // Insert another 10 rs coin after some delay
    
    #25 $finish; // End the simulation after the specified time
end

// Clock Generation
always #5 clk = ~clk; // Toggle the clock signal every 5 time units

endmodule
```

