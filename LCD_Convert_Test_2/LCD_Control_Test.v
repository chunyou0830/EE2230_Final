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
<<<<<<< HEAD
	score_in,
	score_out,
	state_in,
	state_out,
	ftsd_ctl,
	display
);
	input [5:0] score_in;
	input [2:0] state_in;
	output [5:0] score_out;
	output [2:0] state_out;
	wire [3:0] game_state;

=======
	state_output,
	ftsd_ctl,
	display
	//led
);
   output [3:0]ftsd_ctl;
	output [14:0]display;
	output [2:0]state_output;
>>>>>>> origin/master
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
	//output led;
	output [3:0] ftsd_ctl;
	output [14:0] display;
	wire [7:0] score;
	wire [3:0] tens_digit, units_digit;
	wire [3:0] ftsd;
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
	wire [7:0]score; 
	wire [3:0]tens_digit,units_digit;
	wire [3:0]ftsd;
	
	wire [99:0] game_table;
<<<<<<< HEAD

clock_divider #(
    .half_cycle(200),
    .counter_width(8)
	) clk100K (
	.rst_n(pb_in_rst),
	.clk(clk),
	.clk_div(clk_div)
=======
wire [1:0]scan_clk;
wire buffer,clk_debounce;
  clock_divider #(
    .half_cycle(200),         // half cycle = 200 (divided by 400)
    .counter_width(8)         // counter width = 8 bits
  ) clk100K (
  .rst_n(pb_in_rst),
  .clk(clk),
  .clk_div(clk_div)
>>>>>>> origin/master
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
	.clk_100(clk_100)
);

keypad_scan pad_scn(
	.clk(clk_div),
	.rst(rst),
	.row_scn(row_scn),
	.col_in(col_in),
	.key(pad_key),
	.pressed(pad_pressed)
);

<<<<<<< HEAD
=======
/*reg timer_clk;

always @*
	if(pad_pressed)
		timer_clk = clk_100;
	else 
		timer_clk = clk_1;
assign led = timer_clk;*/

>>>>>>> origin/master
one_pulse one_pulse(
	.clk(clk_100),  // clock input
	.rst(rst), //active low reset
	.in_trig(pad_pressed), // input trigger
	.out_pulse(ctrl_pressed) // output one pulse 
);

/*push_button pb_proc_ctrl(
	.clk(clk_100),
	.rst(rst),
	.pb_in(pb_in_ctrl),
	.pb_out(),
	.debounced(pb_ctrl)
);*/
assign pb_ctrl = ~pb_in_ctrl ;
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
<<<<<<< HEAD
	.state(game_state),
=======
	.state_output(state_output),
>>>>>>> origin/master
	.score(score)
);

binary_to_BCD BCD_converter(
	.A(score),
<<<<<<< HEAD
	.ONES(units_digit),
=======
   .ONES(units_digit),
>>>>>>> origin/master
	.TENS(tens_digit),
	.HUNDREDS()
);

scan_ctl scan_control(
<<<<<<< HEAD
	.in0(4'd0),//Waiting to be conncected
	.in1(4'd0),
	.in2(tens_digit),
	.in3(units_digit),
	.ftsd_ctl_en(scan_clk),
	.ftsd_ctl(ftsd_ctl),
	.ftsd_in(ftsd)
=======
	.in0(4'd0), // 1st input
   .in1(4'd0), // 2nd input
   .in2(tens_digit), // 3rd input
   .in3(units_digit),  // 4th input
   .ftsd_ctl_en(scan_clk), // divided clock for scan control
   .ftsd_ctl(ftsd_ctl), // ftsd display control signal 
   .ftsd_in(ftsd) // output to ftsd display
>>>>>>> origin/master
);

ftsd displayer(
	.in(ftsd),
	.display(display)
<<<<<<< HEAD
);

freqdiv freqdiv(
	.clk_40M(clk),
	.rst(rst),
	.clk_1(buffer),
	.clk_debounce(clk_debounce),
	.clk_ftsd_scan(scan_clk)
=======
>>>>>>> origin/master
);


freqdiv freqdiv(
	.clk_40M(clk), // clock from the 40MHz oscillator
   .rst(rst), // low active reset
   .clk_1(buffer), // divided clock output
   .clk_debounce(clk_debounce), // clock control for debounce circuit
   .clk_ftsd_scan(scan_clk) // 
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
endmodule
