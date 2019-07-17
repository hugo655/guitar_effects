module tremolo(
	tri_wave,
	y,
	indicator,
	x,
	audio_ready,
	rst,
	CLK,
	en
);

	parameter DATA_WIDTH=32;
	parameter TRI_WAVE_DATA_WIDTH = 3;
	parameter TRI_WAVE_UPPER_LIMIT = 3;
	
	output wire [DATA_WIDTH-1:0] y;
	output wire indicator;
	
	input 	[DATA_WIDTH-1:0] x;
	reg 	[DATA_WIDTH-1:0] audio_in;
	input	en, CLK, audio_ready,rst;

	wire CLK_2;
	output wire signed [TRI_WAVE_DATA_WIDTH-1:0] tri_wave;
	reg signed [DATA_WIDTH+TRI_WAVE_DATA_WIDTH-1:0] prod_result;
	
	// Creating a 2 Hz clock
	clock_divider #(.DIVIDER(1250000)) clk_2(.clk_in(CLK),
														.clk_out(CLK_2),
														.indicator(indicator),
														.rst(rst));

	triangular_wave#(.UPPER_LIMIT(TRI_WAVE_UPPER_LIMIT), .DATA_WIDTH(TRI_WAVE_DATA_WIDTH)) triangular_wave0(.tri_wave(tri_wave),
																		 .CLK(CLK_2),
																		 .rst(rst));
	
	
	tremolo_table#(.DATA_WIDTH(DATA_WIDTH))	trem_table(	.y(y),
										.counter(tri_wave),
										.en(en),
										.x(audio_in));
										
//	always @(posedge CLK, negedge rst)
//	begin
//		if(~rst)
//			indicator <= 'b0;
//		else
//		begin
//		if(en)
//		begin
//			if(tri_wave == TRI_WAVE_UPPER_LIMIT)
//				indicator <= 'b1;
//			else if(tri_wave == 'b0)
//				indicator <= 'b0;
//		else	
//			indicator <= 'b0;
//		end
//	end
//	end
	
	always@(posedge CLK, negedge rst)
	begin
		if(~rst)
			audio_in <= 'b0;
		else
			if(audio_ready)
			audio_in <= x;
	end

endmodule