`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company		: NTHUEE
// Engineer		: Chun You, Yang
// Create Date	: 12:41 03/28/2012 
// Module Name	: global 
// Project Name	: Lab6_2
//////////////////////////////////////////////////////////////////////////////////

`define ENABLED 1'b1 // ENABLE indicator
`define DISABLED 1'b0 // EIDABLE indicator

// Clock Generator
`define DIV_BY_20M 20_000_000
`define DIV_BY_20M_BIT_WIDTH 25
`define DIV_BY_200K 200_000
`define DIV_BY_200K_BIT_WIDTH 18

// Finite State Machine 
`define STAT_PAUSE 1'b0;
`define STAT_COUNT 1'b1;
`define CNT_DIS 1'b0;
`define CNT_EN 1'b1;

// Frequency Divider
`define FREQ_DIV_BIT 25

// 14-segment display
`define FTSD_BIT_WIDTH 15 // 14-segment display control
`define FTSD_NUM 4 //number of 14-segment display
`define BCD_BIT_WIDTH 4 // BCD bit width
`define FTSD_ZERO  `FTSD_BIT_WIDTH'b0000_0011_1111_111 //0
`define FTSD_ONE   `FTSD_BIT_WIDTH'b1111_1111_1011_011 //1
`define FTSD_TWO   `FTSD_BIT_WIDTH'b0010_0100_1111_111 //2
`define FTSD_THREE `FTSD_BIT_WIDTH'b0000_1100_1111_111 //3
`define FTSD_FOUR  `FTSD_BIT_WIDTH'b1001_1000_1111_111 //4
`define FTSD_FIVE  `FTSD_BIT_WIDTH'b0100_1000_1111_111 //5
`define FTSD_SIX   `FTSD_BIT_WIDTH'b0100_0000_1111_111 //6
`define FTSD_SEVEN `FTSD_BIT_WIDTH'b0001_1111_1111_111 //7
`define FTSD_EIGHT `FTSD_BIT_WIDTH'b0000_0000_1111_111 //8
`define FTSD_NINE  `FTSD_BIT_WIDTH'b0000_1000_1111_111 //9
`define FTSD_A     `FTSD_BIT_WIDTH'b0001_0000_1111_111 //A
`define FTSD_B     `FTSD_BIT_WIDTH'b0000_1110_1011_011 //B
`define FTSD_C     `FTSD_BIT_WIDTH'b0110_0011_1111_111 //C
`define FTSD_D     `FTSD_BIT_WIDTH'b0000_1111_1011_011 //D
`define FTSD_E     `FTSD_BIT_WIDTH'b0110_0000_1111_111 //E
`define FTSD_F     `FTSD_BIT_WIDTH'b0111_0000_1111_111 //F

`define FTSD_G     `FTSD_BIT_WIDTH'b0100_0010_1111_111 //G
`define FTSD_H     `FTSD_BIT_WIDTH'b1001_0000_1111_111 //H
`define FTSD_I     `FTSD_BIT_WIDTH'b0110_1111_1011_111 //I
`define FTSD_J     `FTSD_BIT_WIDTH'b1000_0111_1111_111 //J
`define FTSD_K     `FTSD_BIT_WIDTH'b1111_0001_1101_101 //K
`define FTSD_L     `FTSD_BIT_WIDTH'b1110_0011_1111_111 //L
`define FTSD_M     `FTSD_BIT_WIDTH'b1001_0011_0101_111 //M
`define FTSD_N     `FTSD_BIT_WIDTH'b1001_0011_0111_101 //N
`define FTSD_O     `FTSD_BIT_WIDTH'b0000_0011_1111_111 //O
`define FTSD_P     `FTSD_BIT_WIDTH'b0011_0000_1111_111 //P
`define FTSD_Q     `FTSD_BIT_WIDTH'b0000_0011_1111_101 //Q
`define FTSD_R     `FTSD_BIT_WIDTH'b0011_0000_1111_101 //R
`define FTSD_S     `FTSD_BIT_WIDTH'b0100_1100_0111_111 //S
`define FTSD_T     `FTSD_BIT_WIDTH'b0111_1111_1011_111 //T
`define FTSD_U     `FTSD_BIT_WIDTH'b1000_0011_1111_111 //U
`define FTSD_V     `FTSD_BIT_WIDTH'b1111_0011_1100_111 //V
`define FTSD_W     `FTSD_BIT_WIDTH'b1001_0011_1110_101 //W
`define FTSD_X     `FTSD_BIT_WIDTH'b1111_1111_0100_101 //X
`define FTSD_Y     `FTSD_BIT_WIDTH'b1111_1111_0101_011 //Y
`define FTSD_Z     `FTSD_BIT_WIDTH'b0110_1111_1100_111 //Z
`define FTSD_DEFAULT   `FTSD_BIT_WIDTH'b1111_1111_1111_111 //default

// Keypad scan
`define KEYPAD_ROW_WIDTH 4  // Row width of keypad
`define KEYPAD_COL_WIDTH 4  // column width of keypad
`define KEYPAD_DEC_WIDTH 8  // keypad decoding bits (row+col)
`define KEY_0  4'd0 // key '0'
`define KEY_1  4'd1 // key '1'
`define KEY_2  4'd2 // key '2'
`define KEY_3  4'd3 // key '3'
`define KEY_4  4'd4 // key '4'
`define KEY_5  4'd5 // key '5'
`define KEY_6  4'd6 // key '6'
`define KEY_7  4'd7 // key '7'
`define KEY_8  4'd8 // key '8'
`define KEY_9  4'd9 // key '9'
`define KEY_A  4'd10 // key 'A'
`define KEY_B  4'd11 // key 'B'
`define KEY_C  4'd12 // key 'C'
`define KEY_D  4'd13 // key 'D'
`define KEY_E  4'd14 // key 'E'
`define KEY_F  4'd15 // key 'F'
`define KEYPAD_PRESSED 1'b1 // key pressed indicator
`define KEYPAD_NOT_PRESSED 1'b0 // key not pressed indicator
`define SCAN 1'b1 // Scan state of the keypad readout
`define PAUSE 1'b0 // pause state of the keypad readout
`define KEYPAD_PAUSE_PERIOD_BIT_WIDTH 4 // bit width of the keypad pause period

// BCD counter
`define BCD_BIT_WIDTH 4 // BCD bit width 
`define INCREMENT 1'b1 // increase by 1
`define BCD_ZERO 4'd0 // 1 for BCD
`define BCD_ONE 4'd1 // 1 for BCD
`define BCD_TWO 4'd2 // 2 for BCD
`define BCD_THREE 4'd3 // 2 for BCD
`define BCD_FOUR 4'd4 // 2 for BCD
`define BCD_FIVE 4'd5 // 5 for BCD
`define BCD_SIX 4'd6 // 2 for BCD
`define BCD_SEVEN 4'd7 // 2 for BCD
`define BCD_EIGHT 4'd8 // 2 for BCD
`define BCD_NINE 4'd9 // 9 for BCD
`define BCD_DEF 4'd15 // all 1

// Fonts
`define FONT_ZERO 6'd0
`define FONT_ONE 6'd1
`define FONT_TWO 6'd2
`define FONT_THREE 6'd3
`define FONT_FOUR 6'd4
`define FONT_FIVE 6'd5
`define FONT_SIX 6'd6
`define FONT_SEVEN 6'd7
`define FONT_EIGHT 6'd8
`define FONT_NINE 6'd9
`define FONT_A 6'd10
`define FONT_B 6'd11
`define FONT_C 6'd12
`define FONT_D 6'd13
`define FONT_E 6'd14
`define FONT_F 6'd15
`define FONT_G 6'd16
`define FONT_H 6'd17
`define FONT_I 6'd18
`define FONT_J 6'd19
`define FONT_K 6'd20
`define FONT_L 6'd21
`define FONT_M 6'd22
`define FONT_N 6'd23
`define FONT_O 6'd24
`define FONT_P 6'd25
`define FONT_Q 6'd26
`define FONT_R 6'd27
`define FONT_S 6'd28
`define FONT_T 6'd29
`define FONT_U 6'd30
`define FONT_V 6'd31
`define FONT_W 6'd32
`define FONT_X 6'd33
`define FONT_Y 6'd34
`define FONT_Z 6'd35
`define FONT_DEF 6'd63

//Calculator
`define CALC_RST 2'b00
`define CALC_ADD 2'b01
`define CALC_SUB 2'b10
`define CALC_MULTI 2'b11

//LCD words
`define LCD_NONE 256'h0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
`define LCD_1 256'h0000_0000_03c0_03c0_0fc0_0fc0_03c0_03c0_03c0_03c0_03c0_03c0_3ffc_3ffc_0000_0000
`define LCD_2 256'h0000_0000_0ff0_0ff0_3c3c_3c3c_00f0_00f0_03c0_03c0_0f00_0f00_3ffc_3ffc_0000_0000
`define LCD_3 256'h0000_0000_3ffc_3ffc_00f0_00f0_03c0_03c0_00f0_00f0_3c3c_3c3c_0ff0_0ff0_0000_0000
`define LCD_4 256'h0000_0000_00f0_00f0_03f0_03f0_0ff0_0ff0_3cf0_3cf0_3ffc_3ffc_00f0_00f0_0000_0000
`define LCD_5 256'h0000_0000_3ffc_3ffc_3c00_3c00_3ff0_3ff0_003c_003c_3c3c_3c3c_0ff0_0ff0_0000_0000
`define LCD_6 256'h0000_0000_0ff0_0ff0_3c00_3c00_3ff0_3ff0_3c3c_3c3c_3c3c_3c3c_0ff0_0ff0_0000_0000
`define LCD_7 256'h0000_0000_3ffc_3ffc_003c_003c_00f0_00f0_03c0_03c0_0f00_0f00_0f00_0f00_0000_0000
`define LCD_8 256'h0000_0000_0ff0_0ff0_3c3c_3c3c_0ff0_0ff0_3c3c_3c3c_3c3c_3c3c_0ff0_0ff0_0000_0000
`define LCD_9 256'h0000_0000_0ff0_0ff0_3c3c_3c3c_0ffc_0ffc_003c_003c_00f0_00f0_0fc0_0fc0_0000_0000
`define LCD_0 256'h0000_0000_0ff0_0ff0_3c3c_3c3c_3cfc_3cfc_3f3c_3f3c_3c3c_3c3c_0ff0_0ff0_0000_0000
`define LCD_A 256'h0000_0000_03c0_03c0_0ff0_0ff0_3c3c_3c3c_3c3c_3c3c_3ffc_3ffc_3c3c_3c3c_0000_0000
`define LCD_B 256'h0000_0000_3ff0_3ff0_3c3c_3c3c_3ff0_3ff0_3c3c_3c3c_3c3c_3c3c_3ff0_3ff0_0000_0000
`define LCD_C 256'h0000_0000_0ff0_0ff0_3c3c_3c3c_3c00_3c00_3c00_3c00_3c3c_3c3c_0ff0_0ff0_0000_0000
`define LCD_D 256'h0000_0000_3fc0_3fc0_3cf0_3cf0_3c3c_3c3c_3c3c_3c3c_3cf0_3cf0_3fc0_3fc0_0000_0000
`define LCD_E 256'h0000_0000_3ffc_3ffc_3c00_3c00_3ff0_3ff0_3c00_3c00_3c00_3c00_3ffc_3ffc_0000_0000
`define LCD_F 256'h0000_0000_3ffc_3ffc_3c00_3c00_3ff0_3ff0_3c00_3c00_3c00_3c00_3c00_3c00_0000_0000
`define LCD_G 256'h0000_0000_0ffc_0ffc_3c00_3c00_3c00_3c00_3cfc_3cfc_3c3c_3c3c_0ffc_0ffc_0000_0000
`define LCD_H 256'h0000_0000_3c3c_3c3c_3c3c_3c3c_3ffc_3ffc_3c3c_3c3c_3c3c_3c3c_3c3c_3c3c_0000_0000
`define LCD_I 256'h0000_0000_3ffc_3ffc_03c0_03c0_03c0_03c0_03c0_03c0_03c0_03c0_3ffc_3ffc_0000_0000
`define LCD_J 256'h0000_0000_00fc_00fc_003c_003c_003c_003c_003c_003c_3c3c_3c3c_0ff0_0ff0_0000_0000
`define LCD_K 256'h0000_0000_3c3c_3c3c_3cf0_3cf0_3fc0_3fc0_3fc0_3fc0_3cd0_3cf0_3c3c_3c3c_0000_0000
`define LCD_L 256'h0000_0000_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3ffc_3ffc_0000_0000
`define LCD_M 256'h0000_0000_781e_781e_7e7e_7e7e_7ffe_7ffe_799e_799e_781e_781e_781e_781e_0000_0000
`define LCD_N 256'h0000_0000_3c3c_3c3c_3f3c_3f3c_3ffc_3ffc_3ffc_3ffc_3cfc_3cfc_3c3c_3c3c_0000_0000
`define LCD_O 256'h0000_0000_0ff0_0ff0_3c3c_3c3c_3c3c_3c3c_3c3c_3c3c_3c3c_3c3c_0ff0_0ff0_0000_0000
`define LCD_P 256'h0000_0000_3ff0_3ff0_3c3c_3c3c_3c3c_3c3c_3ff0_3ff0_3c00_3c00_3c00_3c00_0000_0000