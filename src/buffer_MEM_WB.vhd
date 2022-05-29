Library ieee;
use ieee.std_logic_1164.all;

entity buffer_MEM_WB is 
port(
clk : in std_logic;
flush : in std_logic;

opcode_in : in std_logic_vector(31 downto 0);
alu_in : in std_logic_vector(31 downto 0);
reg_in : in std_logic_vector(2 downto 0);
reg1_in : in std_logic_vector(31 downto 0);
reg2_in : in std_logic_vector(31 downto 0);

opcode : out std_logic_vector(31 downto 0);
alu : out std_logic_vector(31 downto 0);
reg : out std_logic_vector(2 downto 0);
reg1 : out std_logic_vector(31 downto 0);
reg2 : out std_logic_vector(31 downto 0);

--wb stage control signals in
mem_to_reg: in std_logic; --sent to forwarding
reg_write:in std_logic; --sent to forwording
--wb stage control signals out
mem_to_reg_out: out std_logic; --sent to forwarding
reg_write_out:out std_logic --sent to forwording
);

end entity;

architecture struct of buffer_MEM_WB is
begin
process(flush, clk)
begin
if (flush = '1') then
--wb_signal <= '0';
opcode <= (others => '0');
alu <= (others => '0');
reg <= (others => '0');
reg1 <= (others => '0');
reg2 <= (others => '0');

mem_to_reg_out <= '0';
reg_write_out<='0';
elsif falling_edge(clk) then
	opcode <= opcode_in;
	alu <= alu_in;
	reg <= reg_in;
	reg1 <= reg1_in;
	reg2 <= reg2_in;

	mem_to_reg_out <= mem_to_reg;
	reg_write_out<= reg_write;
end if;
end process;
end architecture;