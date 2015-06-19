
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name LCD_Convert_Test -dir "D:/Programming/EE2230_Final/LCD_Convert_Test/planAhead_run_2" -part xc6slx16csg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "LCD_Convert_Test.ucf" [current_fileset -constrset]
add_files [list {ipcore_dir/RAM.ngc}]
set hdlfile [add_files [list {ipcore_dir/RAM.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {RAM_ctrl.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {LCD_control.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {keypad_scan.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {GameRAMControll.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ct_clkdivider.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {LCD_Control_Test.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top LCD_Control_Test $srcset
add_files [list {LCD_Convert_Test.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/RAM.ncf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx16csg324-3
