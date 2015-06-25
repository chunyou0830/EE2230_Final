`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//////////////////////////////////////////////////////////////////////////////////
module LCD_Control_Test(
	clk,
	pb_in_rst,
	LCD_rst,
	LCD_cs,
	LCD_rw,
	LCD_di,
	LCD_data,
	LCD_en,
	col_in,
	row_scn,
	state_output,
	ftsd_ctl,
	display
	//led
);
   output [3:0]ftsd_ctl;
	output [14:0]display;
	output [2:0]state_output;
	input clk;
	input pb_in_rst;
	wire rst;
	assign rst = ~pb_in_rst;
	wire clk_div;
	output LCD_rst;
	output [1:0] LCD_cs;
	output LCD_rw;
	output LCD_di;
	output [7:0] LCD_data;
	output LCD_en;
	//output led;

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
wire [1:0]scan_clk;
wire buffer,clk_debounce;
  clock_divider #(
    .half_cycle(200),         // half cycle = 200 (divided by 400)
    .counter_width(8)         // counter width = 8 bits
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

keypad_scan pad_scn(
	.clk(clk_div),
	.rst(rst),
	.row_scn(row_scn),
	.col_in(col_in),
	.key(pad_key),
	.pressed(pad_pressed)
);

/*reg timer_clk;

always @*
	if(pad_pressed)
		timer_clk = clk_100;
	else 
		timer_clk = clk_1;
assign led = timer_clk;*/

one_pulse one_pulse(
	.clk(clk_100),  // clock input
	.rst(rst), //active low reset
	.in_trig(pad_pressed), // input trigger
	.out_pulse(ctrl_pressed) // output one pulse 
);

GameRAMControll game_ctrl(
	.clk_40M(clk_1),
	.clk_6(clk_100),
	.clk_1(clk_3),
	.rst(rst),
	.pad_key(pad_key),
	.pad_pressed(ctrl_pressed),
	.game_addLine(1'b0),
	.game_sendLine(),
	.game_table_output(game_table),
	.state_output(state_output),
	.score(score)
);

binary_to_BCD BCD_converter(
	.A(score),
   .ONES(units_digit),
	.TENS(tens_digit),
	.HUNDREDS()
);

scan_ctl scan_control(
	.in0(4'd0), // 1st input
   .in1(4'd0), // 2nd input
   .in2(tens_digit), // 3rd input
   .in3(units_digit),  // 4th input
   .ftsd_ctl_en(scan_clk), // divided clock for scan control
   .ftsd_ctl(ftsd_ctl), // ftsd display control signal 
   .ftsd_in(ftsd) // output to ftsd display
);

ftsd displayer(
	.in(ftsd),
	.display(display)
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
    .data(ram_data_out),           // memory value  
    .data_valid(out_valid),    // if data_valid = 1 the data is valid
    .LCD_di(LCD_di),
    .LCD_rw(LCD_rw),
    .LCD_en(LCD_en),
    .LCD_rst(LCD_rst),
    .LCD_cs(LCD_cs),
    .LCD_data(LCD_data),
    .en_tran(en)
);
endmodule
