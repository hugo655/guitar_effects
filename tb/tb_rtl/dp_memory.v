// This model is based on intel's True_Dual_Port RAM with single clock module
// avaible at https://www.intel.com/content/www/us/en/programmable/support/support-resources/design-examples/design-software/verilog/ver-true-dual-port-ram-sclk.html
module dp_memory #(
  parameter SIZE=256,
  parameter DATA_WIDTH=8,                 //width of data bus
  parameter ADDR_WIDTH=8                  //width of addresses buses
)(
  input	[DATA_WIDTH-1:0]	data_a,
  input	[DATA_WIDTH-1:0]	data_b,
  input	[ADDR_WIDTH-1:0]	addr_a,
  input	[ADDR_WIDTH-1:0]	addr_b,
  input				we_a,
  input				we_b,
  input				clk,
  output reg [DATA_WIDTH-1:0]	q_a,
  output reg [DATA_WIDTH-1:0]	q_b);
   

 
  reg [DATA_WIDTH-1:0] ram [SIZE-1:0];
  
integer index;
  initial begin
	for(index =0; index < SIZE; index = index+1)
		ram[index] = 'b0;
  end 
// One can either write or write in both a/b channels
  always @(posedge clk) 
  begin
	if(we_a)
	begin
	  ram[addr_a] <= data_a;
	  q_a   <= data_a;
	end
	else
	  q_a   <= data_a;
	
	if(we_b)
	begin
	  ram[addr_b] <= data_b;
	  q_b   <= data_b;
	end
	else
	  q_b   <= data_b;
  end 
    
endmodule
