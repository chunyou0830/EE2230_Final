`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:49:45 06/16/2015 
// Design Name: 
// Module Name:    RAM_signal_converter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module RAM_signal_converter(
	clk,
	rst,
	RAM_10_bit,
   RAM_64_bit,
   data,
	get_next_data,
	a,
	RAM_64_bit_next
    );

	input clk;
	input rst;
	output get_next_data;
	output a;
	output RAM_64_bit_next;
	input  [9:0]RAM_10_bit;
	output reg [63:0]RAM_64_bit;
	output reg [63:0]data;

	reg [5:0] extend_0,extend_1,extend_2,extend_3,extend_4,extend_5,extend_6,extend_7,extend_8,extend_9;
	reg [2:0] get_next_data,get_next_data_next;
	reg [63:0]RAM_64_bit_next;
	reg data_choice;
	reg a;

	//extend the 10 bit data
	always @*
	begin
		if (RAM_10_bit[9] == 1'b0)
			extend_9 = {RAM_10_bit[9],5'd0};
		else 
			extend_9 = {RAM_10_bit[9],5'd31};

		if (RAM_10_bit[8] == 1'b0)
			extend_8 = {RAM_10_bit[8],5'd0};
		else 
			extend_8 = {RAM_10_bit[8],5'd31};

		if (RAM_10_bit[7] == 1'b0)
			extend_7 = {RAM_10_bit[7],5'd0};
		else 
			extend_7 = {RAM_10_bit[7],5'd31};

		if (RAM_10_bit[6] == 1'b0)
			extend_6 = {RAM_10_bit[6],5'd0};
		else 
			extend_6 = {RAM_10_bit[6],5'd31};

		if (RAM_10_bit[5] == 1'b0)
			extend_5 = {RAM_10_bit[5],5'd0};
		else 
			extend_5 = {RAM_10_bit[5],5'd31};

		if (RAM_10_bit[4] == 1'b0)
			extend_4 = {RAM_10_bit[4],5'd0};
		else 
			extend_4 = {RAM_10_bit[4],5'd31};

		if (RAM_10_bit[3] == 1'b0)
			extend_3 = {RAM_10_bit[3],5'd0};
		else 
			extend_3 = {RAM_10_bit[3],5'd31};

		if (RAM_10_bit[2] == 1'b0)
			extend_2 = {RAM_10_bit[2],5'd0};
		else 
			extend_2 = {RAM_10_bit[2],5'd31};

		if (RAM_10_bit[1] == 1'b0)
			extend_1 = {RAM_10_bit[1],5'd0};
		else 
			extend_1 = {RAM_10_bit[1],5'd31};

		if (RAM_10_bit[0] == 1'b0)
			extend_0 = {RAM_10_bit[0],5'd0};
		else 
			extend_0 = {RAM_10_bit[0],5'd31};

	end

	always @*
	begin
		data = {2'b11,extend_9,extend_8,extend_7,extend_6,extend_5,extend_4,extend_3,extend_2,extend_1,extend_0,2'b11};
	end

	//output 64 bit data
	always @*
		if(a)
			RAM_64_bit_next = data;
		else 
			RAM_64_bit_next = RAM_64_bit;

	always @(posedge clk or posedge rst) 
	begin
		if (rst) 
			RAM_64_bit <= 64'd0;
		else 
			RAM_64_bit <= RAM_64_bit_next;		
	end

	//counter for get new data
	always @*
		get_next_data_next = get_next_data + 1'b1;

	always @(posedge clk or posedge rst) 
	begin
		if (rst) 
		begin
			get_next_data <= 3'd0;
			a <= 1'b1;
		end
		else if (get_next_data == 3'd5) 
		begin
			get_next_data <= 3'd0;
			a <= 1'b1;
		end
		else 
		begin
			get_next_data <= get_next_data_next;
			a <= 1'b0;
		end

	end


endmodule
