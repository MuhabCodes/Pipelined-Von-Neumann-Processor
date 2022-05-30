vsim -gui work.pipelinedprocessor
radix -hexadecimal
mem load -i {C:/Users/Muhab/OneDrive/Documents/GitHub/Pipelined-Von-Neumann-Processor/src/assembler/mem/TwoOperand.mem} -update_properties /pipelinedprocessor/ram/mem
add wave -position insertpoint sim:/pipelinedprocessor/fetch/*
add wave -position insertpoint sim:/pipelinedprocessor/bufferFD/*
add wave -position insertpoint sim:/pipelinedprocessor/Dstage/*
add wave -position insertpoint sim:/pipelinedprocessor/bufferDE/*
add wave -position insertpoint sim:/pipelinedprocessor/controlUnit/*
add wave -position insertpoint sim:/pipelinedprocessor/ram/*
add wave -position insertpoint  \
sim:/pipelinedprocessor/clk
add wave -position insertpoint  \
sim:/pipelinedprocessor/INTR_IN
add wave -position insertpoint  \
sim:/pipelinedprocessor/RESET_IN
add wave -position insertpoint  \
sim:/pipelinedprocessor/Dstage/RegistersComp/regOut
add wave -position insertpoint  \
sim:/pipelinedprocessor/bufferFD/pc
add wave -position insertpoint  \
sim:/pipelinedprocessor/ram/sp_out
add wave -position insertpoint  \
sim:/pipelinedprocessor/ram/sp_in
add wave -position insertpoint  \
sim:/pipelinedprocessor/ex/CCR_output
add wave -position insertpoint  \
sim:/pipelinedprocessor/IN_PORT
add wave -position insertpoint  \
sim:/pipelinedprocessor/OUT_PORT
force -freeze sim:/pipelinedprocessor/RESET_IN 1 0
force -freeze sim:/pipelinedprocessor/INTR_IN 0 0
force -freeze sim:/pipelinedprocessor/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/pipelinedprocessor/IN_PORT 16#00000005 0
force -freeze sim:/pipelinedprocessor/RESET_IN 0 0
run
force -freeze sim:/pipelinedprocessor/INTR_IN 1 0
run
force -freeze sim:/pipelinedprocessor/INTR_IN 0 0
run