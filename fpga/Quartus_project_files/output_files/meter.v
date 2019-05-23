module meter(
	x,
	y,
	clk,
	rst
);

	input signed [31:0] x;
	input	clk;
	input rst;
	
	output wire signed [31:0] y;
	
	
	reg signed [31:0] max;
	
	assign y = max;
	always @(posedge clk, negedge rst)
	begin
		if(~rst)
			max <='b0;
		else
		begin
			if(x > max)
				max <= x;
		end
	
	
	
	end



endmodule