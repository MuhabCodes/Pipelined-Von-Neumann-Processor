library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity programCounter is 

port ( CLK            : in  std_logic ;
       input		: in  std_logic_vector (31 downTO 0);
        
       output		: out std_logic_vector (31 downTO 0) );

end programCounter ;


Architecture arch_programCounter of programCounter is 
BEGIN
PROCESS (Clk)
BEGIN
if rising_edge(Clk) THEN
output <= input;
end if ;
END PROCESS;
end Architecture;



