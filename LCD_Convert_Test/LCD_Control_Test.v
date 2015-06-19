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
	row_scn
);


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

	output [3:0] row_scn;
	input [3:0] col_in;
	wire pad_pressed;
	wire [3:0] pad_key;

	wire [3:0] addr;
	wire [9:0] data_out;
	wire [63:0] conv_data;
	wire out_valid;
	wire [7:0] ram_data_out;
	
	wire clk_1;

	wire [99:0] game_table;

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
	.clk_100()
);

keypad_scan pad_scn(
	.clk(clk_div),
	.rst(rst),
	.row_scn(row_scn),
	.col_in(col_in),
	.key(pad_key),
	.pressed(pad_pressed)
);

GameRAMControll game_ctrl(
	.clk_40M(clk),
	.clk_1(clk_1),
	.rst(rst),
	.pad_key(pad_key),
	.pad_pressed(pad_pressed),
	.game_addLine(1'b0),
	.game_sendLine(),
	.game_table_output(game_table)
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
