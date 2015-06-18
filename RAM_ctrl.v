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
  input clk,
  input rst_n,
  input change,
  input [3:0]temp0,
  input [3:0]temp1,
  input [3:0]temp2,
  input [3:0]temp3,
  input [3:0]temp4,
  input [3:0]temp5,
  input [3:0]temp6,
  input [3:0]temp7,
  input [3:0]temp8,
  input [3:0]temp9,
  input [3:0]temp10,
  input [3:0]temp11,
  input en,
  output reg [7:0] data_out,
  output reg data_valid
);

  parameter mark_1 = 256'h 0000_0000_03c0_03c0_03c0_03c0_03c0_03c0_03c0_03c0_03c0_03c0_03c0_03c0_0000_0000;
  parameter mark_2 = 256'h 0000_0000_3ffc_3ffc_001c_001c_001c_3ffc_3ffc_3800_3800_3800_3ffc_3ffc_0000_0000;
  parameter mark_3 = 256'h 0000_0000_3ffc_3ffc_001c_001c_001c_3ffc_3ffc_001c_001c_001c_3ffc_3ffc_0000_0000;
  parameter mark_4 = 256'h 0000_0000_3c3c_3c3c_3c3c_3c3c_3ffc_3ffc_3ffc_3ffc_003c_003c_003c_003c_0000_0000;
  parameter mark_5 = 256'h 0000_0000_3ffc_3ffc_3800_3800_3800_3ffc_3ffc_001c_001c_001c_3ffc_3ffc_0000_0000;
  parameter mark_6 = 256'h 0000_0000_3ffc_3ffc_3800_3800_3800_3ffc_3ffc_381c_381c_381c_3ffc_3ffc_0000_0000;
  parameter mark_7 = 256'h 0000_0000_3ffc_3ffc_3ffc_3ffc_003c_003c_003c_003c_003c_003c_003c_003c_0000_0000;
  parameter mark_8 = 256'h 0000_0000_3ffc_3ffc_381c_381c_381c_3ffc_3ffc_381c_381c_381c_3ffc_3ffc_0000_0000;
  parameter mark_9 = 256'h 0000_0000_3ffc_3ffc_381c_381c_381c_3ffc_3ffc_001c_001c_001c_3ffc_3ffc_0000_0000;  
  parameter mark_0 = 256'h 0000_0000_3ffc_3ffc_3ffc_381c_381c_381c_381c_381c_381c_3ffc_3ffc_3ffc_0000_0000;
  parameter mark_def = 16'd0;
  parameter mark_A = 256'h 0000_0000_3ffc_3ffc_3ffc_381c_381c_381c_3ffc_3ffc_3ffc_381c_381c_381c_0000_0000;
  parameter mark_P = 256'h 0000_0000_3ffc_3ffc_3ffc_381c_381c_381c_3ffc_3ffc_3ffc_3800_3800_3800_0000_0000;
  parameter mark_M = 256'h 0000_0000_3c3c_3c3c_366c_366c_33cc_33cc_300c_300c_300c_300c_300c_300c_0000_0000;
  
  parameter IDLE  = 2'd0;
  parameter WRITE = 2'd1;
  parameter GETDATA = 2'd2;
  parameter TRANSDATA = 2'd3;

  reg [5:0] addr, addr_next;
  reg [5:0] counter_word, counter_word_next;
  wire [63:0] data_out_64;
  reg [63:0] data_in;
  reg [15:0] in_temp0, in_temp1, in_temp2, in_temp3;
  reg [1:0] cnt, cnt_next;  //count mark row
  reg [511:0] mem, mem_next;
  reg [1:0] state, state_next;
  reg flag, flag_next;
  reg [7:0] data_out_next;
  reg data_valid_next;
  reg wen, wen_next;
  reg temp_change, temp_change_next;
  reg [3:0]digit0,digit1,digit2,digit3;
  
 always@* begin
		case(cnt)
			2'd0: begin
			digit0= 4'd0;
			digit1= 4'd0;
			digit2= temp8;
			digit3= temp9;
			end
			2'd1: begin
			digit0=temp7;
			digit1=temp6;
			digit2=temp5;
			digit3=temp4;
			end
			2'd2: begin
			digit0=temp3;
			digit1=temp2;
			digit2=temp1;
			digit3=temp0;
			end
			2'd3: begin
			digit0= 4'd0;
			digit1= 4'd0;
			digit2= temp11;
			digit3= temp10;
			end
			default: begin
			digit0= 4'd0;
			digit1= 4'd0;
			digit2= 4'd0;
			digit3= 4'd0;
			end
		endcase

		case(digit0)
			4'h0: in_temp0 = mark_0[(240-((addr%16)*16))+:16];
			4'h1: in_temp0 = mark_1[(240-((addr%16)*16))+:16];
			4'h2: in_temp0 = mark_2[(240-((addr%16)*16))+:16];
			4'h3: in_temp0 = mark_3[(240-((addr%16)*16))+:16];
			4'h4: in_temp0 = mark_4[(240-((addr%16)*16))+:16];
			4'h5: in_temp0 = mark_5[(240-((addr%16)*16))+:16];
			4'h6: in_temp0 = mark_6[(240-((addr%16)*16))+:16];
			4'h7: in_temp0 = mark_7[(240-((addr%16)*16))+:16];
			4'h8: in_temp0 = mark_8[(240-((addr%16)*16))+:16];
			4'd9: in_temp0 = mark_9[(240-((addr%16)*16))+:16];
			4'hb: in_temp0 = mark_A[(240-((addr%16)*16))+:16];
			4'hc: in_temp0 = mark_M[(240-((addr%16)*16))+:16];
			4'hd: in_temp0 = mark_P[(240-((addr%16)*16))+:16];
			default: in_temp0 = mark_def;
		endcase
		
		case(digit1)
			4'h0: in_temp1 = mark_0[(240-((addr%16)*16))+:16];
			4'h1: in_temp1 = mark_1[(240-((addr%16)*16))+:16];
			4'h2: in_temp1 = mark_2[(240-((addr%16)*16))+:16];
			4'h3: in_temp1 = mark_3[(240-((addr%16)*16))+:16];
			4'h4: in_temp1 = mark_4[(240-((addr%16)*16))+:16];
			4'h5: in_temp1 = mark_5[(240-((addr%16)*16))+:16];
			4'h6: in_temp1 = mark_6[(240-((addr%16)*16))+:16];
			4'h7: in_temp1 = mark_7[(240-((addr%16)*16))+:16];
			4'h8: in_temp1 = mark_8[(240-((addr%16)*16))+:16];
			4'h9: in_temp1 = mark_9[(240-((addr%16)*16))+:16];
			4'hb: in_temp1 = mark_A[(240-((addr%16)*16))+:16];
			4'hc: in_temp1 = mark_M[(240-((addr%16)*16))+:16];
			4'hd: in_temp1 = mark_P[(240-((addr%16)*16))+:16];
			default: in_temp1 = mark_def;
		endcase
		case(digit2)
			4'h0: in_temp2 = mark_0[(240-((addr%16)*16))+:16];
			4'h1: in_temp2 = mark_1[(240-((addr%16)*16))+:16];
			4'h2: in_temp2 = mark_2[(240-((addr%16)*16))+:16];
			4'h3: in_temp2 = mark_3[(240-((addr%16)*16))+:16];
			4'h4: in_temp2 = mark_4[(240-((addr%16)*16))+:16];
			4'h5: in_temp2 = mark_5[(240-((addr%16)*16))+:16];
			4'h6: in_temp2 = mark_6[(240-((addr%16)*16))+:16];
			4'h7: in_temp2 = mark_7[(240-((addr%16)*16))+:16];
			4'h8: in_temp2 = mark_8[(240-((addr%16)*16))+:16];
			4'h9: in_temp2 = mark_9[(240-((addr%16)*16))+:16];
			4'hb: in_temp2 = mark_A[(240-((addr%16)*16))+:16];
			4'hc: in_temp2 = mark_M[(240-((addr%16)*16))+:16];
			4'hd: in_temp2 = mark_P[(240-((addr%16)*16))+:16];
			default: in_temp2 = mark_def;
		endcase
		case(digit3)
			4'h0: in_temp3 = mark_0[(240-((addr%16)*16))+:16];
			4'h1: in_temp3 = mark_1[(240-((addr%16)*16))+:16];
			4'h2: in_temp3 = mark_2[(240-((addr%16)*16))+:16];
			4'h3: in_temp3 = mark_3[(240-((addr%16)*16))+:16];
			4'h4: in_temp3 = mark_4[(240-((addr%16)*16))+:16];
			4'h5: in_temp3 = mark_5[(240-((addr%16)*16))+:16];
			4'h6: in_temp3 = mark_6[(240-((addr%16)*16))+:16];
			4'h7: in_temp3 = mark_7[(240-((addr%16)*16))+:16];
			4'h8: in_temp3 = mark_8[(240-((addr%16)*16))+:16];
			4'h9: in_temp3 = mark_9[(240-((addr%16)*16))+:16];
			4'hb: in_temp3 = mark_A[(240-((addr%16)*16))+:16];
			4'hc: in_temp3 = mark_M[(240-((addr%16)*16))+:16];
			4'hd: in_temp3 = mark_P[(240-((addr%16)*16))+:16];
			default: in_temp3 = mark_def;
		endcase
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
        data_in = {in_temp0, in_temp1, in_temp2, in_temp3};
        if (addr == 6'd15 || addr == 6'd31 || addr == 6'd47 || addr == 6'd63) begin
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
