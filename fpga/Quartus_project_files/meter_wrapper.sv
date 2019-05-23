module meter_wrapper(
	display,
	data_in,
	clk,
	rst
);

	output wire [55:0] display ;
	input	[31:0]	data_in;
	input clk, rst;
	
	wire [31:0] meter_disp;
	
	meter meter (	.x(data_in),
						.y(meter_disp),
						.clk(clk),
						.rst(rst));
	
	hex7seg disp0 (.in(meter_disp[3:0]),.out(display[6:0]));
	hex7seg disp1 (.in(meter_disp[7:4]),.out(display[13:7]));
	hex7seg disp2 (.in(meter_disp[11:8]),.out(display[20:14]));
	hex7seg disp3 (.in(meter_disp[15:12]),.out(display[27:21]));
	hex7seg disp4 (.in(meter_disp[19:16]),.out(display[34:28]));
	hex7seg disp5 (.in(meter_disp[23:20]),.out(display[41:35]));
	hex7seg disp6 (.in(meter_disp[27:24]),.out(display[48:42]));
	hex7seg disp7 (.in(meter_disp[31:28]),.out(display[55:49]));

endmodule