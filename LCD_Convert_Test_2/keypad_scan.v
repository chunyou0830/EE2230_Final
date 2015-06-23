`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer		: Chun You, Yang
// Create Date	: 19:52 04/13/2015
// Module Name	: keypad_scan 
//////////////////////////////////////////////////////////////////////////////////
`include "global.v"
module keypad_scan(
	clk,
	rst,
	row_scn,
	col_in,
	key,
	pressed
);

	//Defs
	input clk;
	input rst;
	input [3:0]col_in;
	output reg [3:0]row_scn;
	output reg [3:0]key;
	output reg pressed;
	
	reg [1:0] sel, sel_next;
	reg [3:0] key_detected;
	reg [3:0] key_next;
	reg keypad_state, keypad_state_next;
	reg [`KEYPAD_PAUSE_PERIOD_BIT_WIDTH-1:0] pause_delay, pause_delay_next;
	reg pressed_scn;
	reg pressed_detected;
	reg pressed_next;

	//Row scan
	always @(posedge clk or posedge rst)
		if (rst)
			sel = 2'b00;
		else
			sel = sel_next;
			
	always @(sel)
		sel_next = sel + 1'b1;
	
	always @*
		case (sel)
			2'd0: row_scn = 4'b0111;
			2'd1: row_scn = 4'b1011;
			2'd2: row_scn = 4'b1101;
			2'd3: row_scn = 4'b1110;
			default: row_scn = 4'b1111;
		endcase
	
	//Key Reading
	always @*
	begin
		case ({row_scn,col_in})
			`KEYPAD_DEC_WIDTH'b0111_0111: // press 'F'
			begin
				key_detected = `KEY_F;
				pressed_detected = `KEYPAD_PRESSED;
			end
			`KEYPAD_DEC_WIDTH'b0111_1011: // press 'E'
			begin
				key_detected = `KEY_E;
				pressed_detected = `KEYPAD_PRESSED;
			end
			`KEYPAD_DEC_WIDTH'b0111_1101: // press 'D'
			begin
				key_detected = `KEY_D;
				pressed_detected = `KEYPAD_PRESSED;
			end	 
			`KEYPAD_DEC_WIDTH'b0111_1110: // press 'C'
			begin
				key_detected = `KEY_C;
				pressed_detected = `KEYPAD_PRESSED;
			end
			`KEYPAD_DEC_WIDTH'b1011_0111: // press 'B'
			begin
				key_detected = `KEY_B;
				pressed_detected = `KEYPAD_PRESSED;
			end
			`KEYPAD_DEC_WIDTH'b1011_1011: // press '3'
			begin
				key_detected = `KEY_3;
				pressed_detected = `KEYPAD_PRESSED;
			end	 
			`KEYPAD_DEC_WIDTH'b1011_1101: // press '6'
			begin
				key_detected = `KEY_6;
				pressed_detected = `KEYPAD_PRESSED;
			end	 
			`KEYPAD_DEC_WIDTH'b1011_1110: // press '9'
			begin
				key_detected = `KEY_9;
				pressed_detected = `KEYPAD_PRESSED;
			end	
			`KEYPAD_DEC_WIDTH'b1101_0111: // press 'A'
			begin
				key_detected = `KEY_A;
				pressed_detected = `KEYPAD_PRESSED;
			end
			`KEYPAD_DEC_WIDTH'b1101_1011: // press '2'
			begin
				key_detected = `KEY_2;
				pressed_detected = `KEYPAD_PRESSED;
			end	 
			`KEYPAD_DEC_WIDTH'b1101_1101: // press '5'
			begin
				key_detected = `KEY_5;
				pressed_detected = `KEYPAD_PRESSED;
			end	 
			`KEYPAD_DEC_WIDTH'b1101_1110: // press '8'
			begin
				key_detected = `KEY_8;
				pressed_detected = `KEYPAD_PRESSED;
			end
			`KEYPAD_DEC_WIDTH'b1110_0111: // press '0'
			begin
				key_detected = `KEY_0;
				pressed_detected = `KEYPAD_PRESSED;
			end
			`KEYPAD_DEC_WIDTH'b1110_1011: // press '1'
			begin
				key_detected = `KEY_1;
				pressed_detected = `KEYPAD_PRESSED;
			end	 
			`KEYPAD_DEC_WIDTH'b1110_1101: // press '4'
			begin
				key_detected = `KEY_4;
				pressed_detected = `KEYPAD_PRESSED;
			end	 
			`KEYPAD_DEC_WIDTH'b1110_1110: // press '7'
			begin
				key_detected = `KEY_7;
				pressed_detected = `KEYPAD_PRESSED;
			end
			default:
			begin
				key_detected = `KEY_0;
				pressed_detected = `KEYPAD_NOT_PRESSED;
			end  			
		endcase
	end
	
	//Finite State Machine - State Transition
	always @*
		case (keypad_state)
			`SCAN:
			begin
				if (pressed_detected == `KEYPAD_PRESSED)
				begin
					keypad_state_next = `PAUSE;
					pressed_next = `KEYPAD_PRESSED;
					pause_delay_next = `KEYPAD_PAUSE_PERIOD_BIT_WIDTH'b0;
					key_next = key_detected;
				end
				else
				begin
					keypad_state_next = `SCAN;
					pressed_next = `KEYPAD_NOT_PRESSED;
					pause_delay_next = `KEYPAD_PAUSE_PERIOD_BIT_WIDTH'b0;
					key_next = key;
				end
			end
			`PAUSE:
			begin
				if (pause_delay==`KEYPAD_PAUSE_PERIOD_BIT_WIDTH'b1111)
				begin
					keypad_state_next = `SCAN;
					pressed_next = `KEYPAD_NOT_PRESSED;
					pause_delay_next = `KEYPAD_PAUSE_PERIOD_BIT_WIDTH'b0;
					key_next = key;
				end
				else
				begin
					keypad_state_next = `PAUSE;
					pressed_next = `KEYPAD_PRESSED;
					pause_delay_next = pause_delay + 1'b1;
					key_next = key;
				end
			end
			default:
			begin
				keypad_state_next = `SCAN;
				pressed_next = `KEYPAD_NOT_PRESSED;
				pause_delay_next = `KEYPAD_PAUSE_PERIOD_BIT_WIDTH'b0;
				key_next = key;
			end
		endcase

	// Finit State Machine - State register
	always @(posedge clk or posedge rst)
		if (rst)
		begin
			keypad_state <= 1'b0;
			pause_delay <= `KEYPAD_PAUSE_PERIOD_BIT_WIDTH'd0;
			pressed_scn <= `KEYPAD_NOT_PRESSED;
			key <= `KEY_0;
		end
		else
		begin
			keypad_state <= keypad_state_next;
			pause_delay <= pause_delay_next;
			pressed_scn <= pressed_next;
			key <= key_next;
		end
		
	// Pressed Signal Stablizer
	reg [4:0] press_shift;
	
	always @(posedge clk or posedge rst)
	if(rst)
		pressed<=1'b0;
	else if(press_shift > 5'd0)
		pressed<=1'b1;
	else
		pressed<=1'b0;
	
	always @(posedge clk or posedge rst)
		if(rst)
			press_shift <= 5'd0;
		else
			begin
			press_shift[4] <= press_shift[3];
			press_shift[3] <= press_shift[2];
			press_shift[2] <= press_shift[1];
			press_shift[1] <= press_shift[0];
			press_shift[0] <= pressed_scn;
			end
	
endmodule
