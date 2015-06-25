`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:35 05/14/2015 
// Design Name: 
// Module Name:    speaker_control 
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
module speaker_control(
	 clk,
	 rst,
	 audio_in_left,
	 audio_in_right,
	 audio_appsel,
	 audio_sysclk,
	 audio_bck,
	 audio_ws,
	 audio_data
    );
	 input clk;
	 input rst;
	 input [15:0]audio_in_left,audio_in_right;
	 output reg audio_data;
	 output reg audio_bck,audio_ws; 
	 output audio_sysclk,audio_appsel;
	 
	 reg [2:0]count_4,count_4_next;
	 reg audio_bck_next;
	 reg [7:0]count_128,count_128_next;
	 reg audio_ws_next;
	 reg [3:0]q,q_tmp;
	 reg [31:0]audio_data_tmp;
	 reg [4:0]audio_data_next,audio_data_next2;
	 
	 assign audio_appsel=1'b1;
	 assign audio_sysclk=clk;
	 
	 //5MHz
	 always@*
		if(count_4==3)
			begin
				count_4_next=3'd0;
				audio_bck_next=~audio_bck;
			end 
		else 
			begin 
				count_4_next=count_4+1'b1;
				audio_bck_next=audio_bck;
			end
	 always@(posedge clk or posedge rst)
		if(rst)
			begin 
				count_4<=3'b0;
				audio_bck<=1'b0;
			end
		else 
			begin 
				count_4<=count_4_next;
				audio_bck<=audio_bck_next;
			end
			
	  //(5/32)MHz
	   always@*
		if(count_128==127)
			begin
				count_128_next=8'd0;
				audio_ws_next=~audio_ws;
			end 
		else 
			begin 
				count_128_next=count_128+1'b1;
				audio_ws_next=audio_ws;
			end
	 always@(posedge clk or posedge rst)
		if(rst)
			begin 
				count_128<=8'b0;
				audio_ws<=1'b0;
			end
		else 
			begin 
				count_128<=count_128_next;
				audio_ws<=audio_ws_next;
			end
			//input data(5/32MHz)
	 always@(posedge audio_ws or posedge rst)
				if(rst)
				audio_data_tmp<=32'b0;
				else
				audio_data_tmp<={audio_in_right,audio_in_left};

			
			//output data(5MHz)
	 always@*
			audio_data_next2 = audio_data_next-1'b1;
			
	 always@(posedge audio_bck or posedge rst)
			if(rst)
			      begin 
						audio_data_next<=5'd31;
					   audio_data<=1'b0;
					end
			else if (audio_data_next==5'd0)
					audio_data_next<=5'd31;
			else 
				begin 
					audio_data<=audio_data_tmp[audio_data_next];
					audio_data_next<=audio_data_next2;
					 
				end
	
	
	  
endmodule
