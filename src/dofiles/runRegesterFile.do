vsim -gui work.registersfile
# Case1: Write 8 As to reg4 
add wave -position insertpoint sim:/registersfile/*
force -freeze sim:/registersfile/reg_write 1 0
force -freeze sim:/registersfile/write_reg 100 0
force -freeze sim:/registersfile/write_data 16#AAAAAAAA 0
run
# Case 2: read reg4 in reg_data1 and write 8 Bs to reg3
force -freeze sim:/registersfile/rsrc1 100 0
force -freeze sim:/registersfile/write_reg 010 0
force -freeze sim:/registersfile/write_data 16#BBBBBBBB 0
run