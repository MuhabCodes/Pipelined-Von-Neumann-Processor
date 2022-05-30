vsim -gui work.pipelinedprocessor
radix -hexadecimal
mem load -i {C:\Users\habib\Desktop\Computer architechture\Project\Pipelined-Von-Neumann-Processor\src\assembler\mem\TwoOperand.mem} -update_properties /pipelinedprocessor/ram/mem
add wave -position insertpoint  \
sim:/pipelinedprocessor/clk
add wave -position insertpoint  \
sim:/pipelinedprocessor/INTR_IN
add wave -position insertpoint  \
sim:/pipelinedprocessor/RESET_IN
add wave -position insertpoint  \
sim:/pipelinedprocessor/Dstage/RegistersComp/regOut
add wave -position insertpoint  \
sim:/pipelinedprocessor/OUT_PORT
add wave -position insertpoint  \
sim:/pipelinedprocessor/IN_PORT
add wave -position insertpoint  \
sim:/pipelinedprocessor/OUT_PORT
add wave -position insertpoint sim:/pipelinedprocessor/Dstage/*
add wave -position insertpoint sim:/pipelinedprocessor/ex/*
force -freeze sim:/pipelinedprocessor/RESET_IN 1 0
force -freeze sim:/pipelinedprocessor/INTR_IN 0 0
force -freeze sim:/pipelinedprocessor/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/pipelinedprocessor/RESET_IN 0 0
force -freeze sim:/pipelinedprocessor/IN_PORT 16#00000005 0
run
run
run
run
force -freeze sim:/pipelinedprocessor/IN_PORT 00000019 0
run
force -freeze sim:/pipelinedprocessor/IN_PORT FFFFFFFF 0
run
force -freeze sim:/pipelinedprocessor/ex/IN_PORT FFFFF320 0
run
run
run

