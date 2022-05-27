vsim -gui work.memorystage
# vsim -gui work.memorystage 
# Start time: 21:25:52 on May 27,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.memorystage(memorystage_arch)
add wave -position insertpoint sim:/memorystage/*
force -freeze sim:/memorystage/Rsrc1_mem_in 16#00000001 0
force -freeze sim:/memorystage/Rsrc2_mem_in 16#00000002 0
force -freeze sim:/memorystage/execution_output 16#ABCDEEFF 0
force -freeze sim:/memorystage/Rd_Rs_in 100 0
run
