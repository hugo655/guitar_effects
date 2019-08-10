module distortion(
	x,
	y,
	audio_ready,
	indicator,
	rst,
	CLK,	
	en);

	parameter DATA_WIDTH=32;

	output reg [DATA_WIDTH-1:0]	y;
	output reg indicator;

	input	en,CLK,rst;
	input [DATA_WIDTH-1:0]	x;
	input audio_ready;


	//Local Variables
	reg [DATA_WIDTH-1:0] data_in;
	wire [DATA_WIDTH-1:0] comparador_out;

	comparador my_comparador(.data_in(data_in),
									 .data_out(comparador_out),
									 .threshold(32'h01000000)); //Magic number so far ...

									
	always@(posedge CLK, negedge rst)
	begin
		if(~rst)
		begin
			data_in <= 'b0;
			y <= 'b0;
			indicator <= 'b0;
		end
		else
		begin
			if(en)
			begin
				if(audio_ready)
				begin
					data_in <= x;
					y <= comparador_out << 2;
					indicator <= 'b1;
				end
			end	
			else
			begin
				data_in <= x;
				y <= x;
				indicator <= 'b0;
			end
		end
	end
endmodule
