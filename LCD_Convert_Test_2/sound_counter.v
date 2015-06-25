`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:29 06/13/2015 
// Design Name: 
// Module Name:    sound_counter 
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
module sound_counter(
		clk,
		rst,
		sound
    );
	
	input clk;
	input rst;
	output reg [19:0]sound;
	
	reg [5:0]count,count_next;
	
	
	always @*
		count_next = count + 1'b1;

    always @(posedge clk or posedge rst) 
    begin
    	if (rst) 
    	begin
    		count <= 6'd0;
    	end
		else if(count == 6'd63)
		begin 
			count <= 6'd0;
		end
    	else 
    	begin
    		count <= count_next;	
    	end
    end

	always@*	
	begin
		case(count)
		6'd0:  sound = 20'd30303;
		6'd1:  sound = 20'd30303;
		6'd2:  sound = 20'd40486;
		6'd3:  sound = 20'd38167;
		6'd4:  sound = 20'd34014;
		6'd5:  sound = 20'd34014;
		6'd6:  sound = 20'd38167;
		6'd7:  sound = 20'd40486;
		6'd8:  sound = 20'd45455;
		6'd9:  sound = 20'd45455;
		6'd10: sound = 20'd45455;
		6'd11: sound = 20'd38167;
		6'd12: sound = 20'd30303;
		6'd13: sound = 20'd30303;
		6'd14: sound = 20'd34014;
		6'd15: sound = 20'd38167;
		6'd16: sound = 20'd40486;
		6'd17: sound = 20'd40486;
		6'd18: sound = 20'd0;
		6'd19: sound = 20'd38167;
		6'd20: sound = 20'd34014;
		6'd21: sound = 20'd34014;
		6'd22: sound = 20'd30303;
		6'd23: sound = 20'd30303;
		6'd24: sound = 20'd38167;
		6'd25: sound = 20'd38167;
		6'd26: sound = 20'd45455;
		6'd27: sound = 20'd45455;
		6'd28: sound = 20'd45455;
		6'd29: sound = 20'd45455;
		6'd30: sound = 20'd0;
		6'd31: sound = 20'd0;
		6'd32: sound = 20'd0;
		6'd33: sound = 20'd34014;
		6'd34: sound = 20'd34014;
		6'd35: sound = 20'd28653;
		6'd36: sound = 20'd22727;
		6'd37: sound = 20'd22727;
		6'd38: sound = 20'd25510;
		6'd39: sound = 20'd28653;
		6'd40: sound = 20'd30303;
		6'd41: sound = 20'd30303;
		6'd42: sound = 20'd0;
		6'd43: sound = 20'd38167;
		6'd44: sound = 20'd30303;
		6'd45: sound = 20'd30303;
		6'd46: sound = 20'd34014;
		6'd47: sound = 20'd38167;
		6'd48: sound = 20'd40486;
		6'd49: sound = 20'd40486;
		6'd50: sound = 20'd40486;
		6'd51: sound = 20'd38167;
		6'd52: sound = 20'd34014;
		6'd53: sound = 20'd34014;
		6'd54: sound = 20'd30303;
		6'd55: sound = 20'd30303;
		6'd56: sound = 20'd38167;
		6'd57: sound = 20'd38167;
		6'd58: sound = 20'd45455;
		6'd59: sound = 20'd45455;
		6'd60: sound = 20'd45455;
		6'd61: sound = 20'd45455;
		6'd62: sound = 20'd0;
		6'd63: sound = 20'd0;
		endcase
	end

endmodule
