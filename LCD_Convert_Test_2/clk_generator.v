`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:26:16 04/12/2015 
// Design Name: 
// Module Name:    clk_generator 
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
`include "global.v"
module clk_generator(
    clk,
	 rst,
	 clk_4Hz,
	 clk_100Hz
    );
    
	 input clk;
	 input rst;
	 output reg clk_4Hz;
	 output reg clk_100Hz;
	 
	 reg [17:0]count_200K,count_200K_next;
	 reg [22:0]count_5M,count_5M_next;
	 reg clk_4Hz_next;
	 reg clk_100Hz_next;
	 
	 
	 always@*
	 begin
	 if(count_200K==199999)
	 begin
	 count_200K_next=18'd0;
	 clk_100Hz_next=~clk_100Hz;
	 end
	 
	 else
	 begin
	 count_200K_next=count_200K+1'b1;
	 clk_100Hz_next=clk_100Hz;
	 end
	 end
	 
	 always@(posedge clk or posedge rst)
	 begin 
	 
	 if(rst)
    begin
    count_200K<=18'd0;
    clk_100Hz<=1'b0;
	 end
	 else
	 begin
	 count_200K<=count_200K_next;
	 clk_100Hz<=clk_100Hz_next;
	 end
	 end
	 
	 always@*
	 begin 
	 if(count_5M==4999999)
	 begin
	 count_5M_next=23'd0;
	 clk_4Hz_next=~clk_4Hz;
	 end
	 
	 else
	 begin
	 count_5M_next=count_5M+1'b1;
	 clk_4Hz_next=clk_4Hz;
	 end
	 end
	 
	 always@(posedge clk or posedge rst)
	 begin
	 if(rst)
    begin
    count_5M<=23'd0;
    clk_4Hz<=1'b0;
	 end
	 else
	 begin
	 count_5M<=count_5M_next;
	 clk_4Hz<=clk_4Hz_next;
	 end
	 end
endmodule
