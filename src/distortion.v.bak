module delay(
	x,
	y,
	debug,
	indicator,
	rst,
	CLK,
	audio_ready,// It only works with 4'b1000 so far
	en // It's not being used so far	
);

parameter DATA_WIDTH=32;
parameter ADDR_WIDTH=14;
parameter SIZE=5000;

input	en,CLK,rst;
input	[DATA_WIDTH-1:0]	x;
input audio_ready;
output	reg	[DATA_WIDTH-1:0]	y;
output reg [1:0] debug;
output reg		indicator;

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
	ram_memory(.WE(audio_ready),
		   .ADDR1(ADDR1),
		   .ADDR2(ADDR2),
		   .DO1(),
		   .DO2(DO2),
		   .DI(DI),
		   .CLK(CLK));
//Write Channel1
always @(posedge CLK, negedge rst)
begin
	if(~rst)
		ADDR1 <= 'b0;
	else 
	begin
		if(audio_ready)
			ADDR1 <= ADDR2;
		else
			ADDR1 <= ADDR1;
	end

end
//Read Channel
always @(posedge CLK, negedge rst)
begin
	if(~rst)
	begin
		ADDR2 <= 'b1;
		indicator <= 'b0;
	end
	else begin
	if(audio_ready)
	begin		
			if(ADDR2 == max_delay)
			begin	
				ADDR2 <= 'b0;
				indicator <= ~indicator;
			end
			else
				ADDR2 <= ADDR2 +'b1;
	end
	else
			ADDR2 <= ADDR2;			
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
			//y_temp is being not necessary here
			y_temp <= x ;
			debug[1:0] <= 2'b01;
			max_delay <= 'h2EA0;
			DI <= x;
			y <= y_temp + DO2 ;
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
