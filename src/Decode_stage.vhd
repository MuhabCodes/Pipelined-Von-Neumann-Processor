LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity decode_stage is
    port(
        CLK,rst:in std_logic;
        Instruction: in std_logic_vector(31 downto 0);

        --control signals
	    reg_write : in std_logic;
	    flush_id : in std_logic;
        WBen: in std_logic;
        MEMen:in std_logic;
        EXen:in std_logic;
        hazard_results: in std_logic;

        --other inputs
        writeData: in std_logic_vector(31 downto 0);--data read from memory
        writeReg: in std_logic_vector(2 downto 0);--destination register
        PC_in: in std_logic_vector(31 downto 0);
       -- IMM_in: in std_logic_vector(15 downto 0);

        --outputs
        Pc_out: out std_logic_vector(31 downto 0);
        readData1,readData2: out std_logic_vector(31 downto 0);
        Rd, Rs,Rt: out std_logic_vector(2 downto 0);
        index: out std_logic_vector(1 downto 0);
        WBenSignal:out  std_logic;
        MEMenSignal: out std_logic;
        ExenSignal: out std_logic;
        IMM_out: out std_logic_vector(15 downto 0)
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

component adder is
generic (n: integer := 16);
port(
	cin: in std_logic;
	a,b: in std_logic_vector(n-1 downto 0);
	sum: out std_logic_vector(n-1 downto 0);
	cout: out std_logic
);
end component;

component mux2x1_1bit is
port (
    in1, in2 : in std_logic;
    sel : in  std_logic;
    out1: out std_logic
);
end component;

signal bit5INTindex: std_logic_vector(1 downto 0);
signal LoadUseAndFlush: std_logic;

begin
   
    bit5INTindex<='0' & Instruction(26);
    RegistersComp: registersFile port map (reg_write, CLK, rst, Instruction(23 downto 21), Instruction(20 downto 18), writeReg, writeData, readData1, readData2);
    Rs<=Instruction(23 downto 21);
    Rt<=Instruction(20 downto 18);
    Rd<=Instruction(26 downto 24);
    pc_out<=pc_in;
    IMM_out<= instruction(15 downto 0);
    addingPc: adder generic map (2) port map ('0', "10", bit5INTindex, index, open);
    LoadUseAndFlush<=flush_id or hazard_Results;
    WBZeroingMux: mux2x1_1bit port map (WBen, '0', LoadUseAndFlush, WBenSignal);
    MEMZeroingMux: mux2x1_1bit  port map (MEMen, '0', LoadUseAndFlush, MEMenSignal);
    EXZeroingMux: mux2x1_1bit  port map (EXen, '0', LoadUseAndFlush, EXenSignal);

end architecture rtl;