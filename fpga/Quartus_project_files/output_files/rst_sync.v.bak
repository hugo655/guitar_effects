module rst_sync(
	output reg 	rst_out,
	input			clk,
	input			rst_in
);

reg	rst_meta;

always @(posedge clk, negedge rst_in)
begin
	if(~rst_in)
	begin
		rst_meta <= 'b0;
		rst_out 	<= 'b0;
	end
	else
	begin
		rst_meta <= 'b1;
		rst_out	<= rst_meta;
	end

end
endmodule