Library ieee;
use ieee.std_logic_1164.all;

ENTITY WBStage IS 
PORT(

 Write_address_in :in std_logic_vector(2 downto 0); --destination adress for the register file comming from buffer (Rd aw Rs)
 Write_address_out :out std_logic_vector(2 downto 0);  --destination adress going to reg file

 Execute_out: in std_logic_vector(31 downto 0); --value comming from execute stage(ALU)
 Load_value: in std_logic_vector(31 downto 0); --value comming from memory
 mem_to_reg: in std_logic; --control signal to choose between both
  
 forward_in :in std_logic_vector(2 downto 0);--destination wrue back for previous instruction-> for forwarding unit
 forward_out :out std_logic_vector(2 downto 0);--going to the forwarding unit
 
--beyetla3 mel wb stage el values betrou7 lel mux beta3 el execute stage Rsrc1and Rsrc2 
--we beyetla3 menha bardo adresses betrou7 el forwarding unit -> beye7sal henak comparison bettala3ly selector el mux dah


 Write_back_out :out std_logic_vector(31 downto 0) --value to write in the register file at the destination adress

);
END ENTITY;

ARCHITECTURE WBStage_arch OF WBStage IS

COMPONENT  mux2x1 is 
generic (n: integer := 32);
    PORT(
   	in1, in2 : in std_logic_vector (n - 1 downto 0);
    	sel : in  std_logic;
    	out1: out std_logic_vector (n - 1 downto 0));
END COMPONENT ;

SIGNAL Write_back:std_logic_vector(31 downto 0);
BEGIN

MUX1: mux2x1  GENERIC MAP (32) PORT MAP (Execute_out, Load_value, mem_to_reg,Write_back);

Write_back_out<=Write_back;
forward_out<=forward_in;

Write_address_out<=Write_address_in;
END ARCHITECTURE;
