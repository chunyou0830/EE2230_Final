`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:58:45 03/18/2015 
// Design Name: 
// Module Name:    prelab 
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
module control_volumn(
    q,//counter output
	 clk,//global clock
	 rst_n,//active low reset 
	 sound
    );
	 

	 output reg [19:0]sound;
	 output reg[7:0]q;   
	 input clk;
	 input rst_n;
	 reg [7:0]q_tmp;
	 
	 //combinational logic
	 
	 always @*
			q_tmp = q+8'd1;
	
		 		
	 //flip flops
	 always @(posedge clk or negedge rst_n)
	 if(~rst_n)
			q<=8'd0;
	 else if(q==8'd15)
			q<=8'd0;
	 else
			q<=q_tmp;

	 always@*
		if(q==8'd0)
			sound=20'd90909;
		else if(q==8'd1)
			sound=20'd81632;
		else if(q==8'd2)
			sound=20'd76628;
		else if(q==8'd3)
			sound=20'd68259;
		else if(q==8'd4)
			sound=20'd60606;
		else if(q==8'd5)
			sound=20'd57306;
		else if(q==8'd6)
			sound=20'd51020;
		else if(q==8'd7)
			sound=20'd45454;
		else if(q==8'd8)
			sound=20'd40485;
		else if(q==8'd9)
			sound=20'd38167;
		else if(q==8'd10)
			sound=20'd34013;
		else if(q==8'd11)
			sound=20'd30303;
		else if(q==8'd12)
			sound=20'd28653;
		else if(q==8'd13)
			sound=20'd25510;
		else if(q==8'd14)
			sound=20'd22727;
		else if(q==8'd15)
			sound=20'd20242;
	
	 endmodule 
