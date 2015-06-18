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
	LCD_en
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

	wire [3:0] addr;
	wire [9:0] data_out;
	wire [63:0] conv_data;
	wire clk_1, clk_100;
clock_generator clk_gen(
	.clk(clk),
	.rst(rst),
	.clk_1(clk_1),
	.clk_100(clk_100)
);

  clock_divider #(
    .half_cycle(200),         // half cycle = 200 (divided by 400)
    .counter_width(8)         // counter width = 8 bits
  ) clk100K (
  .rst_n(pb_in_rst),
  .clk(clk),
  .clk_div(clk_div)
);

FakeDispRAMData data_gen(
	.rst(rst),
	.clk_40M(clk),
	.clk_1(clk_1),
	.addr(addr),
	.data_out(data_out)
);

RAM_control RAM_ctrl (
    .clk(clk_div),
    .rst_n(pb_in_rst),
    .change(1'b1),
    .en(en),
    .input_data(conv_data),
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

RAM_signal_converter(
	.clk(clk_1),
	.rst(rst),
	.RAM_10_bit(data_out),
	.RAM_64_bit(conv_data),
	.data(),//X
	.get_next_data(),//X
	.a(),//X
	.RAM_64_bit_next()//X
);
endmodule
