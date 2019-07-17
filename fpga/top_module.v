module top_module (
	// Inputs
	CLOCK_50,
	CLOCK_27,
	KEY,

	AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,

	I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,
	LEDR,
	LEDG,
	I2C_SCLK,
	SW,
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input				CLOCK_27;
input		[3:0]	KEY;
input		[3:0]	SW;

input				AUD_ADCDAT;

// Bidirectionals
inout				AUD_BCLK;
inout				AUD_ADCLRCK;
inout				AUD_DACLRCK;

inout				I2C_SDAT;

// Outputs
output				AUD_XCK;
output				AUD_DACDAT;
output [17:0]				LEDR;
output	[7:0]			LEDG;
output				I2C_SCLK;
output	[6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire					audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;

wire		[31:0]	left_channel_audio_out_filtered;
wire		[31:0]	right_channel_audio_out_filtered;

wire		[31:0]	left_channel_distortion;
wire		[31:0]	left_channel_tremolo;


wire		[31:0]	left_channel_audio_out_raw;
wire		[31:0]	right_channel_audio_out_raw;
wire				write_audio_out;

// Internal Registers

reg [18:0] delay_cnt;
wire delay;
reg snd;
wire rst_sync;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge CLOCK_50)
	if(delay_cnt == delay) begin
		delay_cnt <= 0;
		snd <= !snd;
	end else delay_cnt <= delay_cnt + 1;

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign delay = {SW[3:0], 15'd3000};

wire [31:0] sound = (SW == 0) ? 0 : snd ? 32'd10000000 : -32'd10000000;


assign read_audio_in			= audio_in_available & audio_out_allowed;

assign left_channel_audio_out_raw	= left_channel_audio_in;
assign right_channel_audio_out_raw		= right_channel_audio_in;
assign write_audio_out					= audio_in_available & audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

 rst_sync reset(  .rst_in(KEY[0]),
						.rst_out(rst_sync),
						.clk(CLOCK_50));
 
// delay  my_delay_right(	.x(left_channel_audio_out_raw),
//						.y(left_channel_audio_out),
//						.rst(KEY[0]),
//						.CLK(CLOCK_50),
//						.options(4'b1000),// It only works with 4'b1000 so far
//						.en(SW[0]),
//						.debug({LEDR[0],LEDG[0]})	// It's not being used so far	
//					);
//					

filter1 nelson (.clock(CLOCK_50),
						.Xin(left_channel_audio_out_raw),
						.Y(left_channel_audio_out_filtered));
						

//						
//average_filter LPF(  .clk(CLOCK_50),
//							.rst(rst_sync),
//							.data_in(left_channel_audio_out_raw),
//							.data_out(),
//							.audio_ready(write_audio_out));

distortion my_distortion(	.x(left_channel_audio_out_filtered),
									.y(left_channel_distortion),
									.rst(rst_sync),
									.CLK(CLOCK_50),
									.indicator(LEDR[1]),
									.audio_ready(write_audio_out),
									.en(SW[1]));
									
									
 delay  my_delay_left(	.x(left_channel_tremolo),
								.y(left_channel_audio_out),
								.rst(rst_sync),
								.CLK(CLOCK_50),
								.en(SW[0]),
								.indicator(LEDG[1]),
								.debug({LEDR[0],LEDG[0]}),
								.audio_ready(write_audio_out));
								
tremolo my_tremolo(	.rst(rst_sync),
							.CLK(CLOCK_50),
							.x(left_channel_distortion),
							.y(left_channel_tremolo),
							.audio_ready(write_audio_out),
							.en(SW[2]),
							.indicator(LEDR[2]),
							.tri_wave(LEDR[17:15]));
 
 
 // DEBUG SECTION
 // The following part is only for debug purpuses
// meter_wrapper(.data_in(left_channel_audio_out),
//					.display({HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7}),
//					.clk(CLOCK_50),
//					.rst(rst_sync));
					
//hex7seg tri_debug (.in({1'b0,tri_wave}),.out(HEX7));
 
 //END OF DEBUG SECTION
 
Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50						(CLOCK_50),
	.reset						(~KEY[0]),

	.clear_audio_in_memory		(),
	.read_audio_in				(read_audio_in),
	
	.clear_audio_out_memory		(),
	.left_channel_audio_out		(left_channel_audio_out),
	.right_channel_audio_out	(left_channel_audio_out),
	.write_audio_out			(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_ADCLRCK				(AUD_ADCLRCK),
	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs
	.audio_in_available			(audio_in_available),
	.left_channel_audio_in		(left_channel_audio_in),
	.right_channel_audio_in		(right_channel_audio_in),

	.audio_out_allowed			(audio_out_allowed),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT)

);

avconf #(.USE_MIC_INPUT(1)) avc (
	.I2C_SCLK					(I2C_SCLK),
	.I2C_SDAT					(I2C_SDAT),
	.CLOCK_50					(CLOCK_50),
	.reset						(~KEY[0])
);

endmodule
