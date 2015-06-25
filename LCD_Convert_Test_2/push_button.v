`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company		: NTHUEE
// Engineer		: Chun You, Yang
// Create Date	: 10:38 04/12/2015 
// Module Name	: push_button 
// Project Name	: Lab6_2
//////////////////////////////////////////////////////////////////////////////////
module push_button(
	clk,
	rst,
	pb_in,
	pb_out,
	debounced
);

	//Defs
	input clk;
	input rst;
	input pb_in;
	output pb_out;
	output reg debounced;
	
	wire deb_to_op;
	
	//Module Connection
debounce_circuit PB_1(
	.clk(clk),
	.rst(rst),
	.pb_in(pb_in),
	.pb_debounced(deb_to_op)
);

one_pulse PB_2(
	.clk(clk),
	.rst(rst),
	.in_trig(debounced),
	.out_pulse(pb_out)
);

always@*
	debounced=deb_to_op;

endmodule
