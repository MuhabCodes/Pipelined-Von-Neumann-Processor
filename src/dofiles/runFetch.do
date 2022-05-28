vsim -gui work.fetch_stage
add wave -position insertpoint sim:/fetch_stage/*
force -freeze sim:/fetch_stage/clk 1 0, 0 {50 ps} -r 100

# Case 1: Write memory address to pc
force -freeze sim:/fetch_stage/pc_src 0 0
force -freeze sim:/fetch_stage/control_signal 1 0
force -freeze sim:/fetch_stage/stack_en 0 0
force -freeze sim:/fetch_stage/fetch_memory 0 0
force -freeze sim:/fetch_stage/int_en 0 0
force -freeze sim:/fetch_stage/reset_in 0 0
force -freeze sim:/fetch_stage/intr_in 0 0
force -freeze sim:/fetch_stage/return_en 0 0
force -freeze sim:/fetch_stage/pc_write 1 0
force -freeze sim:/fetch_stage/memory_block_output 16#AAAAAAAA 0
run
# Case 2: set value to pc_buffer, don't take it, check next pc
# should be AAAAAAAB
force -freeze sim:/fetch_stage/PC_buffer 16#A0A00000 0
force -freeze sim:/fetch_stage/control_signal 0 0
run
# Case 3: take buffered pc
force -freeze sim:/fetch_stage/return_en 1 0
run
# Case 4: take jump address in EA_IN 
force -freeze sim:/fetch_stage/pc_src 1 0
force -freeze sim:/fetch_stage/EA_in 16#CCCC0000 0
run
force -freeze sim:/fetch_stage/reset_in 1 0
run