module tremolo_table(
	y,
	counter,
	en,
	x
);

	parameter DATA_WIDTH = 32;
	localparam COUNTER_WIDTH = 3;
	
	output reg signed [DATA_WIDTH -1:0]	y;
	
	input	en;
	input signed [DATA_WIDTH -1:0]		x;
	input	[COUNTER_WIDTH -1:0]	counter;
	
	always @(*)
	begin
		if(en)
			case(counter)
				3'h0:	y = x >>> 0;
				3'h1:	y = x >>> 1;
				3'h2:	y = x >>> 2;
				3'h3:	y = x >>> 3;
				3'h4:	y = x >>> 4;
				3'h5:	y = x >>> 5;
				3'h6:	y = x >>> 6;
				3'h7:	y = x >>> 7;
				default: y = x;
			endcase
		else
			y = x;
	end
endmodule