module tremolo(
	y,
	indicator,
	x,
	audio_ready,
	rst,
	CLK,
	en
);

	parameter DATA_WIDTH=32;
	parameter TRI_WAVE_DATA_WIDTH = 8;
	parameter TRI_WAVE_UPPER_LIMIT = 30;
	
	output reg [DATA_WIDTH-1:0] y;
	output reg indicator;
	
	input 	[DATA_WIDTH-1:0] x;
	input	en, CLK, audio_ready,rst;

	wire CLK_100;
	wire [TRI_WAVE_DATA_WIDTH-1:0] tri_wave;
	
	// Creating a 100 Hz clock
	clock_divider #(.DIVIDER(500000)) clk_100(.clk_in(CLK),
														.clk_out(CLK_100),
														.rst(rst));

	triangular_wave#(.UPPER_LIMIT(TRI_WAVE_UPPER_LIMIT)) triangular_wave0(.tri_wave(tri_wave),
																		 .CLK(CLK_100),
																		 .rst(rst));
																		 
	always@(posedge CLK, negedge rst)
	begin
		if(~rst)
		begin
		y <= 'b0;
		end
		else
		begin
			if(tri_wave == TRI_WAVE_UPPER_LIMIT)
				indicator <= 'b1;
			else if(tri_wave == 'b0)
				indicator <= 'b0;
		end
	end

endmodule