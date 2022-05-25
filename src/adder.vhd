library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adder is
generic (n: integer := 16);
port(
cin: in std_logic;
a,b: in std_logic_vector(n-1 downto 0);
sum: out std_logic_vector(n-1 downto 0);
cout: out std_logic
);
end entity;

architecture struct of adder is
signal temp_A, temp_B: std_logic_vector(n downto 0);
signal temp: std_logic_vector(n downto 0);
begin
temp_A <= '0' & A;
temp_B <= '0' & B;
temp <= temp_A + temp_B;
sum <= temp(n-1 downto 0);
cout <= temp(n);

end architecture;