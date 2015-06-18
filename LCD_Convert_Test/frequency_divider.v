`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer		: Chun You, Yang
// Create Date	: 15:04 03/07/2012 
// Module Name	: frequency_divider
//////////////////////////////////////////////////////////////////////////////////
`include "global.v"
module frequency_divider(
	dip,
	clk_cnt,
	clk_scn,
	clk_fst,
	clk,
	rst
);

	output clk_cnt;
	output [1:0] clk_scn;
	output reg clk_fst;
	input clk;
	input rst;
	input [1:0] dip;

	reg clk_cnt;
	reg [1:0] clk_scn;
	reg [14:0] cnt_l;
	reg [6:0] cnt_h;
	reg [`FREQ_DIV_BIT-1:0] cnt_tmp;

	
	always @*
		if(dip==2'b00)
			clk_fst = cnt_l[0];
		else if(dip==2'b01)
			clk_fst = cnt_l[5];
		else if(dip==2'b10)
			clk_fst = cnt_h[1];
		else
			clk_fst = clk_cnt;
// Combinational block 
always @*
	cnt_tmp = {clk_cnt,cnt_h,clk_scn,cnt_l} + 1'b1;
	
// Sequential block 
always @(posedge clk or posedge rst)
	if (rst)
		{clk_cnt,cnt_h,clk_scn,cnt_l} <= `FREQ_DIV_BIT'b0;
	else
		{clk_cnt,cnt_h,clk_scn,cnt_l} <= cnt_tmp;

endmodule
