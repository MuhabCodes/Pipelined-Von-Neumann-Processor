vsim -gui work.wbstage
# vsim -gui work.wbstage 
# Start time: 21:16:54 on May 27,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.wbstage(wbstage_arch)
# Loading work.mux2x1(struct)
add wave -position insertpoint sim:/wbstage/*
force -freeze sim:/wbstage/Write_address_in 010 0
force -freeze sim:/wbstage/Execute_out 16#00500011 0
force -freeze sim:/wbstage/Load_value 16#ABCDEF00 0
force -freeze sim:/wbstage/mem_to_reg 0 0
force -freeze sim:/wbstage/forward_in 011 0
force -freeze sim:/wbstage/Rsrc1_wb_in 16#00000002 0
force -freeze sim:/wbstage/Rsrc2_wb_in 16#00000004 0
force -freeze sim:/wbstage/wb_enable_in 1 0
run
force -freeze sim:/wbstage/mem_to_reg 1 0
run