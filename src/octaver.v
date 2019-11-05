module octaver(
	x,
	y,
	debug,
	indicator,
	rst,
	CLK,
	audio_ready,
	en 
);

parameter DATA_WIDTH=32;
parameter ADDR_WIDTH=7;
parameter SIZE=5000;

input	en,CLK,rst;
input	[DATA_WIDTH-1:0]	x;
input audio_ready;
output reg signed	[DATA_WIDTH-1:0]	y;
output reg [1:0] debug;
output reg		indicator;

// Signals for accessing dual-port RAM
reg 	[DATA_WIDTH-1:0] DI;
wire	[DATA_WIDTH-1:0] DO2;
reg	[ADDR_WIDTH -1:0]	i, ADDR1, ADDR2;
wire		we;

// Signals for internal counters 
reg	[ADDR_WIDTH -1:0]	max_delay;
reg 	[DATA_WIDTH-1:0]	y_temp;


//ADDR1 for writting and ADDR2 for reading
memory_2	#(.DATA_WIDTH(DATA_WIDTH),
	  .SIZE(SIZE),
	  .ADDR_WIDTH(ADDR_WIDTH))
	ram_memory(.WE(audio_ready),
		   .ADDR1(ADDR1),
		   .ADDR2(ADDR2),
		   .DO1(),
		   .DO2(DO2),
		   .DI(DI),
		   .CLK(CLK));

//Read Channel
always @(posedge CLK, negedge rst)
begin
	if(~rst)
		ADDR2 <= 'b0;
	else 
	begin
		if(audio_ready)
			ADDR2 <= ADDR1 >>1;
		else
			ADDR2 <= ADDR2;
	end

end
//Write Channel
always @(posedge CLK, negedge rst)
begin
	if(~rst)
	begin
		ADDR1 <= 'b1;
		indicator <= 'b0;
	end
	else begin
	if(audio_ready)
	begin		
			if(ADDR1 == max_delay)
			begin	
				ADDR1 <= 'b0;
				indicator <= ~indicator;
			end
			else
				ADDR1 <= ADDR1 +'b1;
	end
	else
			ADDR1 <= ADDR1;			
	end

end
//Wrting and output logic
always @(posedge CLK, negedge rst)
begin
	if(~rst)
	begin
		max_delay <= 'h2EA0 ;
		y_temp <= 'b0;
		y <= 'b0;
		DI <= 'b0;
		debug <= 2'b11;
	end
	else 
	begin		
		if(en)
		begin
			debug[1:0] <= 2'b01;
			max_delay <= 'hFA0;
			DI <= x;
			y_temp <= DO2 + x ;
			y <= y_temp ;
		end	
		else 
		begin
			DI <= 'b0;
			debug[1:0] <= 2'b10;
			y <= x;
		end
	end
end
endmodule
