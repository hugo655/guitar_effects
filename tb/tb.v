`timescale 1ns/1ps
`define CLK_PERIOD 10
module tb();

parameter DATA_WIDTH=32;
parameter SIZE=8;
parameter ADDR_WIDTH=3;



reg CLK, rst; 

reg [DATA_WIDTH-1:0] x;
wire [DATA_WIDTH-1:0] y;



delay#(
	.DATA_WIDTH(DATA_WIDTH),
	.SIZE(SIZE),
	.ADDR_WIDTH(ADDR_WIDTH)
) my_delay(
	.x(x),
	.y(y),
	.CLK(CLK),
	.options(4'b1000),
	.en('b0),
	.rst(rst)	
);

//***********
//** TASKS **
//***********

task initiate;
begin
	rst<= 'b0;
	CLK<=0;
	x <= 'b0;
end
endtask



//*******************
//** SETUP DUMPFILE**
//*******************
integer i;

initial begin
	$dumpfile("my_dumpfile.vcd");
	$dumpvars(0,tb);
	for(i = 0; i < SIZE; i = i + 1)
	$dumpvars(1,my_delay.ram_memory.RAM.ram[i]);
end


//**************
//** SETUP CLK**
//**************

always #(`CLK_PERIOD/2) CLK <= ~CLK;

initial
begin
	$display("Initializing Simulation \n\n");
	initiate;
	@(posedge CLK);
	rst <= 'b1;
	@(posedge CLK);	
	repeat(SIZE*2)begin
		@(posedge CLK);
		x<= x+1;
	end
#200;
$finish;

end

endmodule
