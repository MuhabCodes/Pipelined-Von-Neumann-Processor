library ieee;
use ieee.std_logic_1164.all;

entity SaveFlags is
port(
	SaveIn: in std_logic_vector(2 downto 0);
	Saveout: out std_logic_vector(2 downto 0);
	INTen: in std_logic;
clk: in std_logic
	
);
end entity;

architecture Save_architecture of SaveFlags is

component reg is 
generic(n: integer :=32);
   port(
        d: in std_logic_vector(n-1 downto 0) := (others=>'0');
        q: out std_logic_vector(n-1 downto 0) := (others=>'0');
        en, clk, rst: in std_logic
   );
end component reg ;

begin 
u1:reg generic map (3) port map (SaveIn,Saveout,INten,clk,'0');
end architecture;

