vsim -gui work.pipelinedprocessor
radix -hexadecimal
mem load -i {C:/Users/Muhab/OneDrive/Documents/GitHub/Pipelined-Von-Neumann-Processor/src/assembler/mem/OneOperand.mem} -update_properties /pipelinedprocessor/ram/mem
add wave -position insertpoint  \
sim:/pipelinedprocessor/clk \
sim:/pipelinedprocessor/INTR_IN \
sim:/pipelinedprocessor/RESET_IN \
sim:/pipelinedprocessor/reset_or_interrupt
add wave -position insertpoint  \
sim:/pipelinedprocessor/IN_PORT \
sim:/pipelinedprocessor/OUT_PORT
add wave -position insertpoint sim:/pipelinedprocessor/fetch/*
add wave -position insertpoint sim:/pipelinedprocessor/Dstage/RegistersComp/*
add wave -position insertpoint sim:/pipelinedprocessor/Dstage/*
add wave -position insertpoint sim:/pipelinedprocessor/controlUnit/*
add wave -position insertpoint sim:/pipelinedprocessor/bufferDE/*
add wave -position insertpoint sim:/pipelinedprocessor/ex/*
add wave -position insertpoint sim:/pipelinedprocessor/bufferEM/*
add wave -position insertpoint sim:/pipelinedprocessor/forwarding/*
add wave -position insertpoint sim:/pipelinedprocessor/mem1/*
add wave -position insertpoint sim:/pipelinedprocessor/bufferMW/*
add wave -position insertpoint sim:/pipelinedprocessor/wb/*
force -freeze sim:/pipelinedprocessor/RESET_IN 1 0
force -freeze sim:/pipelinedprocessor/INTR_IN 0 0
force -freeze sim:/pipelinedprocessor/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/pipelinedprocessor/IN_PORT 16#00000005 0
force -freeze sim:/pipelinedprocessor/RESET_IN 0 0
run
run
run
run
run
run