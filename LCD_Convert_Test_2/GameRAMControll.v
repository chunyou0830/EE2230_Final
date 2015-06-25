`timescale 1ns / 1ps
 //////////////////////////////////////////////////////////////////////////////////
 // Engineer:		Jason Yang, Jimmy Lee
 // Create Date:		14:02 06/14/2015 
 // Design Name:		Game Status Controll FSM
 // Module Name:		GameRAMControll 
 // Project Name:	Tetris Battle
 // Target Devices:	EVS 6 FPGA Demo Board
 // Description:
 // 		Controll the movement of the blocks and the r/w of the gaming table RAM.
 // Revision: 
 // 		Revision 0.01 - File Created
 //////////////////////////////////////////////////////////////////////////////////
 `include "global.v"
 `define STAT_STOP			4'b0000
 `define STAT_CREATE		4'b0001
 `define STAT_MOVE_WAIT		4'b0010
 `define STAT_MOVE_DOWN		4'b1001
 `define STAT_MOVE_LEFT		4'b1010
 `define STAT_MOVE_RIGHT	4'b1011	
 `define STAT_MOVE_ROTATE	4'b1100
 `define STAT_PAUSE			4'b0011
 `define STAT_CLEAR			4'b0100
 `define BLOCK_O			3'b001
 `define BLOCK_L			3'b010
 `define BLOCK_J			3'b011
 `define BLOCK_I			3'b100
 `define BLOCK_S			3'b101
 `define BLOCK_Z			3'b110
 `define BLOCK_T			3'b111
 `define ROTATE_0			2'b00
 `define ROTATE_1			2'b01
 `define ROTATE_2			2'b10
 `define ROTATE_3			2'b11
 
 module GameRAMControll(
 	clk_40M,
	clk_6,
 	clk_1,
 	rst,
 	pad_key,
 	pad_pressed,
 	game_addLine,
 	game_sendLine,
	game_table_output,
	state_output
 );
 
 	// I/O PORTS DECLARATION ----------
 
 	// System Basic
 	input clk_40M;
	input clk_6;
 	input clk_1;
 	input rst;
 
 	// Keypad Operation
 	input [3:0] pad_key;
 	input pad_pressed;
 
 	// Gaming Basic Controlls
 	input game_addLine;
 	output game_sendLine;
 	reg [3:0] clear_counter;
 	reg [3:0] state;
 	reg [3:0] state_next;
	output [2:0] state_output;
	assign state_output = {clear_counter[2:0], a};
 	// Block Controll
 	reg move_available;
 	wire move_basic_check;
 	reg [2:0] block_gen_type, block_type;
 	reg [1:0] block_rotate,block_rotate_next;
 	reg [6:0] block_A, block_B, block_C, block_D, block_next_A, block_next_B, block_next_C, block_next_D;
 	reg [99:0] game_table;
 	reg a;
 
 	// RAM Controll
 	output [99:0] game_table_output;
 
 
 	// BLOCK RANDOM CREATOR ---------- (Finished)
 	always @(posedge clk_40M or posedge rst)
 	begin
 		if(rst)
 		begin
 			block_gen_type<=3'b010;
 		end
 		else
 		begin
 			block_gen_type<={block_gen_type[1:0],block_gen_type[2]^block_gen_type[0]};
 		end
 	end
 
 	// GAMING ----------
 
 	// Combinational Logics
 	always @*
 	begin
 		case(state)
 			`STAT_STOP:
 			begin
 				/* State Change */
 				if(1'b0/* Start Signal Comes in */)
 				begin
 					state_next = `STAT_CREATE;
 				end
 				a = 0;
 			end
 			`STAT_CREATE:
 			begin
 				/* Create a new block */
 				case(block_gen_type)
 					`BLOCK_O:{block_type,block_next_A,block_next_B,block_next_C,block_next_D} = {`BLOCK_O,7'd4 ,7'd5 ,7'd14,7'd15};
 					`BLOCK_L:{block_type,block_next_A,block_next_B,block_next_C,block_next_D} = {`BLOCK_L,7'd25,7'd24,7'd14,7'd4 };
 					`BLOCK_J:{block_type,block_next_A,block_next_B,block_next_C,block_next_D} = {`BLOCK_J,7'd24,7'd25,7'd15,7'd5 };
 					`BLOCK_I:{block_type,block_next_A,block_next_B,block_next_C,block_next_D} = {`BLOCK_I,7'd5 ,7'd15,7'd25,7'd35};
 					`BLOCK_S:{block_type,block_next_A,block_next_B,block_next_C,block_next_D} = {`BLOCK_S,7'd5 ,7'd4 ,7'd14,7'd13};
 					`BLOCK_Z:{block_type,block_next_A,block_next_B,block_next_C,block_next_D} = {`BLOCK_Z,7'd4 ,7'd5 ,7'd15,7'd16};
 					`BLOCK_T:{block_type,block_next_A,block_next_B,block_next_C,block_next_D} = {`BLOCK_T,7'd6 ,7'd5 ,7'd4 ,7'd15};
 					default:{block_type,block_next_A,block_next_B,block_next_C,block_next_D}  = {3'b000  ,7'd0 ,7'd0 ,7'd0 ,7'd0 }; // change to a spesific block type
 				endcase
 				/* Initiallize */
 				block_rotate_next = `ROTATE_0;
 				move_available = 1'b0;
 				/* State Change */
 				state_next = `STAT_MOVE_WAIT;
 				
 			end
 			`STAT_MOVE_WAIT:
 			begin
 				/* Initiallize */
 				a = 0;
 				move_available = 1'b0;
 				block_rotate_next = block_rotate;
 				/* State Change */
				if(/*clk_1*/0) /* Force to move down UNFINISHED */
 				begin
 					state_next = `STAT_MOVE_DOWN;
 				end
 				else if(pad_pressed && pad_key == `KEY_4) /* Press to move down */
 				begin
 					state_next = `STAT_MOVE_DOWN;
 				end
 				else if(pad_pressed && pad_key == `KEY_1)/* Press to move left */
 				begin
 					state_next = `STAT_MOVE_LEFT;
 				end
 				else if(pad_pressed && pad_key == `KEY_7)/* Press to move right */
 				begin
 					state_next = `STAT_MOVE_RIGHT;
 				end
 				else if (pad_pressed && pad_key == `KEY_0)/* Press to rotate */
 				begin
 					state_next = `STAT_MOVE_ROTATE;
 				end
 				else
 				begin
 					state_next =`STAT_MOVE_WAIT;
 				end
 			end
 			`STAT_MOVE_DOWN:
 			begin
 				a = 0;
 				/* Generate next block */
 				block_next_A = block_A + 7'd10;
 				block_next_B = block_B + 7'd10;
 				block_next_C = block_C + 7'd10;
 				block_next_D = block_D + 7'd10;
 				block_rotate_next = block_rotate;
 				/* Check Movable */
 				move_available = (move_basic_check && (block_A < 7'd90) && (block_B < 7'd90) && (block_C < 7'd90) && (block_D < 7'd90));
				/* State Change */
				if(move_available)
 				begin
					state_next = `STAT_PAUSE;
 				end
 				else if(1'b0/*~move_available && game_table[9:0]!=10'b0000_0000_00*/)
 				begin
 					state_next = `STAT_STOP;
 				end
 				else
 				begin
 					state_next = `STAT_CLEAR;
 				end
 			end
 			`STAT_MOVE_LEFT:
 			begin
 				a = 0;
 				/* Generate next block */
 				block_next_A = block_A - 7'd1;
 				block_next_B = block_B - 7'd1;
 				block_next_C = block_C - 7'd1;
 				block_next_D = block_D - 7'd1;
 				block_rotate_next = block_rotate;
 				/* Check Movable */
 				move_available = (move_basic_check && (block_A % 7'd10 != 7'd0 ) && (block_B % 7'd10 != 7'd0 ) && (block_C % 7'd10 != 7'd0 ) && (block_D % 7'd10 != 7'd0 ));
 				/* State Change */
				state_next = `STAT_PAUSE;
 			end
 			`STAT_MOVE_RIGHT:
 			begin
 				a = 0;
 				/* Generate next block */
 				block_next_A = block_A + 7'd1;
 				block_next_B = block_B + 7'd1;
 				block_next_C = block_C + 7'd1;
 				block_next_D = block_D + 7'd1;
 				block_rotate_next = block_rotate;
 				/* Check Movable */
 				move_available = (move_basic_check && ((block_A+7'd1) % 7'd10 != 7'd0 ) && ((block_B+7'd1) % 7'd10 != 7'd0 ) && ((block_C+7'd1) % 7'd10 != 7'd0 ) && ((block_D+7'd1) % 7'd10 != 7'd0 ));
 				/* State Change */
				state_next = `STAT_PAUSE;
 			end
 			`STAT_MOVE_ROTATE:
 			begin
 				a = 0;
 				/* Generate next block */
 				case({block_type,block_rotate})
 					{`BLOCK_J,`ROTATE_0}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd9 ,block_B-7'd20,block_C-7'd11,block_D-7'd2 };
 					{`BLOCK_J,`ROTATE_1}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd11,block_B-7'd2 ,block_C+7'd9 ,block_D+7'd20};
 					{`BLOCK_J,`ROTATE_2}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd9 ,block_B+7'd20,block_C+7'd11,block_D+7'd2 };
 					{`BLOCK_J,`ROTATE_3}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd11,block_B+7'd2 ,block_C-7'd9 ,block_D-7'd20};
 
 					{`BLOCK_L,`ROTATE_0}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd9 ,block_B+7'd2 ,block_C+7'd11,block_D+7'd20};
 					{`BLOCK_L,`ROTATE_1}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd11,block_B-7'd20,block_C-7'd9 ,block_D+7'd2 };
 					{`BLOCK_L,`ROTATE_2}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd9 ,block_B-7'd2 ,block_C-7'd11,block_D-7'd20};
 					{`BLOCK_L,`ROTATE_3}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd11,block_B+7'd20,block_C+7'd9 ,block_D-7'd2 };
 
 					{`BLOCK_S,`ROTATE_0}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd11,block_B+7'd0 ,block_C-7'd9 ,block_D+7'd2 };
 					{`BLOCK_S,`ROTATE_1}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd9 ,block_B+7'd0 ,block_C-7'd11,block_D-7'd20};
 					{`BLOCK_S,`ROTATE_2}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd11,block_B+7'd0 ,block_C+7'd9 ,block_D-7'd2 };
 					{`BLOCK_S,`ROTATE_3}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd9 ,block_B+7'd0 ,block_C+7'd11,block_D+7'd20};
 
 					{`BLOCK_Z,`ROTATE_0}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd11,block_B+7'd0 ,block_C-7'd9 ,block_D-7'd20};
 					{`BLOCK_Z,`ROTATE_1}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd9 ,block_B+7'd0 ,block_C-7'd11,block_D-7'd2 };
 					{`BLOCK_Z,`ROTATE_2}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd11,block_B+7'd0 ,block_C+7'd9 ,block_D+7'd20};
 					{`BLOCK_Z,`ROTATE_3}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd9 ,block_B+7'd0 ,block_C+7'd11,block_D+7'd2 };
 
 					{`BLOCK_T,`ROTATE_0}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd2 ,block_B+7'd9 ,block_C+7'd20,block_D+7'd0 };
 					{`BLOCK_T,`ROTATE_1}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd20,block_B+7'd11,block_C+7'd2 ,block_D+7'd0 };
 					{`BLOCK_T,`ROTATE_2}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd2 ,block_B-7'd9 ,block_C-7'd20,block_D+7'd0 };
 					{`BLOCK_T,`ROTATE_3}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd20,block_B-7'd11,block_C-7'd2 ,block_D+7'd0 };
 
 					{`BLOCK_I,`ROTATE_0}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd19,block_B+7'd10,block_C+7'd1 ,block_D-7'd8 };
 					{`BLOCK_I,`ROTATE_1}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd12,block_B+7'd1 ,block_C-7'd10,block_D-7'd21};
 					{`BLOCK_I,`ROTATE_2}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd19,block_B-7'd10,block_C-7'd1 ,block_D+7'd8 };
 					{`BLOCK_I,`ROTATE_3}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A-7'd12,block_B-7'd1 ,block_C+7'd10,block_D+7'd21};
 
 					{`BLOCK_O,`ROTATE_0}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd0 ,block_B+7'd0 ,block_C+7'd0 ,block_D+7'd0 };
 					{`BLOCK_O,`ROTATE_1}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd0 ,block_B+7'd0 ,block_C+7'd0 ,block_D+7'd0 };
 					{`BLOCK_O,`ROTATE_2}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd0 ,block_B+7'd0 ,block_C+7'd0 ,block_D+7'd0 };
 					{`BLOCK_O,`ROTATE_3}:{block_next_A,block_next_B,block_next_C,block_next_D} = {block_A+7'd0 ,block_B+7'd0 ,block_C+7'd0 ,block_D+7'd0 };
 				endcase
 				/* Check Movable */
				move_available = move_basic_check;
				if(move_available)
				begin
	 				block_rotate_next = block_rotate + 1'b1;
				end
				state_next = `STAT_PAUSE;
			end
			`STAT_PAUSE:
			begin
				 a = 0;
 				state_next = `STAT_MOVE_WAIT;
 				block_rotate_next = block_rotate;
 			end
 			`STAT_CLEAR:
 			begin
 				if(clear_counter == 4'd0 && game_table[9:0] != 10'b1111_1111_11&& game_table[19:10] != 10'b1111_1111_11&& game_table[29:20] != 10'b1111_1111_11&& game_table[39:30] != 10'b1111_1111_11&& game_table[49:40] != 10'b1111_1111_11&& game_table[59:50] != 10'b1111_1111_11&& game_table[69:60] != 10'b1111_1111_11&& game_table[79:70] != 10'b1111_1111_11&& game_table[89:80] != 10'b1111_1111_11&& game_table[99:90] != 10'b1111_1111_11)
 				begin
 					state_next = `STAT_CREATE;
 					a=1;
 				end
 				else
 				begin
 					state_next = `STAT_CLEAR;
 				end
 			end
 			default:
 			begin
 				move_available = 1'b0;
 				a = 0;
 				state_next = `STAT_MOVE_WAIT;
 			end
 		endcase
 	end

 	// Sequential Logics

	wire clk_stat_trig;
	assign clk_stat_trig = clk_6 || pad_pressed;
	always @(posedge clk_6 or posedge rst)
 	begin
 		if (rst)
 		begin
 			state <= `STAT_CREATE;
 			block_rotate <= 2'd0;
 		end
 		else
 		begin
 			state <= state_next;
 			block_rotate <= block_rotate_next;
 		end
 	end

 	// GAME TABLE CONTROLL ----------
 	assign game_table_output = game_table;

	always @(posedge clk_6 or posedge rst)
 	begin
 		if(rst)
 		begin
 			game_table <= 100'd0;
 		end
 		else if(state == `STAT_STOP)
 		begin
 			game_table <= 100'd0;
 		end
 		else if(state == `STAT_CLEAR)
 		begin
 				case(clear_counter)
 					4'd0:
 					begin
 						if(game_table[9:0] == 10'b1111_1111_11)
 						game_table[9:0]  <= {10'd0};
 					end
 					4'd1:
 					begin
 						if(game_table[19:10] == 10'b1111_1111_11)
 						game_table[19:0] <= {game_table[9:0],10'd0};
 					end
 					4'd2:
 					begin
 						if(game_table[29:20] == 10'b1111_1111_11)
 						game_table[29:0] <= {game_table[19:0],10'd0};
 					end
 					4'd3:
 					begin
 						if(game_table[39:30] == 10'b1111_1111_11)
 						game_table[39:0] <= {game_table[29:0],10'd0};
 					end
 					4'd4:
 					begin
 						if(game_table[49:40] == 10'b1111_1111_11)
 						game_table[49:0] <= {game_table[39:0],10'd0};
 					end
 					4'd5:
 					begin
 						if(game_table[59:50] == 10'b1111_1111_11)
 						game_table[59:0] <= {game_table[49:0],10'd0};
 					end
 					4'd6:
 					begin
 						if(game_table[69:60] == 10'b1111_1111_11)
 						game_table[69:0] <= {game_table[59:0],10'd0};
 					end
 					4'd7:
 					begin
 						if(game_table[79:70] == 10'b1111_1111_11)
 						game_table[79:0] <= {game_table[69:0],10'd0};
 					end
 					4'd8:
 					begin
 						if(game_table[89:80] == 10'b1111_1111_11)
 						game_table[89:0] <= {game_table[79:0],10'd0};
 					end
 					4'd9:
 					begin
 						if(game_table[99:90] == 10'b1111_1111_11)
 						game_table[99:0] <= {game_table[89:0],10'd0};
 					end
 					
 				endcase
 				//game_table[clear_counter*10+9:0] <= {10'd0, game_table[(clear_counter-1)*10+9:0]};
 		end
 		else if((state[3] == 1'b1 && move_available) || (state == `STAT_CREATE))
 		begin
			if(state == `STAT_CREATE)
 			begin
 				//game_table[block_A] <= 1'b1;
 				//game_table[block_B] <= 1'b1;
 				//game_table[block_C] <= 1'b1;
 				//game_table[block_D] <= 1'b1;
 			end
 			else
 			begin
 				game_table[block_A] <= 1'b0;
 				game_table[block_B] <= 1'b0;
 				game_table[block_C] <= 1'b0;
 				game_table[block_D] <= 1'b0;
 			end
 
 			game_table[block_next_A] <= 1'b1;
 			game_table[block_next_B] <= 1'b1;
 			game_table[block_next_C] <= 1'b1;
 			game_table[block_next_D] <= 1'b1;
 			block_A <= block_next_A;
 			block_B <= block_next_B;
 			block_C <= block_next_C;
 			block_D <= block_next_D;
 		end
 	end

 	always @(posedge clk_6 or posedge rst) begin
 		if (rst)
 		begin
 			clear_counter <= 4'd9;
 		end
 		else if (clear_counter == 4'd0)
 		begin
 			clear_counter <= 4'd9;	
 		end
 		else if(state == `STAT_CLEAR)
 		begin
 			clear_counter <= clear_counter - 1'b1;
 		end
 		else
 		begin
 			clear_counter <= 4'd9;	
 		end
 	end
 
 	assign move_basic_check = (((block_next_A == block_A || block_next_A == block_B || block_next_A == block_C || block_next_A == block_D) && game_table[block_next_A]) || (~(block_next_A == block_A || block_next_A == block_B || block_next_A == block_C || block_next_A == block_D) && ~game_table[block_next_A])) &&
 			       			  (((block_next_B == block_A || block_next_B == block_B || block_next_B == block_C || block_next_B == block_D) && game_table[block_next_B]) || (~(block_next_B == block_A || block_next_B == block_B || block_next_B == block_C || block_next_B == block_D) && ~game_table[block_next_B])) &&
 					 		  (((block_next_C == block_A || block_next_C == block_B || block_next_C == block_C || block_next_C == block_D) && game_table[block_next_C]) || (~(block_next_C == block_A || block_next_C == block_B || block_next_C == block_C || block_next_C == block_D) && ~game_table[block_next_C])) &&
 					 		  (((block_next_D == block_A || block_next_D == block_B || block_next_D == block_C || block_next_D == block_D) && game_table[block_next_D]) || (~(block_next_D == block_A || block_next_D == block_B || block_next_D == block_C || block_next_D == block_D) && ~game_table[block_next_D]));
 
 endmodule