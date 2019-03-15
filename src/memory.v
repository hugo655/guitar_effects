module	memory(
	WE,
	ADDR1,
	ADDR2,
	DO1,
	DO2,
	DI,
	CLK
);

parameter B = 15;
parameter T = 20000;

output reg [31:0] 	DO1,DO2;
input	   [31:0] 	DI;
input	   [B-1:0]	ADDR1, ADDR2;
input	   		CLK,WE;

memoria_2_port sth(
	.RA1(ADDR2),
	.RA2(ADDR1),
	.WA1( ? ), //tie-off in 0
	.WA2(ADDR2),
	.CLK(CLK),
	.WE1( ? ), // tie-off in 1
	.WE2(WE),
	.RO1(RO1_D01),
	.RO2(RO2_DO2)
);

always @(CLK)
begin
	DO1 <= RO2_DO2;
	D02 <= RO1_D01;
end

endmodule
