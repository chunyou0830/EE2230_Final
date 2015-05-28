`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:30:43 05/14/2015 
// Design Name: 
// Module Name:    speaker 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module speaker(
	 clk,//clk fron crystal
	 rst_n,//active low reset
	 audio_appsel,//playing mode selection
	 audio_sysclk,//control clock for DAC(from crystal)
	 audio_bck,//bit clock of audio data(5MHz)
	 audio_ws,//left/right parallel to serial control 
	 audio_data,//serial output audio data
	 Do,
	 Re,
	 Mi,
	 add_vol,
	 sub_vol,
	 display,
    ftsd_ctl,
	 add_vol_1,sub_vol_1
    );
    
	 //I/O declaration
	 input add_vol,sub_vol;
	 input Do,Re,Mi;
	 input clk;//clk fron crystal
	 input rst_n;//active low reset 
	 output audio_appsel;//playing mode selection
	 output audio_sysclk;//control clock for DAC(from crystal)
	 output audio_bck;//bit clock of audio data(5MHz)
	 output audio_ws;//left/right parallel to serial control 
	 output audio_data;//serial output audio data
	 output [14:0]display;
    output [3:0]ftsd_ctl;
	 output add_vol_1,sub_vol_1;
	 //Declare internal nodes
	 wire [15:0]audio_in_left,audio_in_right; 
	 wire clk100;
    wire Do_1,Re_1,Mi_1,add_vol_1,sub_vol_1;
	 wire [7:0]level;
	 wire buffer2;
	 wire [1:0]scan_clk;
	 wire [15:0]volumn;
	 wire clk1;
	 wire [3:0]ftsd_in;
	 wire [1:0]hun;
	 wire [3:0]digit,decimal;
	 reg  [19:0]sound;
	 
	 //Note generation 
	 debounce de_DO(
		.clk(clk100),
	   .rst_n(rst_n),
	   .pb_in(Do),
	   .pb_debounced(Do_1)
	 );
	 debounce de_Re(
		.clk(clk100),
	   .rst_n(rst_n),
	   .pb_in(Re),
	   .pb_debounced(Re_1)
	 );
	 debounce de_Mi(
		.clk(clk100),
	   .rst_n(rst_n),
	   .pb_in(Mi),
	   .pb_debounced(Mi_1)
	 );
	 debounce up_vol(
		.clk(clk100),
	   .rst_n(rst_n),
	   .pb_in(add_vol),
	   .pb_debounced(add_vol_1)
	 );
	 debounce down_vol(
		.clk(clk100),
	   .rst_n(rst_n),
	   .pb_in(sub_vol),
	   .pb_debounced(sub_vol_1)
	 );
	 
	 always@*
		if(Do_1==1)
			sound=20'd76628;
		else if(Re_1==1)
			sound=20'd68259;
		else if(Mi_1==1)
			sound=20'd60606;
		else 
			sound=20'd0;
			
	 buzzer_control buzzer(
		.clk(clk),//clk from crystal
		.rst_n(rst_n),//active low reset
		.note_div(sound),//div for note generation
		.audio_left(audio_in_left),//left sound audio
		.audio_right(audio_in_right),//right sound audio
		.volumn(volumn)
	 );
	 
	 speaker_control speak_con(
		.clk(clk),
		.rst_n(rst_n),
		.audio_in_left(audio_in_left),
		.audio_in_right(audio_in_right),
		.audio_appsel(audio_appsel),
		.audio_sysclk(audio_sysclk),
		.audio_bck(audio_bck),
		.audio_ws(audio_ws),
		.audio_data(audio_data)
	 );
	 
	 control_volumn control(
		.q(level),//counter output
	   .clk(clk1),//global clock
	   .rst_n(rst_n),//active low reset 
	   .volumn(volumn),
      .increase(add_vol_1),
	   .decrease(sub_vol_1)
	 );
	 
	 binary_to_BCD  converter_level(
		.A(level),
		.ONES(digit),
		.TENS(decimal),
		.HUNDREDS(hun)
	 );
	 freqdiv clk1Hz(
			.clk_40M(clk), // clock from the 40MHz oscillator
         .rst_n(rst_n), // low active reset
         .clk_1(clk1), // divided clock output
         .clk_debounce(buffer2), // clock control for debounce circuit
         .clk_ftsd_scan(scan_clk)
	 );
	 
	 scan_ctl   scan(
		 .in0(4'd0), // 1st input
		 .in1(4'd0), // 2nd input
		 .in2(decimal), // 3rd input
		 .in3(digit),  // 4th input
		 .ftsd_ctl_en(scan_clk), // divided clock for scan control
		 .ftsd_ctl(ftsd_ctl), // ftsd display control signal 
       .ftsd_in(ftsd_in) // output to ftsd display
	 );
	 
	 ftsd ftsd(
	  .in(ftsd_in),  // binary input
     .display(display) // 14-segment display output
    );

	 clk_generator clk_gen(
		.clk(clk),
	   .rst_n(rst_n),
	   .clk_100(clk100)
	 );

endmodule
