module meter_wrapper(
	display,
	data_in
);

	output wire [6:0] display [8];
	input	[31:0]	data_in;
	
	hex7seg disp0 (.in(data_in[3:0]),.out(display[0]));
	hex7seg disp1 (.in(data_in[7:4]),.out(display[1]));
	hex7seg disp2 (.in(data_in[11:8]),.out(display[2]));
	hex7seg disp3 (.in(data_in[15:12]),.out(display[3]));
	hex7seg disp4 (.in(data_in[19:16]),.out(display[4]));
	hex7seg disp5 (.in(data_in[23:20]),.out(display[5]));
	hex7seg disp6 (.in(data_in[27:24]),.out(display[6]));
	hex7seg disp7 (.in(data_in[31:28]),.out(display[7]));

endmodule