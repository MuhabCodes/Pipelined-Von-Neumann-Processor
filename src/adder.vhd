library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity nBitCSA is
generic (n: integer := 16);
port(
Cin: in std_logic;
A,B: in std_logic_vector(n-1 downto 0);
Sum: out std_logic_vector(n-1 downto 0);
Cout: out std_logic
);
end entity;

architecture CSA_arch of nBitCSA is
signal tempA, tempB: std_logic_vector(n downto 0);
signal temp: std_logic_vector(n downto 0);
begin
tempA <= '0' & A;
tempB <= '0' & B;
temp <= tempA + tempB;
sum <= temp(n-1 downto 0);
Cout <= temp(n);

end architecture;