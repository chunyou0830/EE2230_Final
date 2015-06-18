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
`define STAT_CREATE			3'b000
`define STAT_MOVE_WAIT		3'b001
`define STAT_MOVE_DOWN		3'b010
`define STAT_MOVE_LEFT		3'b011
`define STAT_MOVE_RIGHT		3'b100
`define STAT_MOVE_ROTATE	3'b101
`define STAT_STOP			3'b110
`define STAT_CLEAR			3'b111
`define RAM_WRITE			1'b1
`define RAM_READ			1'b0
`define BLOCK_O				3'b001
`define BLOCK_L				3'b010
`define BLOCK_J				3'b011
`define BLOCK_I				3'b100
`define BLOCK_S				3'b101
`define BLOCK_Z				3'b110
`define BLOCK_T				3'b111

module GameRAMControll(
	clk_40M,
	clk_1,
	pad_key,
	pad_pressed,
	game_addLine,
	game_sendLine,
	ram_status,
	ram_addr,
	ram_data
);

	// I/O PORTS DECLARATION ----------

	// System Basic
	input clk_40M;
	input clk_1;

	// Keypad Operation
	input pad_key;
	input pad_pressed;

	// Gaming Basic Controlls
	input game_addLine;
	output game_sendLine;
	reg [2:0] state;
	reg [2:0] state_next;

	// Block Controll
	reg [6:0] block_type;
	reg [3:0] block_A_X, block_A_Y, block_B_X, block_B_Y, block_C_X, block_C_Y, block_D_X, block_D_Y;
	reg [3:0] block_next_A_X, block_next_A_Y, block_next_B_X, block_next_B_Y, block_next_C_X, block_next_C_Y, block_next_D_X, block_next_D_Y;
	reg [99:0] game_table;

	// RAM Controll
	output reg ram_status;
	reg 	   ram_status_next;
	output reg [3:0] ram_addr;
	reg		   [3:0] ram_addr_next;
	wire 	   [9:0] ram_data_in;
	output reg [9:0] ram_data_out;


	// BLOCK RANDOM CREATOR ----------
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			block_type<=3'b010;
		end
		else
		begin
			block_type<={block_type[1:0],block_type[2]^block_type[0]};
		end
	end

	// GAMING ----------

	// Combinational Logics
	always @*
	begin
		case(state)
			`STAT_CREATE:
			begin
				/* Create a new block */
				state_next = `STAT_MOVE_WAIT;
			end
			`STAT_MOVE_WAIT:
			begin
				if(/* Force to move down */)
				begin
					state_next = `STAT_MOVE_DOWN;
				end
				else if(/* Press to move down*/)
				begin
					state_next = `STAT_MOVE_DOWN;
				end
				else if(/* Press to move left */)
				begin
					state_next = `STAT_MOVE_LEFT;
				end
				else if(/* Press to move right */)
				begin
					state_next = `STAT_MOVE_RIGHT;
				end
				else if (/* Press to rotate */)
				begin
					state_next = `STAT_MOVE_ROTATE;
				end
				else
				begin
					state_next = `STAT_MOVE_WAIT;
				end
			end
			`STAT_MOVE_DOWN:
			begin
				/* Check if the block can move down */
				if(/* Can move down */)
				begin
					/* Move down */
					state_next = `STAT_MOVE_WAIT;
				end
				else
				begin
					state_next = `STAT_CREATE;
				end
			end
			`STAT_MOVE_LEFT:
			begin
				/* Check if the block can move left */
				if(/* Can */)
				begin
					/* Move it */
				end
				state_next = `STAT_MOVE_WAIT
			end
			`STAT_MOVE_RIGHT:
			begin
				/* Check */
				if(/* Can */)
				begin
					/* Move it */
				end
				state_next = `STAT_MOVE_WAIT;
			end
			`STAT_MOVE_ROTATE:
			begin
				/* Check */
				if(/* Can */)
				begin
					/* Move it */
				end
				state_next = `STAT_MOVE_WAIT;
			end
			default:
			begin
				state_next = `STAT_MOVE_WAIT;
			end
		endcase
	end

	// Sequential Logics
	always @(posedge clk_40M or posedge rst)
	begin
		if (rst)
		begin
			state <= `STAT_CREATE;
		end
		else
		begin
			state <= state_next;
		end
	end

	// RAM CONTROLL ----------

	// State and Address Controll - Combinational Logic (Finished)
	always @*
	begin
		if(state == `STAT_MOVE_WAIT)
		begin
			ram_status_next = `RAM_READ;
			ram_addr_next = ram_addr + 1'b1;
		end
		else
		begin
			ram_status_next = `RAM_WRITE;
		end
	end

	// State and Address Controll - Sequential Logic (Finished)
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			ram_status <= `RAM_WRITE;
			ram_addr <= 4'd0;
		end
		else if (ram_addr == 4'd9)
		begin
			ram_status <= ram_status_next;
			ram_addr <= 4'd0;	
		end
		else
		begin
			ram_status <= ram_status_next;
			ram_addr <= ram_addr_next;
		end
	end

	// RAM Read: Read from RAM to game table and output
	always @*
	begin
		if(ram_state == `RAM_READ)
		begin
			case(ram_addr)
				4'd0: [9:0]game_table = ram_data_out;
				4'd1: [19:10]game_table = ram_data_out;
				4'd2: [29:20]game_table = ram_data_out;
				4'd3: [39:30]game_table = ram_data_out;
				4'd4: [49:40]game_table = ram_data_out;
				4'd5: [59:50]game_table = ram_data_out;
				4'd6: [69:60]game_table = ram_data_out;
				4'd7: [79:70]game_table = ram_data_out;
				4'd8: [89:80]game_table = ram_data_out;
				4'd9: [99:90]game_table = ram_data_out;
				default: game_table = 100'd0;
			endcase
		end
	end

	// Ram Write (Finished): Save the game table to RAM
	always @*
	begin
		if(ram_state == `RAM_WRITE)
		begin
			case(ram_addr)
				4'd0: ram_data_in = [9:0]game_table;
				4'd1: ram_data_in = [19:10]game_table;
				4'd2: ram_data_in = [29:20]game_table;
				4'd3: ram_data_in = [39:30]game_table;
				4'd4: ram_data_in = [49:40]game_table;
				4'd5: ram_data_in = [59:50]game_table;
				4'd6: ram_data_in = [69:60]game_table;
				4'd7: ram_data_in = [79:70]game_table;
				4'd8: ram_data_in = [89:80]game_table;
				4'd9: ram_data_in = [99:90]game_table;
				default: ram_data_in = 10'd0;
			endcase
		end
		else
	end

	// GAME TABLE CONTROLL ----------
	always @*
	begin
		if(/* The state needs to change */)
			/* Change the bit in the game table */
	end


endmodule
