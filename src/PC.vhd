library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity program_counter is 
port ( 
    clk: in  std_logic ;
    pc_write: in std_logic;
    input: in  std_logic_vector (31 downto 0);
    output: out std_logic_vector (31 downto 0)
);
end entity; 



architecture arch_programCounter of program_counter is 
begin
process (clk)
begin
    if rising_edge(clk) then
        if(pc_write ='1') then
            output <= input;
        end if;
    end if ;
end process;
end architecture;



