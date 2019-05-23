module distortion(
	x,
	y,
	audio_ready,
	indicator,
	rst,
	CLK,
	
	en // It's not being used so far	
);

parameter DATA_WIDTH=32;

input	en,CLK,rst;
input	[DATA_WIDTH-1:0]	x;
input audio_ready;
output	reg	[DATA_WIDTH-1:0]	y;
output reg		indicator;

//Local Variables
reg [DATA_WIDTH-1:0] data_in;



// Data outout
always @(posedge CLK, negedge  rst)
begin
	if(~rst)
		y <='b0;
	else 
	begin
		if(en)
		begin
			indicator <= 'b1;
			if(data_in[DATA_WIDTH-1])
			begin
				if(data_in < -(32'h00C00000))
					y <= -(32'h00C00000);
				else
					y <= data_in;
			end
			else
			begin
				if(data_in >(32'h00C00000))
					y<= (32'h00C00000);
				else	
					y<= data_in;
			end
		end
		else
			y<= data_in;
	end
end

// Data input
always @(posedge CLK, negedge rst)
begin
	if(~rst)
		data_in <= 'b0;
	else begin
		if(audio_ready)
			data_in <= x;	
	end
end


endmodule
