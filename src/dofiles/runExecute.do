vsim -gui work.executestage
# vsim -gui work.executestage 
# Start time: 19:46:55 on May 27,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.executestage(executestage_arch)
# Loading work.mux4x1(struct)
# Loading work.mux2x1(struct)
# Loading work.alu(alu_arch)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.adder(struct)
# Loading ieee.numeric_std(body)
# Loading work.subtractor(subtractor_arch)
# Loading work.ccr(ccr_architecture)
# Loading work.reg1bit(reg1bit_arch)
# Loading work.saveflags(save_architecture)
# Loading work.reg(struct)
add wave -position insertpoint sim:/executestage/*
force -freeze sim:/executestage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/executestage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/executestage/IN_PORT 16#00000022 0
force -freeze sim:/executestage/in_select 1 0
run
force -freeze sim:/executestage/isForward2 10 0
force -freeze sim:/executestage/Rsrc2_instruction 16#00000001 0
force -freeze sim:/executestage/isForward1 10 0
force -freeze sim:/executestage/Rsrc1_instruction 16#00000001 0
force -freeze sim:/executestage/ALU_src 0 0
force -freeze sim:/executestage/ALU_op 10010 0
run
force -freeze sim:/executestage/in_select 0 0
run
force -freeze sim:/executestage/Rsrc2_mem_in 16#00000002 0
force -freeze sim:/executestage/Rsrc2_wb_in 16#00000003 0
force -freeze sim:/executestage/Rsrc1_mem_in 16#00000002 0
force -freeze sim:/executestage/Rsrc1_wb_in 16#00000003 0
force -freeze sim:/executestage/ALU_src 1 0
run
force -freeze sim:/executestage/in_select 1 0
run
force -freeze sim:/executestage/IMM 16#00000006 0
force -freeze sim:/executestage/ALU_src 0 0
run
force -freeze sim:/executestage/in_select 0 0
run
force -freeze sim:/executestage/ALU_src 1 0
force -freeze sim:/executestage/ALU_op 10011 0
run
force -freeze sim:/executestage/Rd_in 000 0
force -freeze sim:/executestage/Rs_in 001 0
force -freeze sim:/executestage/Rt_in 010 0
force -freeze sim:/executestage/restore_flags 0 0
force -freeze sim:/executestage/CCR_write_en 111 0
force -freeze sim:/executestage/INT_en 0 0
force -freeze sim:/executestage/flush_ex 0 0
run
force -freeze sim:/executestage/flush_ex 1 0
run
force -freeze sim:/executestage/ALU_op 01110 0
run
force -freeze sim:/executestage/ALU_op 01111 0
run
force -freeze sim:/executestage/in_select 1 0
force -freeze sim:/executestage/in_select 0 0
force -freeze sim:/executestage/ALU_src 0 0
run
force -freeze sim:/executestage/isForward2 00 0
run
force -freeze sim:/executestage/isForward1 00 0
run
force -freeze sim:/executestage/Rsrc1_mem_in 16#FFFF0000 0
force -freeze sim:/executestage/IMM 16#FF00FFFF 0
force -freeze sim:/executestage/ALU_op 10100 0
run
force -freeze sim:/executestage/ALU_op 10010 0
run
force -freeze sim:/executestage/restore_flags 1 0
force -freeze sim:/executestage/INT_en 1 0
force -freeze sim:/executestage/restore_flags 0 0
run
force -freeze sim:/executestage/restore_flags 1 0
force -freeze sim:/executestage/IMM 16#00000000 0
run
runforce -freeze sim:/executestage/restore_flags 0 0
run
force -freeze sim:/executestage/INT_en 0 0
run
force -freeze sim:/executestage/INT_en 1 0
run



