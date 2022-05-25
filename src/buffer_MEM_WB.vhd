Library ieee;
use ieee.std_logic_1164.all;

entity buffer_MEM_WB is 
port(
	clk : in std_logic;
	flush : in std_logic;
	--- INPUTS
	--- START stored control signals
	wb_signal_in : in std_logic;
	--- END stored control signals
	opcode_in : in std_logic_vector(31 downto 0);
	alu_in : in std_logic_vector(31 downto 0);
	reg_in : in std_logic_vector(2 downto 0);
	--- OUTPUTS
	--- START stored control signals
	mem_signal : out std_logic;
	wb_signal : out std_logic;
	--- END stored control signals
	opcode : out std_logic_vector(31 downto 0);
	alu : out std_logic_vector(31 downto 0);
	reg : out std_logic_vector(2 downto 0)
);

end entity;

architecture struct of buffer_MEM_WB is
begin
	process(flush, clk)
	begin
		if (flush = '1') then
		wb_signal <= '0';
		opcode <= (others => '0');
		alu <= (others => '0');
		reg <= (others => '0');
		elsif rising_edge(clk) then
			wb_signal <= wb_signal_in;
			opcode <= opcode_in;
			alu <= alu_in;
			reg <= reg_in;
		end if;
	end process;
end architecture;