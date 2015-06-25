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
	clk_100,
	clk_6,
	clk_3
);

// Declare I/Os
input clk;
input rst;
output reg clk_1;
output reg clk_100;
output reg clk_6;
output reg clk_3;

// Declare internal nodes
reg [`DIV_BY_20M_BIT_WIDTH-1:0] count_20M, count_20M_next;
reg [`DIV_BY_200K_BIT_WIDTH-1:0] count_200K, count_200K_next;
reg [21:0] count_3333333,count_3333333_next;
reg [22:0] count_6666666,count_6666666_next;
reg clk_1_next;
reg clk_100_next;
reg clk_6_next;
reg clk_3_next;

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


// *******************
// Clock divider for 6 Hz
// *******************
// Clock Divider: Counter operation
always @*
	if (count_3333333 == 3333332)
	begin
		count_3333333_next = 22'd0;
		clk_6_next = ~clk_6;
	end
	else
	begin
		count_3333333_next = count_3333333 + 1'b1;
		clk_6_next = clk_6;
	end

// Counter flip-flops
always @(posedge clk or posedge rst)
	if (rst)
	begin
		count_3333333 <=22'b0;
		clk_6 <=1'b0;
	end
	else
	begin
		count_3333333 <= count_3333333_next;
		clk_6 <= clk_6_next;
	end
	// *******************
// Clock divider for 3 Hz
// *******************
// Clock Divider: Counter operation
always @*
	if (count_6666666 == 6666665)
	begin
		count_6666666_next = 23'd0;
		clk_3_next = ~clk_3;
	end
	else
	begin
		count_6666666_next = count_6666666 + 1'b1;
		clk_3_next = clk_3;
	end

// Counter flip-flops
always @(posedge clk or posedge rst)
	if (rst)
	begin
		count_6666666 <=23'b0;
		clk_3 <=1'b0;
	end
	else
	begin
		count_6666666 <= count_6666666_next;
		clk_3 <= clk_3_next;
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
