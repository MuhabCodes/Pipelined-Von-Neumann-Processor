Library ieee;
use ieee.std_logic_1164.all;

entity buffer_IF_ID is 
port(
	clk : in std_logic;
	flush : in std_logic;
	write_en : in std_logic;
	--- opcode_in : in std_logic_vector(29 downto 0);
	instruction_in : in std_logic_vector(31 downto 0);
	pc_in : in std_logic_vector(31 downto 0);
	--- opcode : out std_logic_vector(29 downto 0);
	instruction : out std_logic_vector(31 downto 0);
	pc : out std_logic_vector(31 downto 0)
);

end entity;

architecture struct of buffer_IF_ID is
begin
	process(flush, write_en, clk)
	begin
		if (flush = '1') then
			instruction <= (others => '0');
			pc <= (others => '0');
		elsif (falling_edge(clk) and write_en = '1') then
			instruction <= instruction_in;
			pc <= pc_in;
		end if;
	end process;
end architecture;