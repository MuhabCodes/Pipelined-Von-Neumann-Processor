vsim -gui work.pipelinedprocessor
radix -hexadecimal
mem load -i {C:/Users/Muhab/OneDrive/Documents/GitHub/Pipelined-Von-Neumann-Processor/src/assembler/mem/Branch.mem} -update_properties /pipelinedprocessor/ram/mem
add wave -position insertpoint  \
sim:/pipelinedprocessor/clk
add wave -position insertpoint  \
sim:/pipelinedprocessor/IN_PORT
add wave -position insertpoint  \
sim:/pipelinedprocessor/OUT_PORT
add wave -position insertpoint  \
sim:/pipelinedprocessor/ex/CCR_output
add wave -position insertpoint  \
sim:/pipelinedprocessor/RESET_IN
add wave -position insertpoint  \
sim:/pipelinedprocessor/INTR_IN
add wave -position insertpoint sim:/pipelinedprocessor/Dstage/*
add wave -position insertpoint sim:/pipelinedprocessor/bufferDE/*
add wave -position insertpoint sim:/pipelinedprocessor/controlUnit/*
add wave -position insertpoint sim:/pipelinedprocessor/fetch/*
force -freeze sim:/pipelinedprocessor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/pipelinedprocessor/RESET_IN 1 0
force -freeze sim:/pipelinedprocessor/INTR_IN 0 0
run
force -freeze sim:/pipelinedprocessor/IN_PORT 16#00000030 0
force -freeze sim:/pipelinedprocessor/RESET_IN 0 0
run
run
run
force -freeze sim:/pipelinedprocessor/ex/IN_PORT 00000050 0
run
force -freeze sim:/pipelinedprocessor/ex/IN_PORT 00000100 0
run
force -freeze sim:/pipelinedprocessor/ex/IN_PORT 00000300 0
run
run
run