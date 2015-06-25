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
module volumn_counter(
	 clk,//global clock
	 rst,//active low reset 
	 volumn,
    increase_volumn,
	 decrease_volumn
    );
	 
	 input increase_volumn,decrease_volumn;
	 output reg [15:0]volumn;
	 input clk;
	 input rst;
	 reg [7:0]volumn_value_tmp;
	 reg[7:0]volumn_value;   
	 
	 //combinational logic
	 
	 always @*
		if(increase_volumn)
			volumn_value_tmp = volumn_value+8'd1;
		else if(decrease_volumn)
			volumn_value_tmp = volumn_value-8'd1;
		else
		   volumn_value_tmp = volumn_value;
		
		 		
	 //flip flops
	 always @(posedge clk or posedge rst)
	 if(rst)
			volumn_value<=8'd0;
	 else if(increase_volumn&&volumn_value==8'd15)
			volumn_value<=4'd15;
	 else if(decrease_volumn&&volumn_value==8'd0)
			volumn_value<=8'd0;
	 else
			volumn_value<=volumn_value_tmp;


	 always@*
	  if(volumn_value==8'd15)
			begin
				volumn=16'h8000+30000;
			end
	  else if(volumn_value==8'd14)
			begin
				volumn=16'h8000+28000;
			end
	  else if(volumn_value==8'd13)
			begin
				volumn=16'h8000+26000;
			end
	  else if(volumn_value==8'd12)
			begin
				volumn=16'h8000+24000;
			end
	  else if(volumn_value==8'd11)
			begin
				volumn=16'h8000+22000;
			end
     else if(volumn_value==8'd10)
			begin
				volumn=16'h8000+20000;
			end			
	  else if(volumn_value==8'd9)
			begin
				volumn=16'h8000+18000;
			end		
	  else if(volumn_value==8'd8)
			begin
				volumn=16'h8000+16000;
			end			
	  else if(volumn_value==8'd7)
			begin
				volumn=16'h8000+14000;
			end	
	  else if(volumn_value==8'd6)
			begin
				volumn=16'h8000+12000;
			end		
	  else if(volumn_value==8'd5)
			begin
				volumn=16'h8000+10000;
			end	
	  else if(volumn_value==8'd4)
			begin
				volumn=16'h8000+8000;
			end	
	  else if(volumn_value==8'd3)
			begin
				volumn=16'h8000+6000;
			end	
	  else if(volumn_value==8'd2)
			begin
				volumn=16'h8000+4000;
			end		
	  else if(volumn_value==8'd1)
			begin
				volumn=16'h8000+2000;
			end	
	  else
				volumn=16'h8000;
	 
	
	 endmodule 
