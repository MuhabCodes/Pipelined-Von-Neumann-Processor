vsim -gui work.alu
# vsim -gui work.alu 
# Start time: 01:45:29 on May 26,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.alu(alu_arch)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.adder(struct)
# Loading work.subtractor(subtractor_arch)
add wave -position insertpoint sim:/alu/*
force -freeze sim:/alu/R1 16#FFFFFFFF 0
force -freeze sim:/alu/R2 16#00000002 0
force -freeze sim:/alu/ALU_op 10011 0
run


