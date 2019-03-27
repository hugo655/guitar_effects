`timescale 1ns/1ps
`define CLK_PERIOD 10
module tb();

parameter DATA_WIDTH=32;
parameter SIZE=8;
parameter ADDR_WIDTH=3;



reg CLK, WE; 

reg [ADDR_WIDTH-1:0] ADDR1, ADDR2;
reg [DATA_WIDTH-1:0] DI;

wire [DATA_WIDTH-1:0] DO1, DO2; 

//Channel 1 is for writting, channel 2 for reading
memory	#(.DATA_WIDTH(DATA_WIDTH),
	  .SIZE(SIZE),
	  .ADDR_WIDTH(ADDR_WIDTH))
	ram_memory(.WE(WE),
		   .ADDR1(ADDR1),
		   .ADDR2(ADDR2),
		   .DO1(DO1),
		   .DO2(DO2),
		   .DI(DI),
		   .CLK(CLK));

//***********
//** TASKS **
//***********

task initiate;
begin
	CLK<=0;
	WE<=1;
	DI<= 'b0;
	ADDR1 <= 'b0;
	ADDR2 <= 'b0;
end
endtask

task write;

	input [ADDR_WIDTH-1:0] addr;
	input [DATA_WIDTH-1:0] data;
	
	begin
	ADDR1 <= addr;
	DI <= data;
	end
endtask 

task read;
	
	input [ADDR_WIDTH-1:0] addr;
	
	begin
	ADDR2 <= addr;
	end
	
endtask

reg [DATA_WIDTH-1:0] temp;
reg [ADDR_WIDTH-1:0] write_pointer;
reg [ADDR_WIDTH-1:0] read_pointer;
task write_memory;
begin
	temp =0;
	write_pointer=0;
	repeat(SIZE)begin
		@(posedge CLK);
		write(write_pointer,temp);
		temp <= temp+1;
		write_pointer<= write_pointer+1;
	end
end

endtask

task read_write_memory;
begin
	temp =10;
	write_pointer=0;
	read_pointer=1;
	repeat(2*SIZE)begin
		@(posedge CLK);
		write(write_pointer,temp);
		read(read_pointer);
		temp <= temp+10;
		write_pointer<= write_pointer+1;
		read_pointer<= read_pointer+1;
	end
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
	$dumpvars(1,ram_memory.RAM.ram[i]);
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
	//Write a value in position 10 of memory, then read it
	write(3'd2, 32'd10);
	@(posedge CLK);
	read(3'd2);
	@(posedge CLK);
	//Fill memory with write instruction
	write_memory;
	//Read and write from memory
	@(posedge CLK);
	read_write_memory;
#100;
$finish;

end

endmodule
