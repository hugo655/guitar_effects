
module	memory(
	WE, // write enable for channel b
	ADDR1, // write/read address for channel a (read channel)
	ADDR2, // write/read address for channel b (write channel)
	DO1, // Ouput data from channel b (not used)
	DO2, // Output data from channel a (read channel)
	DI, // Input data for channel b (write channel)
	CLK 
);

parameter DATA_WIDTH=31;
parameter ADDR_WIDTH=15;
parameter SIZE=20000;

output reg [DATA_WIDTH-1:0] 	DO1,DO2;
input	   [DATA_WIDTH-1:0] 	DI;
input	   [ADDR_WIDTH-1:0]	ADDR1, ADDR2;
input	   		CLK,WE;

// Registers used from RAM to output of this module
wire [DATA_WIDTH-1:0] RAM_DO2, RAM_DO1;

// Notice channel 1 of this wrapp model goes to channel B of the RAM cell
// same happens to channel 2 (this module) and channel B (RAM cell)
dp_memory #(.ADDR_WIDTH(ADDR_WIDTH),
	    .DATA_WIDTH(DATA_WIDTH),
	    .SIZE(SIZE)) RAM(
	.data_a('b0), // Doesn't matter since channel A is used for reading purposes only
	.data_b(DI),
	.addr_a(ADDR2),
	.addr_b(ADDR1),
	.we_a('b0), // channel A is for reading
	.we_b(WE),
	.clk(CLK),
	.q_a(RAM_DO2), //Not really used
	.q_b(RAM_DO1));

always @(posedge CLK)
begin
// Fix this: In their original project they have registered the output
	DO1 <= RAM_DO1;
	DO2 <= RAM_DO2;
end

endmodule
