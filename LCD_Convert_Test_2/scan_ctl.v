`timescale 1ns / 1ps
//************************************************************************
// Filename      : scan_ctl.v
// Author        : Hsi-Pin Ma
// Function      : scan control for 14-segment display decoder
// Last Modified : Date: 2012-04-02
// Revision      : Revision: 1
// Copyright (c), Laboratory for Reliable Computing (LaRC), EE, NTHU
// All rights reserved
//************************************************************************
`include "global.v"
module scan_ctl(
  in0, // 1st input
  in1, // 2nd input
  in2, // 3rd input
  in3,  // 4th input
  ftsd_ctl_en, // divided clock for scan control
  ftsd_ctl, // ftsd display control signal 
  ftsd_in // output to ftsd display
);

// Declare I/Os
input [`BCD_BIT_WIDTH-1:0] in0,in1,in2,in3; // binary input control for the four digits 
input [1:0] ftsd_ctl_en; // divided clock for scan control
output [`BCD_BIT_WIDTH-1:0] ftsd_in; // Binary data 
output [`FTSD_NUM-1:0] ftsd_ctl; // scan control for 14-segment display

// Declare internal nodes
reg [`FTSD_NUM-1:0] ftsd_ctl; // scan control for 14-segment display (in the always block)
reg [`BCD_BIT_WIDTH-1:0] ftsd_in; // 14 segment display control (in the always block)

// 14-segment display scan control
always @*
  case (ftsd_ctl_en)
    2'b00: 
    begin
      ftsd_ctl=4'b0111;
		ftsd_in=in0;
    end
    2'b01: 
    begin
      ftsd_ctl=4'b1011;
      ftsd_in=in1;
    end
    2'b10: 
    begin
      ftsd_ctl=4'b1101;
      ftsd_in=in2;
    end
    2'b11: 
    begin
      ftsd_ctl=4'b1110;
      ftsd_in=in3;
    end
    default: 
    begin
      ftsd_ctl=4'b0000;
      ftsd_in=in0;
    end
  endcase
  


endmodule
