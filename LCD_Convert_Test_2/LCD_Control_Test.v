`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//////////////////////////////////////////////////////////////////////////////////
module LCD_Control_Test(
	clk,
	pb_in_rst,
	pb_in_ctrl,
	LCD_rst,
	LCD_cs,
	LCD_rw,
	LCD_di,
	LCD_data,
	LCD_en,
	col_in,
	row_scn,
	score_in,
	score_out,
	state_in,
	state_out,
	ftsd_ctl,
	display,
	add_vol,
	sub_vol,
	audio_appsel,
	audio_sysclk,
	audio_bck,
	audio_ws,
	audio_data,
	led
);
	input [5:0] score_in;
	input [2:0] state_in;
	output [5:0] score_out;
	output [2:0] state_out;
	wire [3:0] game_state;
	output [15:0] led;

	input clk;
	input pb_in_rst;
	wire rst;
	assign rst = ~pb_in_rst;
	input pb_in_ctrl;
	wire pb_ctrl;
	wire clk_div;
	output LCD_rst;
	output [1:0] LCD_cs;
	output LCD_rw;
	output LCD_di;
	output [7:0] LCD_data;
	output LCD_en;
	output [3:0] ftsd_ctl;
	output [14:0] display;
	wire [7:0] score;
	wire [3:0] tens_digit, units_digit, tens_digit_2, units_digit_2;
	wire [5:0] ftsd;
	wire [1:0] scan_clk;
	wire buffer, clk_debounce;
	output [3:0] row_scn;
	input [3:0] col_in;
	wire pad_pressed;
	wire ctrl_pressed;
	wire [3:0] pad_key;

	wire [3:0] addr;
	wire [9:0] data_out;
	wire [63:0] conv_data;
	wire out_valid;
	wire [7:0] ram_data_out;
	
	wire clk_1;
	wire clk_100;
	wire clk_6;
	wire clk_3;
	
	wire [99:0] game_table;

clock_divider #(
    .half_cycle(200),
    .counter_width(8)
	) clk100K (
	.rst_n(pb_in_rst),
	.clk(clk),
	.clk_div(clk_div)
);

clock_generator clk_gen(
	.clk(clk),
	.rst(rst),
	.clk_1(clk_1),
	.clk_100(clk_100),
	.clk_6(clk_6),
	.clk_3(clk_3)
);

SystemState sysStat(
	.pb_ctl(pb_ctrl),
	.stat_game(game_state),
	.stat_sync(state_in),
	.stat_out(state_out),
	.rst(rst),
	.clk_1(clk_1),
	.clk_100(clk_100),
	.led(led)
);

keypad_scan pad_scn(
	.clk(clk_div),
	.rst(rst),
	.row_scn(row_scn),
	.col_in(col_in),
	.key(pad_key),
	.pressed(pad_pressed)
);

one_pulse one_pulse(
	.clk(clk_100),  // clock input
	.rst(rst), //active low reset
	.in_trig(pad_pressed), // input trigger
	.out_pulse(ctrl_pressed) // output one pulse 
);

push_button pb_proc_ctrl(
	.clk(clk_100),
	.rst(rst),
	.pb_in(pb_in_ctrl),
	.pb_out(),
	.debounced(pb_ctrl)
);
//assign pb_ctrl = ~pb_in_ctrl ;
GameRAMControll game_ctrl(
	.clk_40M(clk_1),
	.clk_6(clk_100),
	.clk_1(clk_3),
	.rst(rst),
 	.system_status(state_out),
	.pad_key(pad_key),
	.pad_pressed(ctrl_pressed),
	.game_addLine(1'b0),
	.game_sendLine(),
	.game_table_output(game_table),
	.state(game_state),
	.score(score)
);

assign score_out = score[5:0];

binary_to_BCD BCD_converter(
	.A(score),
	.ONES(units_digit),
	.TENS(tens_digit),
	.HUNDREDS()
);

binary_to_BCD BCD_converter_send(
	.A({2'b00,score_in}),
	.ONES(units_digit_2),
	.TENS(tens_digit_2),
	.HUNDREDS()
);

wire [5:0] out0, out1, out2, out3;

ftsdDisplayChoose ftsd_ctrl(
	.sys_status(state_out),
	.score_self_bcd({tens_digit,units_digit}),
	.score_send_bcd({tens_digit_2,units_digit_2}),
	.score_self(score),
	.score_send(score_in),
	.out0(out0),
	.out1(out1),
	.out2(out2),
	.out3(out3)
);

scan_ctl scan_control(
	.in0(out0),
	.in1(out1),
	.in2(out2),
	.in3(out3),
	.ftsd_ctl_en(scan_clk),
	.ftsd_ctl(ftsd_ctl),
	.ftsd_in(ftsd)
);

ftsd displayer(
	.in(ftsd),
	.display(display)
);

freqdiv freqdiv(
	.clk_40M(clk),
	.rst(rst),
	.clk_1(buffer),
	.clk_debounce(clk_debounce),
	.clk_ftsd_scan(scan_clk)
);

RAM_ctrl ram_c (
  .game_table(game_table), // CY_ADD
  .clk(clk_div),
  .rst_n(pb_in_rst),
  .change(1'b1),
  .en(en),
  .data_out(ram_data_out),
  .data_valid(out_valid)
);


LCD_control LCD_ctrl (
    .clk(clk_div),
    .rst_n(pb_in_rst),
    .data(ram_data_out),
    .data_valid(out_valid),
    .LCD_di(LCD_di),
    .LCD_rw(LCD_rw),
    .LCD_en(LCD_en),
    .LCD_rst(LCD_rst),
    .LCD_cs(LCD_cs),
    .LCD_data(LCD_data),
    .en_tran(en)
);


// Music Related

	 input add_vol,sub_vol;
	 output audio_appsel;//playing mode selection
	 output audio_sysclk;//control clock for DAC(from crystal)
	 output audio_bck;//bit clock of audio data(5MHz)
	 output audio_ws;//left/right parallel to serial control 
	 output audio_data;//serial output audio data


	 wire [15:0]audio_in_left,audio_in_right; 
	 wire clk4Hz;
	 wire [15:0]volumn;
	 wire add_vol_1,sub_vol_1;
	 wire [19:0]sound;

debounce_circuit add_volumn(
	.clk(clk_100),
	.rst(rst),
	.pb_in(add_vol),
	.pb_debounced(add_vol_1)
);

debounce_circuit sub_volumn(
	.clk(clk_100),
	.rst(rst),
	.pb_in(sub_vol),
	.pb_debounced(sub_vol_1)
);

buzzer_control buzzer(
		.clk(clk),//clk from crystal
		.rst(rst),//active low reset
		.note_div(sound),//div for note generation
		.audio_left(audio_in_left),//left sound audio
		.audio_right(audio_in_right),//right sound audio
		.volumn(volumn)
	 );


	 
	 speaker_control speak_con(
		.clk(clk),
		.rst(rst),
		.audio_in_left(audio_in_left),
		.audio_in_right(audio_in_right),
		.audio_appsel(audio_appsel),
		.audio_sysclk(audio_sysclk),
		.audio_bck(audio_bck),
		.audio_ws(audio_ws),
		.audio_data(audio_data)
	 );

	 	volumn_counter volumn_counter(
			.clk(clk_1),
			.rst(rst),
			.volumn(volumn),
			.increase_volumn(add_vol_1),
			.decrease_volumn(sub_vol_1)
	);
	
	sound_counter sound_counter(
			.clk(clk4Hz),
			.rst(rst),
			.sound(sound)
	);
	
	 clk_generator clk_gener(
		.clk(clk),
	   .rst(rst),
	   .clk_4Hz(clk4Hz),
		.clk_100Hz(clk100Hz)
	 );

endmodule
