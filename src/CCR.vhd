library ieee;
use ieee.std_logic_1164.all;

entity CCR is
    port(
        clk: in std_logic;
     	ccr_wr_en: in std_logic_vector(2 downto 0);
        ccr_in: in std_logic_vector(2 downto 0);
        ccr_out: out std_logic_vector(2 downto 0)
    );
end entity CCR;

architecture CCR_architecture of CCR is

component reg1bit is 
port(
		d: in std_logic;
		q: out	std_logic;
		en, clk, rst: in std_logic
		);
end component reg1bit ;
signal temp: std_logic_vector(2 downto 0):="000";
begin

CarryFlag: reg1bit port map (ccr_in(0),ccr_out(0),ccr_wr_en(0),clk,'0');
NegativeFlag: reg1bit  port map (ccr_in(1), ccr_out(1) ,ccr_wr_en(1),clk,'0');
ZeroFlag: reg1bit  port map (ccr_in(2), ccr_out(2) ,ccr_wr_en(2),clk,'0');

end architecture;

