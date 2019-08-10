module clock_divider(
	clk_out,
	clk_in,
	rst
);

	parameter DIVIDER=500000;
	
	output reg clk_out;
	input		clk_in;
	input		rst;
	;
	reg [31:0] counter;
	always@(posedge clk_in, negedge rst)
	begin
		if(~rst)
		begin
			clk_out <= 'b0;
			counter <= 'b0;
		end
		else
		begin
			if(counter == DIVIDER/2)
			begin
				counter <= 'b0;
				clk_out <= ~clk_out;
			end
			else
				counter <= counter + 'b1;
		end
	end

endmodule