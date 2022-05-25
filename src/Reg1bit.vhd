
library ieee;
use ieee.std_logic_1164.all;

entity reg1bit is 
	
	port(
		d: in std_logic;
		q: out	std_logic;
		en, clk, rst: in std_logic
		);
end reg1bit ;

architecture reg1bit_arch of reg1bit  is
begin

	q <= '0' when rst='1' else d when en='1';

end reg1bit_arch;