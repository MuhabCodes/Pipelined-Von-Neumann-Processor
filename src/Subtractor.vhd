Library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY Subtractor IS 
PORT(
	a,b: in std_logic_vector(31 downto 0);
	sub: out std_logic_vector(31 downto 0);
	cout: out std_logic
);
END ENTITY;

ARCHITECTURE Subtractor_arch OF Subtractor IS

COMPONENT adder is
generic (n: integer := 32);
port(   cin: in std_logic;
	a,b: in std_logic_vector(n-1 downto 0);
	sum: out std_logic_vector(n-1 downto 0);
	cout: out std_logic);
END COMPONENT ;

SIGNAL Temp, add_out, sub_option: std_logic_vector(31 downto 0);
SIGNAL c,l: std_logic;
constant one : std_logic_vector (31 downto 0):= ( 0=>'1',others => '0');
BEGIN
Temp<= not b;

u0: adder GENERIC MAP (32) PORT MAP ('0',add_out,one,sub_option,l);
u1: adder GENERIC MAP (32) PORT MAP ('0',a,Temp,add_out,c);
sub<= not add_out WHEN c='0'
 ELSE sub_option;

cout<=c;
END ARCHITECTURE;
