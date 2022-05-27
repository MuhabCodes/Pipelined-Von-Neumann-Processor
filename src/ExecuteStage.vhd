--This stage includes ALU operations and flag operations

Library ieee;
use ieee.std_logic_1164.all;


ENTITY ExecuteStage IS 
PORT(
 clk: in std_logic;
 IMM : in std_logic_vector(31 downto 0); --immendiate value after sign extend(from buffer)
 IN_PORT : in std_logic_vector(31 downto 0); --value comming from input port
 in_select: in std_logic ;--control signal to choose betweet in port and ALU output to be in the buffer

 Rsrc2_mem_in : in std_logic_vector(31 downto 0);
 Rsrc2_wb_in : in std_logic_vector(31 downto 0);
 Rsrc2_instruction : in std_logic_vector(31 downto 0);
 isForward2 : in std_logic_vector(1 downto 0); --output of forwarding unit to chhose which source2 regitser value to use
 

 Rsrc1_mem_in : in std_logic_vector(31 downto 0);
 Rsrc1_wb_in : in std_logic_vector(31 downto 0);
 Rsrc1_instruction : in std_logic_vector(31 downto 0);
 isForward1 : in std_logic_vector(1 downto 0); --output of forwarding unit to chhose which source1 regitser value to use

 ALU_src: in std_logic;  --control signal to choose the second source in ALU op
 ALU_op: in std_logic_vector (4 downto 0); --control signal to choose ALU operation

 Rd_in: in std_logic_vector(2 downto 0);
 Rs_in: in std_logic_vector(2 downto 0);
 Rt_in: in std_logic_vector(2 downto 0);
 
 buffer_PC_in:in std_logic_vector(31 downto 0);

 restore_flags:  in std_logic; --control signal to choose ccr input
 CCR_write_en:  in std_logic_vector(2 downto 0);
 INT_en: in std_logic; --interrupt enable control signal
 
 WB_en_in: in std_logic;
 MEM_en_in:in std_logic;

 WB_en_out:out std_logic;
 MEM_en_out:out std_logic;
 
 ALU_out: out std_logic_vector(31 downto 0); --output of the ALU operation goes to buffer
 OUT_PORT:out std_logic_vector(31 downto 0);

 Rsrc1_mem_out : out std_logic_vector(31 downto 0);--putting the sources in the ex/mem buffer so we can use them in forwarding
 Rsrc2_mem_out: out std_logic_vector(31 downto 0);

 Rd_Rs_Out: out std_logic_vector(2 downto 0);
 Rs_out: out std_logic_vector(2 downto 0);--going to forwarding unit
 Rt_out: out std_logic_vector(2 downto 0);--going to forwarding unit
 Rd_out: out std_logic_vector(2 downto 0);--going to hazard detection unit

 buffer_PC_out:out std_logic_vector(31 downto 0)
);
END ENTITY;

ARCHITECTURE ExecuteStage_arch OF ExecuteStage  IS

COMPONENT ALU IS 
    PORT(
	R1:in std_logic_vector(31 downto 0) := (others=>'0');
	R2:in std_logic_vector(31 downto 0) := (others=>'0');
	ALU_op:in std_logic_vector (4 downto 0);
	Rout:out std_logic_vector(31 downto 0) := (others=>'0');
	UpdateFlag:out std_logic_vector(2 downto 0));
END COMPONENT ;

COMPONENT CCR is
    PORT(
        clk: in std_logic;
     	ccr_wr_en: in std_logic_vector(2 downto 0);
        ccr_in: in std_logic_vector(2 downto 0);
        ccr_out: out std_logic_vector(2 downto 0));
END COMPONENT ;

COMPONENT SaveFlags is
    PORT(
	SaveIn: in std_logic_vector(2 downto 0);
	Saveout: out std_logic_vector(2 downto 0);
	INTen: in std_logic;
	clk: in std_logic);
END COMPONENT ;

COMPONENT mux4x1 is 
GENERIC (n: integer := 32);
    PORT(
    	in1, in2, in3, in4 : in std_logic_vector (n - 1 downto 0);
   	sel : in std_logic_vector(1 downto 0);
    	out1 : out std_logic_vector (n - 1 downto 0));
END COMPONENT ;


COMPONENT  mux2x1 is 
generic (n: integer := 32);
    PORT(
   	in1, in2 : in std_logic_vector (n - 1 downto 0);
    	sel : in  std_logic;
    	out1: out std_logic_vector (n - 1 downto 0));
END COMPONENT ;
 
COMPONENT  mux2x1_1bit is 
port (
    in1, in2 : in std_logic;
    sel : in  std_logic;
    out1: out std_logic
);
END COMPONENT ;

SIGNAL Rsrc_chosen2 :std_logic_vector(31 downto 0);

SIGNAL  ALU_Rsrc2,ALU_Rsrc1: std_logic_vector(31 downto 0);--inputs of the ALU operation
SIGNAL  output_ALU, output_INMUX : std_logic_vector(31 downto 0);-- according to op code it is either assigned to buffer (ALU_out) or to out port (OUT_PORT)

SIGNAL SaveFlag_out: std_logic_vector(2 downto 0);
SIGNAL update_Flag,CCR_in,CCR_out: std_logic_vector(2 downto 0);

constant zeros : std_logic_vector (31 downto 0):= (others => '0');

BEGIN

--connecting the input output lines
 Rt_out<=  Rt_in;
 Rs_out<=  Rs_in;
 Rd_out<=  Rd_in;
 buffer_PC_out<=buffer_PC_in;
 Rsrc1_mem_out<=Rsrc1_instruction;--to be used from buffer in the next instructions
 Rsrc2_mem_out<=Rsrc2_instruction;

 OUT_PORT<=output_ALU;
 ALU_out<=output_INMUX;
--Multiplexer to get which second source to be used based on forwarding unit
MUX1: mux4x1  GENERIC MAP (32) PORT MAP (Rsrc2_mem_in , Rsrc2_wb_in ,Rsrc2_instruction,zeros,isForward2,Rsrc_chosen2);

--Multiplexer to choose between source and immediate value based on a control signal
MUX2: mux2x1  GENERIC MAP (32) PORT MAP (IMM ,Rsrc_chosen2,ALU_src,ALU_Rsrc2);

--Multiplexer to get which first source to be used based on forwarding unit
MUX3: mux4x1  GENERIC MAP (32) PORT MAP (Rsrc1_mem_in , Rsrc1_wb_in ,Rsrc1_instruction,zeros,isForward1,ALU_Rsrc1);

--ALU operation
ALUOP: ALU PORT MAP (ALU_Rsrc1,ALU_Rsrc2,ALU_op, output_ALU,update_Flag);

--Multiplexer to choose between ALU output and IN PORT value to pass to buffer
MUX4: mux2x1  GENERIC MAP (32) PORT MAP (output_ALU,IN_PORT ,in_select,output_INMUX);

--7aga liha 3elaka bel load ->check ma3 khadija
MUX5: mux2x1  GENERIC MAP (3) PORT MAP (Rd_in,Rs_in,ALU_op(3),Rd_Rs_Out);

--Multiplexer to choose the input of the CCR
MUX6: mux2x1  GENERIC MAP (3) PORT MAP (update_Flag,SaveFlag_out,restore_flags,CCR_in);

--CCR and Save flags units to restore flags after interrupts
CCR1: CCR  PORT MAP (clk,CCR_write_en,CCR_in,CCR_out);
CCR2: SaveFlags PORT MAP (CCR_out,SaveFlag_out,INT_en,clk);

WB_en_out<=WB_en_in;
MEM_en_out<=MEM_en_in;


END ARCHITECTURE;