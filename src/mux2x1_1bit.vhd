library ieee;
use ieee.std_logic_1164.all;
entity mux2x1_1bit is 
port (
    in1, in2 : in std_logic;
    sel : in  std_logic;
    out1: out std_logic
);
end entity mux2x1_1bit;

architecture struct_1bit of mux2x1_1bit is
begin
    out1 <= in1 when sel = '0'
    else in2;
end architecture;