Library ieee;
use ieee.std_logic_1164.all;

ENTITY ALU IS 
PORT(
R1:in std_logic_vector(31 downto 0) := (others=>'0');
R2:in std_logic_vector(31 downto 0) := (others=>'0');--input registers
ALU_op:in std_logic_vector (4 downto 0);--alu op code
Rout:out std_logic_vector(31 downto 0) := (others=>'0');--output register
UpdateFlag:out std_logic_vector(2 downto 0) -- flap control signa to go to ccr
);
END ENTITY;

ARCHITECTURE ALU_arch OF ALU IS

COMPONENT adder is
generic (n: integer := 32);
port(   cin: in std_logic;
	a,b: in std_logic_vector(n-1 downto 0);
	sum: out std_logic_vector(n-1 downto 0);
	cout: out std_logic);
END COMPONENT ;

COMPONENT Subtractor IS 
PORT(   a,b: in std_logic_vector(31 downto 0);
	sub: out std_logic_vector(31 downto 0);
	cout: out std_logic);
END COMPONENT ;

SIGNAL INC_out, NOT_out, MOV_out,ADD_out, SUB_out, AND_out, ADDI_out:std_logic_vector(31 downto 0) := (others=>'0');
SIGNAL INC_cout, Z_not, N_not, Z_inc, N_inc, Z_add, N_add ,Z_sub, N_sub ,Z_and, N_and :std_logic := '0';
SIGNAL C_add,C_sub:std_logic  := '0';


--constants to be used in comparisons
constant zeros : std_logic_vector (31 downto 0):= (others => '0');
constant one : std_logic_vector (31 downto 0):= ( 0=>'1',others => '0');

BEGIN

--Single operand operations
--01110 increment
u0: adder GENERIC MAP (32) PORT MAP ('0',R1,one,INC_out,INC_cout);
Z_inc <= '1' WHEN INC_out = zeros
             ELSE '0';

N_inc <= '1' WHEN INC_out(31)='1'
             ELSE '0';

--01111 not operation
NOT_out <= not R1;
Z_not <= '1' WHEN NOT_out= zeros
             ELSE '0';
N_not <= '1' WHEN NOT_out(31)='1'
             ELSE '0';


--Two operands operations
--MOV	10000
MOV_out<=R1;

--ADD	10010  and IADD	11100-> both are the same as operands are chosen outside the alu
u1: adder GENERIC MAP (32) PORT MAP ('0',R1,R2,ADD_out, C_add);
Z_add <= '1' WHEN ADD_out = zeros
             ELSE '0';
N_add <= '1' WHEN ADD_out(31)='1'
             ELSE '0';

--SUB	10011
u2: Subtractor PORT MAP (R1,R2,SUB_out,C_sub);
Z_sub <= '1' WHEN SUB_out= zeros
             ELSE '0';
N_sub<= '1' WHEN SUB_out(31)='1'
            ELSE '0';

--AND	10100
AND_out<= R1 AND R2;
Z_and <= '1' WHEN AND_out= zeros
             ELSE '0';
N_and<= '1' WHEN AND_out(31)='1'
            ELSE '0';


--Setting ALU outputs
Rout<= INC_out WHEN ALU_op= "01110"
  ELSE NOT_out WHEN ALU_op= "01111"
  ELSE MOV_out WHEN ALU_op= "10000" or ALU_op = "01010"
  ELSE AND_out WHEN ALU_op= "10100"
  ELSE ADD_out WHEN ALU_op= "10010" OR ALU_op= "11100"
  ELSE SUB_out WHEN ALU_op= "10011"
  ELSE R2 WHEN ALU_op = "11101";

UpdateFlag <= INC_cout & N_inc & Z_inc WHEN ALU_op = "01110"
        ELSE '0' & N_not & Z_not WHEN ALU_op = "01111"
        ELSE '0' & N_and & Z_and WHEN ALU_op = "10100"
        ELSE C_add & N_add & Z_add WHEN ALU_op = "10010" OR ALU_op= "11100"
	      ELSE C_sub & N_sub & Z_sub WHEN ALU_op = "10011"
        ELSE "100" WHEN ALU_op = "00010"
	      ELSE "000";
END ARCHITECTURE;