`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company      : NTHUEE
// Engineer     : Chun You, Yang
// Create Date  : 13:56 03/28/2012
// Module Name  : one_pulse 
// Project Name : Lab6_2
//////////////////////////////////////////////////////////////////////////////////
`include "global.v"
module one_pulse(
	clk,  // clock input
	rst, //active low reset
	in_trig, // input trigger
	out_pulse // output one pulse 
);

	// Declare I/Os
	input clk;  // clock input
	input rst; //active low reset
	input in_trig; // input trigger
	output out_pulse; // output one pulse 
	reg out_pulse; // output one pulse 

	// Declare internal nodes
	reg in_trig_delay;

// Buffer input 
always @(posedge clk or posedge rst)
	if (rst)
		in_trig_delay <= 1'b0; 
	else
		in_trig_delay <= in_trig;

// Pulse generation
assign out_pulse_next = in_trig & (~in_trig_delay);

always @(posedge clk or posedge rst)
	if (rst)
		out_pulse <=1'b0;
	else
		out_pulse <= out_pulse_next;

endmodule
