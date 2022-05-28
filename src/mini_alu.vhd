library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mini_alu is
    port(
        clk: in std_logic;
        mem_write: in std_logic;
        stack_en: in std_logic;
        sp_in: in std_logic_vector(31 downto 0);
        sp_out: out std_logic_vector(31 downto 0)
    );
end entity;


architecture mini_alu_arch of mini_alu is

signal whichAdd: std_logic_vector(31 downto 0);
signal one: std_logic_vector(31 downto 0);
signal neg_one:  std_logic_vector(31 downto 0);

component adder is
generic (n: integer := 16);
port(
	cin: in std_logic;
	a,b: in std_logic_vector(n-1 downto 0);
	sum: out std_logic_vector(n-1 downto 0);
	cout: out std_logic
);
end component;
begin
one <= (31 downto 1 => '0') & (0 downto 0 => '1');
neg_one <= (others=> '1');

whichAdd<= one when (stack_en ='1' and mem_write ='0')
else neg_one when (stack_en ='1' and mem_write ='1')
else (others=>'0');

add_map: adder generic map (32) port map ('0', sp_in, whichAdd, sp_out, open);
end architecture mini_alu_arch;