module delay(
	x,
	y,
	rst,
	CLK,
	options,// It only works with 4'b1000 so far
	en // It's not being used so far	
);

parameter DATA_WIDTH=32;
parameter ADDR_WIDTH=15;
parameter SIZE=20000;

input	en,CLK,rst;
input	[DATA_WIDTH-1:0]	x;
input	[3:0]	options;
output	reg	[DATA_WIDTH-1:0]	y;

// Signals for accessing dual-port RAM
reg 	[DATA_WIDTH-1:0] DI;
wire	[DATA_WIDTH-1:0] DO2;
reg	[ADDR_WIDTH -1:0]	i, ADDR1, ADDR2;
wire		we;

// Signals for internal counters 
reg	[ADDR_WIDTH -1:0]	max_delay;
reg 	[DATA_WIDTH:0]	y_temp;


//ADDR1 for writting and ADDR2 for reading
memory	#(.DATA_WIDTH(DATA_WIDTH),
	  .SIZE(SIZE),
	  .ADDR_WIDTH(ADDR_WIDTH))
	ram_memory(.WE(1'b1),
		   .ADDR1(ADDR1),
		   .ADDR2(ADDR2),
		   .DO1(),
		   .DO2(DO2),
		   .DI(DI),
		   .CLK(CLK));
always @(posedge CLK, negedge rst)
begin
	if(~rst)
		ADDR1 <= 'b0;
	else 
	if(ADDR1 == max_delay-2)
		ADDR1 <= 'b0;
	else
		ADDR1 <= ADDR1 +1;

end

always @(posedge CLK, negedge rst)
begin
	if(~rst)
		ADDR2 <= 'b1;
	else
	if(options == 4'b1000)
		if(ADDR1 == max_delay-1)
			ADDR2 <= 'b0;
		else
			ADDR2 <= ADDR1+1;
	else
		ADDR2 <= ADDR2;

end
always @(posedge CLK, options, negedge rst)
begin
	if(~rst)
	begin
		max_delay <= {ADDR_WIDTH{1'b1}} ;
		y_temp <= 'b0;
		y <= x;
		DI <= 'b0;
	end
	else		
	if(options == 4'b1000)
	begin
		max_delay <= {ADDR_WIDTH{1'b1}} ;
		y_temp <= (x + (DO2>>1));
		y <= y_temp;
		DI <= y_temp;
	end	
	else
	y <= x;
end
endmodule
