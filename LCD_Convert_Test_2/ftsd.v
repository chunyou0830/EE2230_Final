`timescale 1ns / 1ps
//************************************************************************
// Filename      : ftsd.v
// Author        : Hsi-Pin Ma
// Function      : 14-segment display decoder
// Last Modified : Date: 2012-04-02
// Revision      : Revision: 1
// Copyright (c), Laboratory for Reliable Computing (LaRC), EE, NTHU
// All rights reserved
//************************************************************************
`include "global.v"
module ftsd(
  in,  // binary input
  display // 14-segment display output
);

// Declare I/Os
input [`BCD_BIT_WIDTH-1:0] in; // binary input
output [`FTSD_BIT_WIDTH-1:0] display; // 14-segment display out

// Declare internal nodes
reg [`FTSD_BIT_WIDTH-1:0] display; 

// Combinatioanl Logic
always @(in)
  case (in)
    `BCD_BIT_WIDTH'd0: display = `FTSD_ZERO;
    `BCD_BIT_WIDTH'd1: display = `FTSD_ONE;
    `BCD_BIT_WIDTH'd2: display = `FTSD_TWO;
    `BCD_BIT_WIDTH'd3: display = `FTSD_THREE;
    `BCD_BIT_WIDTH'd4: display = `FTSD_FOUR;
    `BCD_BIT_WIDTH'd5: display = `FTSD_FIVE;
    `BCD_BIT_WIDTH'd6: display = `FTSD_SIX;
    `BCD_BIT_WIDTH'd7: display = `FTSD_SEVEN;
    `BCD_BIT_WIDTH'd8: display = `FTSD_EIGHT;
    `BCD_BIT_WIDTH'd9: display = `FTSD_NINE;
    `BCD_BIT_WIDTH'd10: display = `FTSD_A;
    `BCD_BIT_WIDTH'd11: display = `FTSD_B;
    `BCD_BIT_WIDTH'd12: display = `FTSD_C;
    `BCD_BIT_WIDTH'd13: display = `FTSD_D;
    `BCD_BIT_WIDTH'd14: display = `FTSD_E;
    `BCD_BIT_WIDTH'd15: display = `FTSD_F;
    default: display = 15'd0;
  endcase
  
endmodule
