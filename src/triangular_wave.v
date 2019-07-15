module triangular_wave(
		tri_wave,
		direction,
		CLK,
		rst
);

	parameter DATA_WIDTH=8;
	parameter UPPER_LIMIT=30;
	
	output reg [DATA_WIDTH-1:0] tri_wave;
	input CLK, rst;
	
	reg [DATA_WIDTH-1:0] counter;
	output reg direction;

	always @(posedge CLK, negedge rst)
	begin
		if(~rst)
		begin
			direction <= 'b0;
			counter <= 'b0;
			tri_wave <= 'b0;
		end
		else
		begin
			if(~direction) // If 0 then count up
			begin
				if(counter == UPPER_LIMIT)
					direction <= 'b1;
				else
					counter <= counter + 'b1;
			end
			else // if 1, than count down
			begin
				if(counter == 'b0)
					direction <= 'b0;
				else
					counter <= counter -'b1;
			end
			tri_wave <= counter;
		end
	end

endmodule