Library ieee;
use ieee.std_logic_1164.all;

entity buffer_EX_MEM is 
port(
	clk : in std_logic;
	flush : in std_logic;
	--- INPUTS
	--- START stored control signals
	--mem_signal_in : in std_logic;
	--wb_signal_in : in std_logic;
	--- END stored control signals

	alu_in : in std_logic_vector(31 downto 0);
	reg_in : in std_logic_vector(2 downto 0);
        reg1_in : in std_logic_vector(31 downto 0);
	reg2_in : in std_logic_vector(31 downto 0);
	--- OUTPUTS
	--- START stored control signals
	--mem_signal : out std_logic;
	--wb_signal : out std_logic;
	--- END stored control signals
	alu : out std_logic_vector(31 downto 0);
	reg : out std_logic_vector(2 downto 0);
	reg1 : out std_logic_vector(31 downto 0);
	reg2 : out std_logic_vector(31 downto 0);


	
	--memory stage control signals in
	mem_read: in std_logic; --sent to forwarding
 	mem_write: in std_logic; 
 	stack_en: in std_logic;

	--wb stage control signals in
	mem_to_reg: in std_logic; --sent to forwarding
	reg_write:in std_logic; --sent to forwording

	--memory stage control signals out
	mem_read_out: out std_logic; --sent to forwarding
 	mem_write_out: out std_logic; 
 	stack_en_out: out std_logic;

	--wb stage control signals out
	mem_to_reg_out: out std_logic; --sent to forwarding
	reg_write_out:out std_logic --sent to forwording
);

end entity;

architecture struct of buffer_EX_MEM is
begin
	process(flush, clk)
	begin
		if (flush = '1') then
			--mem_signal <= '0';
			--wb_signal <= '0';
			alu <= (others => '0');
			reg <= (others => '0');
			reg1 <= (others => '0');
			reg2 <= (others => '0');
			--memory stage control signals out
			mem_read_out <= '0'; --sent to forwarding
			mem_write_out <= '0';
			stack_en_out <= '0';

			--wb stage control signals out
			mem_to_reg_out <= '0';
			reg_write_out<='0';
		elsif rising_edge(clk) then
			--mem_signal <= mem_signal_in;
			--wb_signal <= wb_signal_in;
			alu <= alu_in;
			reg <= reg_in;
			reg1 <= reg1_in;
			reg2 <= reg2_in;

			--memory stage control signals out
			mem_read_out <= mem_read; --sent to forwarding
			mem_write_out <= mem_write;
			stack_en_out <= stack_en;

			--wb stage control signals out
			mem_to_reg_out <= mem_to_reg;
			reg_write_out<= reg_write;
		end if;
	end process;
end architecture;