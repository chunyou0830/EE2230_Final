`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company      : NTHUEE
// Engineer     : Chun You, Yang
// Create Date  : 01:08 04/12/2015
// Module Name  : clock_generator 
// Project Name : Lab5_2
//////////////////////////////////////////////////////////////////////////////////
`include "global.v"
module clock_generator(
	clk,
	rst,
	clk_1,
	clk_100
);

// Declare I/Os
input clk;
input rst;
output reg clk_1;
output reg clk_100;

// Declare internal nodes
reg [`DIV_BY_20M_BIT_WIDTH-1:0] count_20M, count_20M_next;
reg [`DIV_BY_200K_BIT_WIDTH-1:0] count_200K, count_200K_next;
reg clk_1_next;
reg clk_100_next;

// *******************
// Clock divider for 1 Hz
// *******************
// Clock Divider: Counter operation
always @*
	if (count_20M == `DIV_BY_20M-1)
	begin
		count_20M_next = `DIV_BY_20M_BIT_WIDTH'd0;
		clk_1_next = ~clk_1;
	end
	else
	begin
		count_20M_next = count_20M + 1'b1;
		clk_1_next = clk_1;
	end

// Counter flip-flops
always @(posedge clk or posedge rst)
	if (rst)
	begin
		count_20M <=`DIV_BY_20M_BIT_WIDTH'b0;
		clk_1 <=1'b0;
	end
	else
	begin
		count_20M <= count_20M_next;
		clk_1 <= clk_1_next;
	end

// *********************
// Clock divider for 100 Hz
// *********************
// Clock Divider: Counter operation 
always @*
	if (count_200K == `DIV_BY_200K-1)
	begin
		count_200K_next = `DIV_BY_200K_BIT_WIDTH'd0;
		clk_100_next = ~clk_100;
	end
	else
	begin
		count_200K_next = count_200K + 1'b1;
		clk_100_next = clk_100;
	end


// Counter flip-flops
always @(posedge clk or posedge rst)
	if (rst)
	begin
		count_200K <=`DIV_BY_200K_BIT_WIDTH'b0;
		clk_100 <=1'b0;
	end
	else
	begin
		count_200K <= count_200K_next;
		clk_100 <= clk_100_next;
	end

endmodule
