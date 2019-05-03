module filter1(input clock,
                input signed [W-1:0]Xin,
                output wire signed [W-1:0]Y);
    
	parameter N = 8;
	parameter W = 32;
	parameter H = 8;

  reg signed [W+H-1:0] y[N];
  wire signed [H-1:0] h[N];
  
  assign h[0] = -2;
  assign h[1] = 8;
  assign h[2] = -35;
  assign h[3] = 157;
  assign h[4] = 157;
  assign h[5] = -35;
  assign h[6] = 8;
  assign h[7] = -2;
  assign Y = y[N-1]>>H;
  
  always @(posedge clock)begin
      y[0] <= h[0]*Xin;
		for(integer i = 1; i < N; i = i+1)
		   y[i] <= y[i-1]+h[N-1-i]*Xin;
  end
endmodule