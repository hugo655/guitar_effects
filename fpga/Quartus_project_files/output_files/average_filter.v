module average_filter(
					data_out,
					data_in,
					audio_ready,
					clk,
					rst);

output wire [31:0] data_out;
input			[31:0] data_in;
input	audio_ready;			
input	clk;
input rst;

reg [31:0] flop[4];
wire [31:0] adder[4];

assign adder[0] = (flop[0] + data_in) >>2;
assign adder[1] = (flop[1] + adder[0]) >>2;
assign adder[2] = (flop[2] + adder[1]) >>2;
assign adder[3] = (flop[3] + adder[3]) >>2;
//assign adder[4] = (flop[4] + adder[3]) >>1;
//assign adder[5] = (flop[5] + adder[4]) >>1;
//assign adder[6] = (flop[6] + adder[5]) >>1;
//assign adder[7] = (flop[7] + adder[6]) >>1;

assign data_out = adder[3];
always @(posedge clk, negedge rst)
begin
	if(~rst)
	begin
		flop[0]	<= 'b0;
		flop[1]	<= 'b0;
		flop[2]	<= 'b0;
		flop[3]	<= 'b0;
	end
	else 
	begin
			if(audio_ready) 
			begin
				flop[0]	<= data_in;
				flop[1]	<= flop[0];
				flop[2]	<= flop[1];
				flop[3]	<= flop[2];
			end
	end
end
endmodule