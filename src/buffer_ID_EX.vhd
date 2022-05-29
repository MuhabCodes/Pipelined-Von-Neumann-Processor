Library ieee;
use ieee.std_logic_1164.all;

entity buffer_ID_EX is 
port(
	clk : in std_logic;
	flush : in std_logic;
	--- INPUTS
	--- START stored control signals
	ex_signal_in : in std_logic;
	mem_signal_in : in std_logic;
	wb_signal_in : in std_logic;
	--- END stored control signals
	pc_in : in std_logic_vector(31 downto 0);
	reg1_in : in std_logic_vector(31 downto 0);
	reg2_in : in std_logic_vector(31 downto 0);
	imm_ea_in : in std_logic_vector(15 downto 0);
	rsrc1_in : in std_logic_vector(2 downto 0);
	rsrc2_in : in std_logic_vector(2 downto 0);
	rd_in : in std_logic_vector(2 downto 0);
	--- OUTPUTS
	--- START stored control signals
	ex_signal : out std_logic;
	mem_signal : out std_logic;
	wb_signal : out std_logic;
	--- END stored control signals
	pc : out std_logic_vector(31 downto 0);
	reg1 : out std_logic_vector(31 downto 0);
	reg2 : out std_logic_vector(31 downto 0);
	imm_ea_extend : out std_logic_vector(31 downto 0);
	rsrc1 : out std_logic_vector(2 downto 0);
	rsrc2 : out std_logic_vector(2 downto 0);
	rd : out std_logic_vector(2 downto 0);
	---
	ID_EX_MemRead: out std_logic
);

end entity;

architecture struct of buffer_ID_EX is
begin
	process(flush, clk)
	begin
		if (flush = '1') then
			ex_signal <= '0';
			mem_signal <= '0';
			wb_signal <= '0';
			pc <= (others => '0');
			reg1 <= (others => '0');
			reg2 <= (others => '0');
			imm_ea_extend <= (others => '0');
			rsrc1 <= (others => '0');
			rsrc2 <= (others => '0');
			rd <= (others => '0');
			ID_EX_MemRead <= '0';
		elsif rising_edge(clk) then
			ex_signal <= ex_signal_in;
			mem_signal <= mem_signal_in;
			wb_signal <= wb_signal_in;
			imm_ea_extend <= (31 downto 16 => imm_ea_in(15)) & imm_ea_in(15 downto 0);
			pc <= pc_in;
			reg1 <= reg1_in;
			reg2 <= reg2_in;
			rsrc1 <= rsrc1_in;
			rsrc2 <= rsrc2_in;
			rd <= rd_in;
			ID_EX_MemRead <= mem_signal_in;
		end if;
	end process;
end architecture;