LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity decode_stage is
    port(
        clk,rst:in std_logic;

        Instruction: in std_logic_vector(31 downto 0);

        ccr_wr_en : out std_logic_vector(2 downto 0);
        reg_write : out std_logic;
        alu_src : out std_logic;
        alu_op : out std_logic_vector(4 downto 0);
        alu_imm : out std_logic;
        mem_write : out std_logic;
        mem_read : out std_logic;
        stack_en : out std_logic;
        mem_to_reg : out std_logic;
        return_en : out std_logic;
        jmp_en : out std_logic;
        jmp_op : out std_logic_vector(1 downto 0);
        restore_flags : out std_logic;
        int_en : out std_logic;
        pc_src : out std_logic_vector(1 downto 0);
        --Rsrc1,Rsrc2: out std_logic_vector(2 downto 0);

        writeData: in std_logic_vector(31 downto 0);
        writeReg: in std_logic_vector(2 downto 0);

        PC: in std_logic_vector(31 downto 0);

        IMM_in: in std_logic_vector(31 downto 0);
        readData1,readData2: out std_logic_vector(31 downto 0);--signal in from register

        Rd, Rs,Rt: out std_logic_vector(2 downto 0);
        index: out std_logic_vector(1 downto 0);

        CCR_out: in std_logic_vector(2 downto 0);
                
---muxx bt3 el mem wb ex signals lesa msh m3mol
    );
end entity;

architecture rtl of Decode_stage is
    
component registersFile is
   port(
        reg_write: in std_logic;
        clk, rst: in std_logic;
        Rsrc1,Rsrc2: in std_logic_vector(2 downto 0);
        write_reg: in std_logic_vector(2 downto 0);
        write_data: in std_logic_vector(31 downto 0);
        read_data1,read_data2: out std_logic_vector(31 downto 0)
    );
end component;

component control_unit IS
port (
	clk : in std_logic;
	opcode : in std_logic_vector(4 downto 0);
	ccr_wr_en : out std_logic_vector(2 downto 0);
	reg_write : out std_logic;
	alu_src : out std_logic;
	alu_op : out std_logic_vector(4 downto 0);
	alu_imm : out std_logic;
	mem_write : out std_logic;
	mem_read : out std_logic;
	stack_en : out std_logic;
	mem_to_reg : out std_logic;
	return_en : out std_logic;
	jmp_en : out std_logic;
	jmp_op : out std_logic_vector(1 downto 0);
	restore_flags : out std_logic;
	int_en : out std_logic;
	pc_src : out std_logic_vector(1 downto 0);
);
end component;

component adder is
generic (n: integer := 16);
port(
	cin: in std_logic;
	a,b: in std_logic_vector(n-1 downto 0);
	sum: out std_logic_vector(n-1 downto 0);
	cout: out std_logic
);
end component;

signal bit5INTindex: std_logic_vector(1 downto 0):='0' & Instruction(5);

begin
    controlUn: control_unit port map(clk, Instruction(4 downto 0), ccr_wr_en, reg_write, alu_src, alu_op, alu_imm, mem_write, mem_read, stack_en, mem_to_reg, return_en, jmp_en, jmp_op, restore_flags, int_en, pc_src);
    RegistersComp: registersFile port map (reg_write, clk, rst, Instruction(7 downto 5), Instruction(10 downto 8), writeReg, writeData, readData1, readData2);
    Rs<=Instruction(7 downto 5);
    Rt<=Instruction(10 downto 8);
    Rd<=Instruction(13 downto 11);
    addingPc: adder generic port (2) port map ('0',"10",bit5INTindex,index, open);




end architecture rtl;