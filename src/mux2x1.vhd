library ieee;
use ieee.std_logic_1164.all;
entity mux2x1 is 
generic (n: integer := 32);
port (
    in1, in2 : in std_logic_vector (n - 1 downto 0);
    sel : in  std_logic;
    out1: out std_logic_vector (n - 1 downto 0)
);
end entity mux2x1;

architecture struct of mux2x1 is
begin
    out1 <= in1 when sel = '0'
    else in2;
end architecture;