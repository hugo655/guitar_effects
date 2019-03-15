module delay(
	x,
	y,
	clk,
	options,
	en	
);

parameter	B=15;
parameter	T=20000;

input	en,clk;
input	[31:0]	x;
input	[3:0]	options;
output	reg	[31:0]	y;

// Signals for accessing dual-port RAM
reg 	[31:0]	data_in,data_out1,data_out2;
reg	[B -1:0]	i, addr1, addr2;
wire		we;

// Signals for internal counters 
wire	[B -1:0]	max_delay;


memory	ram(
	.CLK(clk),
	.WE(we),
	.ADDR1(addr1),
	.ADDR2(addr2),
	.DI(data_in),
	.DO1(data_out1),
	.DO2(data_out2));

always @(posedge clk)
begin
	if(addr1 == max_delay-2)
		addr1 <= 'b0;
	else
		addr1 <= addr1 +1;
end


always @(posedge clk)
begin
	if(i == max_delay-2)
		i <= 'b0;
	else
		i <= i +1;
end

always @(posedge clk, options)
begin
	if( options == 4'b1000)
	begin
	
		if(addr1 == max_delay-2)
			addr2 <= 'b0;
		else
			addr2 <= i +1;
	end
end

always @(posedge clk, options)
begin
	if(options == 4'b1000)
	begin
		max_delay <= T-1;
		y_temp <= (x + (data_out2>>1));
		y <= y_temp;
		data_in <= y_temp;
	end	
end
endmodule
