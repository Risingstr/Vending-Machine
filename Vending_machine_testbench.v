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
