library ieee;
use ieee.std_logic_1164.all;
entity mux4x1 is 
generic (n: integer := 32);
port (
    in1, in2, in3, in4 : in std_logic_vector (n - 1 downto 0);
    sel : in  std_logic;
    out1 : out std_logic_vector (n - 1 downto 0)
);
end entity mux4x1;

architecture arch1 of mux4x1 is
begin
    out1 <= in1 when sel = "00"
    else in2 when sel = "01"
    else in3 when sel = "10"
    else in4 when sel = "11";
end architecture;