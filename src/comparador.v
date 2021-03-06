module comparador(
	data_out,
	data_in,
	threshold
);


	parameter DATA_LENGTH=32;
		
	output reg [DATA_LENGTH-1:0] data_out;
	input	[DATA_LENGTH-1:0] data_in;
	input [DATA_LENGTH-1:0] threshold;
	
	
	always @(*)
	begin
		if(data_in[DATA_LENGTH-1]) // Test for negative number
		begin
			if(data_in < -threshold)
				data_out = -threshold;
			else
				data_out = data_in;
		end else
		begin
			if(data_in > threshold)
				data_out = threshold;
			else
				data_out = data_in;		
		end	
	end
	
endmodule