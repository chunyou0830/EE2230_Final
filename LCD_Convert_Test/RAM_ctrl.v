////////////////////////////////////////////////////////////////////////
// Department of Computer Science
// National Tsing Hua University
// Project   : Design Gadgets for Hardware Lab
// Module    : RAM_ctrl
// Author    : Chih-Tsun Huang
// E-mail    : cthuang@cs.nthu.edu.tw
// Revision  : 2
// Date      : 2011/04/13
module RAM_ctrl (
  input [99:0] game_table, // CY_ADD
  input clk,
  input rst_n,
  input change,
  input [3:0]addr_in,
  input en,
  output reg [7:0] data_out,
  output reg data_valid
);

  
  parameter IDLE  = 2'd0;
  parameter WRITE = 2'd1;
  parameter GETDATA = 2'd2;
  parameter TRANSDATA = 2'd3;



  reg [5:0] addr, addr_next;
  reg [5:0] counter_word, counter_word_next;
  wire [63:0] data_out_64;
  reg [63:0] data_in;
  reg [5:0] in_temp0, in_temp1, in_temp2, in_temp3,in_temp4,in_temp5,in_temp6,in_temp7,in_temp8,in_temp9;
  reg [3:0] cnt, cnt_next;  //count mark row
  reg [511:0] mem, mem_next;
  reg [1:0] state, state_next;
  reg flag, flag_next;
  reg [7:0] data_out_next;
  reg data_valid_next;
  reg wen, wen_next;
  reg temp_change, temp_change_next;

//-------------------
	reg [9:0] data;
	always @*
	begin
		case(cnt)
			4'd0: data = game_table[9:0];
			4'd1: data = game_table[19:10];
			4'd2: data = game_table[29:20];
			4'd3: data = game_table[39:30];
			4'd4: data = game_table[49:40];
			4'd5: data = game_table[59:50];
			4'd6: data = game_table[69:60];
			4'd7: data = game_table[79:70];
			4'd8: data = game_table[89:80];
			4'd9: data = game_table[99:90];
			default: data = 10'd0;
		endcase
	end

//-------------------


  always @*
   begin
    if(data[9]==0)
        in_temp9 = 6'b0000_00;
    else 
        in_temp9 = 6'b1111_11;

    if(data[8]==0)
        in_temp8 = 6'b0000_00;
    else 
        in_temp8 = 6'b1111_11;

    if(data[7]==0)
        in_temp7 = 6'b0000_00;
    else 
        in_temp7 = 6'b1111_11;

    if(data[6]==0)
        in_temp6 = 6'b0000_00;
    else 
        in_temp6 = 6'b1111_11;

    if(data[5]==0)
        in_temp5 = 6'b0000_00;
    else 
        in_temp5 = 6'b1111_11;

    if(data[4]==0)
        in_temp4 = 6'b0000_00;
    else 
        in_temp4 = 6'b1111_11;

    if(data[3]==0)
        in_temp3 = 6'b0000_00;
    else 
        in_temp3 = 6'b1111_11;

    if(data[2]==0)
        in_temp2 = 6'b0000_00;
    else 
        in_temp2 = 6'b1111_11;

    if(data[1]==0)
        in_temp1 = 6'b0000_00;
    else 
        in_temp1 = 6'b1111_11;

    if(data[0]==0)
        in_temp0 = 6'b0000_00;
    else 
        in_temp0 = 6'b1111_11;
  end
  
  RAM R1(
    .clka(clk),
    .wea(wen),
    .addra(addr),
    .dina(data_in),
    .douta(data_out_64)
  );

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      addr = 6'd0;
      cnt = 2'd0;
      mem = 512'd0;
      state = IDLE;
      flag = 1'b0;
      counter_word = 6'd0;
      data_out = 8'd0;
      data_valid = 1'd0;
      wen = 1'b1;
      temp_change = 1'b0;
    end else begin
      addr = addr_next;
      cnt = cnt_next;
      mem = mem_next;
      state = state_next;
      flag = flag_next;
      counter_word = counter_word_next;
      data_out = data_out_next;
      data_valid = data_valid_next;
      wen = wen_next;
      temp_change = temp_change_next;
    end
  end

  always @(*) begin
    state_next = state;
    case(state)
      IDLE: begin
        if (wen) begin
          state_next = WRITE;
        end else begin
          state_next = GETDATA;
        end
      end
      WRITE: begin
        if (addr == 6'd63) begin
          state_next = GETDATA;
        end
      end
      GETDATA: begin
        if (flag == 1'b1) begin
          state_next = TRANSDATA;
        end
      end
      TRANSDATA: begin
        if (addr == 6'd0 && counter_word == 6'd63 && en) begin
          state_next = IDLE;
        end else if (counter_word == 6'd63 && en) begin
          state_next = GETDATA;
        end
      end
    endcase
  end

  always @(*) begin
    addr_next = addr;
    data_in = 64'd0;
    cnt_next = cnt;
    mem_next = mem;
    flag_next = 1'b0;
    counter_word_next = counter_word;
    data_valid_next = 1'd0;
    data_out_next = 8'd0;
    case(state)
      WRITE: begin
        addr_next = addr + 1'b1;
        if(addr == 6'd0 || addr == 6'd1 || addr == 6'd62 || addr == 6'd63)
          data_in = 64'b11111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111;
        else
          data_in = {2'b11,in_temp0, in_temp1, in_temp2, in_temp3,in_temp4,in_temp5,in_temp6,in_temp7,in_temp8,in_temp9,2'b11};

        if (addr == 6'd7 || addr == 6'd13 || addr == 6'd19 || addr == 6'd25 || addr == 6'd31 || addr == 6'd37 || addr == 6'd43 || addr == 6'd49 || addr == 6'd55 || addr == 6'd61)
        begin
          if(cnt == 4'd9)
            cnt_next =4'd0;
          else
            cnt_next = cnt + 1'd1;
        end
      end
      GETDATA: begin
        if (!flag) begin
          addr_next = addr + 1'b1;
        end
        if ((addr%8) == 6'd7) begin
          flag_next = 1'b1;
        end
        if ((addr%8) >= 6'd1 || flag) begin
          mem_next[(((addr-1)%8)*64)+:64] = data_out_64;
        end
      end
      TRANSDATA: begin
        if (en) begin
          counter_word_next = counter_word + 1'b1;
          data_valid_next = 1'b1;
          data_out_next = {mem[511 - counter_word],
            mem[447 - counter_word],
            mem[383 - counter_word],
            mem[319 - counter_word],
            mem[255 - counter_word],
            mem[191 - counter_word],
            mem[127 - counter_word],
            mem[63 - counter_word]};
        end
      end
    endcase
  end
 
  //wen control
  always @(*) begin
    wen_next = wen;
    temp_change_next = temp_change;
    if (change) begin
      temp_change_next = 1'b1;
    end
    if (state == WRITE && addr == 6'd63) begin
      wen_next = 1'b0;
    end
    if (state == TRANSDATA && addr == 6'd0 && counter_word == 6'd63 && temp_change == 1'b1) begin
      temp_change_next = 1'b0;
      wen_next = 1'b1;
    end
  end
endmodule
