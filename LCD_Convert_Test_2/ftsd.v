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
input [5:0] in; // binary input
output [14:0] display; // 14-segment display out

// Declare internal nodes
reg [14:0] display; 

// Combinatioanl Logic
always @(in)
  case (in)
            `FONT_ZERO: display=`FTSD_ZERO;
            `FONT_ONE: display=`FTSD_ONE;
            `FONT_TWO: display=`FTSD_TWO;
            `FONT_THREE: display=`FTSD_THREE;
            `FONT_FOUR: display=`FTSD_FOUR;
            `FONT_FIVE: display=`FTSD_FIVE;
            `FONT_SIX: display=`FTSD_SIX;
            `FONT_SEVEN: display=`FTSD_SEVEN;
            `FONT_EIGHT: display=`FTSD_EIGHT;
            `FONT_NINE: display= `FTSD_NINE;
            `FONT_A: display=`FTSD_A;
            `FONT_B: display=`FTSD_B;
            `FONT_C: display=`FTSD_C;
            `FONT_D: display=`FTSD_D;
            `FONT_E: display=`FTSD_E;
            `FONT_F: display=`FTSD_F;
            `FONT_G: display=`FTSD_G;
            `FONT_H: display=`FTSD_H;
            `FONT_I: display=`FTSD_I;
            `FONT_J: display=`FTSD_J;
            `FONT_K: display=`FTSD_K;
            `FONT_L: display=`FTSD_L;
            `FONT_M: display=`FTSD_M;
            `FONT_N: display=`FTSD_N;
            `FONT_O: display=`FTSD_O;
            `FONT_P: display=`FTSD_P;
            `FONT_Q: display=`FTSD_Q;
            `FONT_R: display=`FTSD_R;
            `FONT_S: display=`FTSD_S;
            `FONT_T: display=`FTSD_T;
            `FONT_U: display=`FTSD_U;
            `FONT_V: display=`FTSD_V;
            `FONT_W: display=`FTSD_W;
            `FONT_X: display=`FTSD_X;
            `FONT_Y: display=`FTSD_Y;
            `FONT_Z: display=`FTSD_Z;
            default: display=`FTSD_DEFAULT;
  endcase
  
endmodule
