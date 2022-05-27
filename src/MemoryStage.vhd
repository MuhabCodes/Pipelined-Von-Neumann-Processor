Library ieee;
use ieee.std_logic_1164.all;

ENTITY MemoryStage IS 
PORT(

 Rsrc1_mem_in : in std_logic_vector(31 downto 0); --comming from buffer EX/MEM-> it will go into the write data of the memory
 Rsrc2_mem_in : in std_logic_vector(31 downto 0);
 Rsrc1_mem_out : out std_logic_vector(31 downto 0);--going to execute stage and the MEM/WB buffer and data write 
 Rsrc2_mem_out : out std_logic_vector(31 downto 0);--to be used in forwarding

 execution_output: in std_logic_vector(31 downto 0); --value comming from execute stage (Rsrc2+offset)-> memory address
 
 mem_stage_output: out std_logic_vector(31 downto 0);--could be store adress OR vslue to be passed to MEM/WB buffer
 
 Rd_Rs_in: in std_logic_vector(2 downto 0);
 Rd_Rs_out: out std_logic_vector(2 downto 0)--going to forwarding unit and  MEM/WB buffer
 
);--fih selk mesh fahmino dah beyrou7 le mux abl el pc
END ENTITY;

ARCHITECTURE MemoryStage_arch OF MemoryStage IS
BEGIN
--setting input output lines
Rsrc1_mem_out<=Rsrc1_mem_in;
Rsrc2_mem_out<=Rsrc2_mem_in;
Rd_Rs_out<=  Rd_Rs_in;
mem_stage_output<= execution_output;

END ARCHITECTURE;
