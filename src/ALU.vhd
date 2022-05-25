Library ieee;
use ieee.std_logic_1164.all;

ENTITY ALU IS 
generic(n: integer :=32);
PORT(
R1:in std_logic_vector(n-1 downto 0) := (others=>'0');
R2:in std_logic_vector(n-1 downto 0) := (others=>'0');--input registers
ALU_op:in std_logic_vector (4 downto 0);--alu op code
Rout:out std_logic_vector(n-1 downto 0) := (others=>'0');--output register
UpdateFlag:out std_logic_vector(2 downto 0) -- flap control signa to go to ccr
);
END ENTITY;

ARCHITECTURE ALU_arch OF ALU IS
BEGIN


END ARCHITECTURE;