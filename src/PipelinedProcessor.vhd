
Library ieee;
use ieee.std_logic_1164.all;

ENTITY PipelinedProcessor IS 
PORT(
	clk : in std_logic;
	INTR_IN : in std_logic;
	RESET_IN : in std_logic;
	IN_PORT : in std_logic_vector(31 downto 0);
	OUT_PORT : out std_logic_vector(31 downto 0)
);
END ENTITY;

ARCHITECTURE PipelinedProcessor_arch OF PipelinedProcessor  IS
COMPONENT  control_unit IS
PORT(
	clk : in std_logic;
	rst : in std_logic;
	intr : in std_logic;
	opcode : in std_logic_vector(4 downto 0);
	CCR_OUT: in std_logic_vector(2 downto 0);
	ccr_wr_en : out std_logic_vector(2 downto 0);
	reg_write : out std_logic;
	alu_src : out std_logic;
	alu_op : out std_logic_vector(4 downto 0);
	in_select : out std_logic;
	fetch_memory : out std_logic;
	mem_write : out std_logic;
	mem_read : out std_logic;
	stack_en : out std_logic;
	mem_to_reg : out std_logic;
	return_en : out std_logic;
	restore_flags : out std_logic;
	int_en : out std_logic;
	pc_src : out std_logic;
    flush_if : out std_logic;
	flush_id : out std_logic;
	flush_ex : out std_logic
);
END COMPONENT ;
COMPONENT forwardingUnit IS
PORT (
	
	data1Dst, data2Dst, dataMemDst, dataWbDst : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
	RegWriteMem, RegWriteWb : in std_logic ;

	selData1, selData2 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
);
END COMPONENT;

component fetch_stage is
port(
	clk: in std_logic;

	--control signals
	pc_src: in std_logic;
	RESET_OR_INTR: in std_logic;
	fetch_memory: in std_logic;
	int_en: in std_logic;
	reset_in: in std_logic;
	intr_in: in std_logic;
	return_en: in std_logic;
	pc_write: in std_logic;
	mem_write: in std_logic;

	--other values
	PC_buffer: in std_logic_vector(31 downto 0);
	index: in std_logic_vector(31 downto 0);
	mem_ex_output: in std_logic_vector(31 downto 0);
	memory_block_output: in std_logic_vector(31 downto 0);
	EA_in: in std_logic_vector(31 downto 0);

	--output
	pc_out: out std_logic_vector(31 downto 0);
	address: out std_logic_vector(31 downto 0)
);
end component;


COMPONENT buffer_IF_ID is 
port(
	clk : in std_logic;
	rst: in std_logic;
	flush : in std_logic;--control signal
	write_en : in std_logic;--control signal
	instruction_in : in std_logic_vector(31 downto 0); --  instruction in from fetch decode
	pc_in : in std_logic_vector(31 downto 0); -- pc in from fetch stage
	instruction : out std_logic_vector(31 downto 0); --instruction to decode stage
	pc : out std_logic_vector(31 downto 0)--PC to decode stage
);
END COMPONENT;

COMPONENT decode_stage is
    port(
        CLK,rst:in std_logic;
        Instruction: in std_logic_vector(31 downto 0);

        --control signals
	    reg_write : in std_logic;
	    flush_id : in std_logic;
        hazard_results: in std_logic;

        --other inputs
        writeData: in std_logic_vector(31 downto 0);--data read from memory
        writeReg: in std_logic_vector(2 downto 0);--destination register
       -- IMM_in: in std_logic_vector(15 downto 0);

        --outputs
        readData1,readData2: out std_logic_vector(31 downto 0);
        Rd, Rs,Rt: out std_logic_vector(2 downto 0);
        index: out std_logic_vector(1 downto 0);
        LoadUseAndFlush: out std_logic;
        IMM_out: out std_logic_vector(15 downto 0)
    );
END COMPONENT;

COMPONENT buffer_ID_EX is 
PORT(
	clk : in std_logic;
	rst: in std_logic;
	flush : in std_logic;
	--- INPUTS
	
	pc_in : in std_logic_vector(31 downto 0);
	reg1_in : in std_logic_vector(31 downto 0);
	reg2_in : in std_logic_vector(31 downto 0);
	imm_ea_in : in std_logic_vector(15 downto 0);
	rsrc1_in : in std_logic_vector(2 downto 0);
	rsrc2_in : in std_logic_vector(2 downto 0);
	rd_in : in std_logic_vector(2 downto 0);
	--- OUTPUTS

	pc : out std_logic_vector(31 downto 0);
	reg1 : out std_logic_vector(31 downto 0);
	reg2 : out std_logic_vector(31 downto 0);
	imm_ea_extend : out std_logic_vector(31 downto 0);
	rsrc1 : out std_logic_vector(2 downto 0);
	rsrc2 : out std_logic_vector(2 downto 0);
	rd : out std_logic_vector(2 downto 0);
	---
	ID_EX_MemRead:  out std_logic;
	
	---excute stage control signal in
	restore_flags:  in std_logic; 
	INT_en: in std_logic; 
	CCR_write_en:  in std_logic_vector(2 downto 0);
	ALU_src: in std_logic;  --control signal to choose the second source in ALU op
	ALU_op: in std_logic_vector (4 downto 0); 
	in_select: in std_logic;

	--memory stage control signals in
 	fetch_memory: in std_logic;
	mem_read: in std_logic; --sent to forwarding
 	mem_write: in std_logic; 
 	stack_en: in std_logic;

	--wb stage control signals in
	mem_to_reg: in std_logic; --sent to forwarding
	reg_write:in std_logic; --sent to forwording

	--excute stage control signals out
	restore_flags_out:  out std_logic; 
	INT_en_out: out std_logic; 
	CCR_write_en_out:  out std_logic_vector(2 downto 0);
	ALU_src_out: out std_logic;  --control signal to choose the second source in ALU op
	ALU_op_out: out std_logic_vector (4 downto 0); 
	in_select_out: out std_logic;

	--memory stage control signals out
 	fetch_memory_out: out std_logic;
	mem_read_out: out std_logic; --sent to forwarding
 	mem_write_out: out std_logic; 
 	stack_en_out: out std_logic;

	--wb stage control signals out
	mem_to_reg_out: out std_logic; --sent to forwarding
	reg_write_out:out std_logic; --sent to forwording

	jmp_address: out std_logic_vector(31 downto 0)

	);
END COMPONENT ;

COMPONENT ExecuteStage IS 
PORT(
	clk: in std_logic;
	rst: in std_logic;
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
	
	ALU_out: out std_logic_vector(31 downto 0); --output of the ALU operation goes to buffer
	OUT_PORT:out std_logic_vector(31 downto 0);

	Rsrc1_mem_out : out std_logic_vector(31 downto 0);--putting the sources in the ex/mem buffer so we can use them in forwarding
	Rsrc2_mem_out: out std_logic_vector(31 downto 0);

	Rd_Rs_Out: out std_logic_vector(2 downto 0);
	Rs_out: out std_logic_vector(2 downto 0);--going to forwarding unit
	Rt_out: out std_logic_vector(2 downto 0);--going to forwarding unit
	Rd_out: out std_logic_vector(2 downto 0);--going to hazard detection unit

	buffer_PC_out:out std_logic_vector(31 downto 0);
	CCR_output: out std_logic_vector(2 downto 0)
);
END COMPONENT ;

COMPONENT buffer_EX_MEM is 
port(
	clk : in std_logic;
	rst: in std_logic;
	flush : in std_logic;
	--- INPUTS

	alu_in : in std_logic_vector(31 downto 0);
	reg_in : in std_logic_vector(2 downto 0);
	reg1_in : in std_logic_vector(31 downto 0);
	reg2_in : in std_logic_vector(31 downto 0);

	alu : out std_logic_vector(31 downto 0);
	reg : out std_logic_vector(2 downto 0);
	reg1 : out std_logic_vector(31 downto 0);
	reg2 : out std_logic_vector(31 downto 0);

	--memory stage control signals in
	fetch_memory: in std_logic;
	mem_read: in std_logic; --sent to forwarding
 	mem_write: in std_logic; 
 	stack_en: in std_logic;

	--wb stage control signals in
	mem_to_reg: in std_logic; --sent to forwarding
	reg_write:in std_logic; --sent to forwording

	--memory stage control signals out
	fetch_memory_out: out std_logic;
	mem_read_out: out std_logic; --sent to forwarding
 	mem_write_out: out std_logic; 
 	stack_en_out: out std_logic;

	--wb stage control signals out
	mem_to_reg_out: out std_logic; --sent to forwarding
	reg_write_out:out std_logic--sent to forwording

	);
END COMPONENT ;

COMPONENT MemoryStage IS 
PORT(
 	Rsrc1_mem_in : in std_logic_vector(31 downto 0); --comming from buffer EX/MEM-> it will go into the write data of the memory
 	Rsrc2_mem_in : in std_logic_vector(31 downto 0);
	Rsrc1_mem_out : out std_logic_vector(31 downto 0);--going to execute stage and the MEM/WB buffer and data write 
	Rsrc2_mem_out : out std_logic_vector(31 downto 0);--to be used in forwarding
	
	execution_output: in std_logic_vector(31 downto 0); --value comming from execute stage (Rsrc2+offset)-> memory address
 	mem_stage_output: out std_logic_vector(31 downto 0);--could be store adress OR vslue to be passed to MEM/WB buffer
 	Rd_Rs_in: in std_logic_vector(2 downto 0);
 	Rd_Rs_out: out std_logic_vector(2 downto 0));--going to forwarding unit and  MEM/WB buffer);
END COMPONENT ;

COMPONENT Memory IS 
PORT(
 	 clk: in std_logic; 
	interrupt: in std_logic;
	 mem_read: in std_logic; --enables
	 mem_write: in std_logic;
	 stack_en: in std_logic;
	 address: in std_logic_vector(31 downto 0);--address to read or write
 	 write_data: in std_logic_vector(31 downto 0);
	 read_data: out std_logic_vector(31 downto 0));
END COMPONENT ;


COMPONENT  buffer_MEM_WB is 
PORT(
	clk : in std_logic;
	rst: in std_logic;
	flush : in std_logic;

	opcode_in : in std_logic_vector(31 downto 0);
	alu_in : in std_logic_vector(31 downto 0);
	reg_in : in std_logic_vector(2 downto 0);
	reg1_in : in std_logic_vector(31 downto 0);
	reg2_in : in std_logic_vector(31 downto 0);

	opcode : out std_logic_vector(31 downto 0);
	alu : out std_logic_vector(31 downto 0);
	reg : out std_logic_vector(2 downto 0);
	reg1 : out std_logic_vector(31 downto 0);
	reg2 : out std_logic_vector(31 downto 0);

	--wb stage control signals in
	mem_to_reg: in std_logic; --sent to forwarding
	reg_write:in std_logic; --sent to forwording
	--wb stage control signals out
	mem_to_reg_out: out std_logic ;
	reg_write_out:out std_logic --sent to forwording
);

END COMPONENT ;

COMPONENT  WBStage IS 
PORT(
	Write_address_in :in std_logic_vector(2 downto 0); --destination adress for the register file comming from buffer (Rd aw Rs)
 	Write_address_out :out std_logic_vector(2 downto 0);  --destination adress going to reg file
 	Execute_out: in std_logic_vector(31 downto 0); --value comming from execute stage(ALU)
	Load_value: in std_logic_vector(31 downto 0); --value comming from memory
 	mem_to_reg: in std_logic; --control signal to choose between both 
 	forward_in :in std_logic_vector(2 downto 0);--destination wrue back for previous instruction-> for forwarding unit
 	forward_out :out std_logic_vector(2 downto 0);--going to the forwarding unit
 
 	
 	Write_back_out :out std_logic_vector(31 downto 0) );
END COMPONENT ;

COMPONENT Hazard_detection is
    port(
        clk: in std_logic;
        Rd_in: in std_logic_vector(2 downto 0);
        RESET_IN : in std_logic; -- HW INTERRUPTS
		INTR_IN:  in std_logic; -- HW INTERRUPTS
        ID_EX_MemRead:  in std_logic;--memory enable
        IF_ID_write: out std_logic;
        opcode: in std_logic_vector(4 downto 0);
        Rs_in: in std_logic_vector(2 downto 0);
        Rt_in:in std_logic_vector(2 downto 0);
        Pc_write: out std_logic;
        hazard_Results: out std_logic
        --mem_to_reg: in std_logic
    );
end COMPONENT ;

COMPONENT  registersFile is
PORT(
        reg_write: in std_logic;-- write enable in register file
        clk, rst: in std_logic;
        Rsrc1,Rsrc2: in std_logic_vector(2 downto 0); --reading source adresses
        write_reg: in std_logic_vector(2 downto 0); --writing destination adresses
        write_data: in std_logic_vector(31 downto 0);
        read_data1,read_data2: out std_logic_vector(31 downto 0));
END COMPONENT ;

COMPONENT  mux2x1 is 
generic (n: integer := 32);
    PORT(
   	in1, in2 : in std_logic_vector (n - 1 downto 0);
    	sel : in  std_logic;
    	out1: out std_logic_vector (n - 1 downto 0));
END COMPONENT ;
-- FETCH STAGE SIGNALS
SIGNAL pc_out, address, index: std_logic_vector(31 downto 0);

--DECODE STAGE SIGNALS
SIGNAL Instruction, write_data: std_logic_vector(31 downto 0); --input addresses/instruction from buffer
SIGNAL write_reg: std_logic_vector(2 downto 0);-- destination register address
--SIGNAL pc_out_Dstage, readData1, readData2, IMM_out_Dstage: std_logic_vector(31 downto 0); -- 32 bit outputs
SIGNAL Rd_Dstage, Rs_Dstage, Rt_Dstage: std_logic_vector(2 downto 0);--output registers
SIGNAL WBenSignal_DStage, MEMenSignal_DStage, EXenSignal_DStage: std_logic; --control signals out
SIGNAL index_out_DStage: std_logic_vector(1 downto 0);--index of pc 

-- IF/ID BUFFER SIGNALS

--ID/EX BUFFER SIGNALS
SIGNAL LoadUseAndFlush,ex_signal_in_id_ex ,mem_signal_in_id_ex,wb_signal_in_id_ex: std_logic; --control signals inputs
SIGNAL ex_signal, mem_en_ex, wb_en_ex,ID_EX_MemRead: std_logic; --control signals output
SIGNAL reg1_in_ex,reg2_in_ex, pc_in_id: std_logic_vector(31 downto 0);--registers and PC values
SIGNAL imm_ea_in: std_logic_vector(15 downto 0);--immediate value
SIGNAL Rs_in_exBuff,Rt_in_exBuff,Rd_in_exBuff :std_logic_vector(2 downto 0);--registers addresses
SIGNAL jmp_addres_from_IDEx: std_logic_vector(31 downto 0);
SIGNAL buffer_PC, Rsrc1_instruction,Rsrc2_instruction,IMM: std_logic_vector(31 downto 0);
SIGNAL Rs_out_exBuff,Rt_out_exBuff,Rd_out_exBuff :std_logic_vector(2 downto 0);
SIGNAL restoreflags_idEX, int_en_IdEx, ALu_src_idEX, in_select_idEX, fetch_memory_idEx, mem_read_idEX, mem_write_idEx, stack_en_idEx, mem_to_reg_idEX: std_logic;
SIGNAL CCR_wr_en_idEx: std_logic_vector(2 downto 0);
SIGNAL ALU_OP_idEx: std_logic_vector(4 downto 0);
--Execute stage signals
SIGNAL Rsrc1_mem,Rsrc1_wb,Rsrc2_mem,Rsrc2_wb,ALU_out : std_logic_vector(31 downto 0);--sources comming from ememory and write back stages

SIGNAL isForward1,isForward2: std_logic_vector(1 downto 0);--output of fw unit / input to execute stage
SIGNAL WB_en_mem,MEM_en_mem,WB_en_wb,MEM_en_wb : std_logic; --enable signals
SIGNAL Rsrc1_memBuffer,Rsrc2_memBuffer, buffer_PC_out,execution_output ,Rsrc1_memStage,Rsrc2_memStage: std_logic_vector(31 downto 0);--sources passed to buffers for forwarding
SIGNAL CCR_write_en, CCR_out, Rd_Rs_Out,Rs_in_memBuff,Rt_in_memBuff,Rd_in_memBuff, regAddress:std_logic_vector(2 downto 0);
--EX/mem buffer signals
SIGNAL mem_to_reg_MemWb, fetch_memory_ExMem, mem_read_ExMem, mem_write_ExMem, stack_en_ExMem, mem_to_reg_ExMem,reg_write_en_idEX,reg_write_en_ExMem,reg_write_en_MemWb: std_logic;
 
-- Control Unit Signals
SIGNAL reg_write_en, in_select, mem_write, mem_read, mem_to_reg, stack_en, return_en, ALU_src, flush_if, flush_id, flush_ex, flush_wb: std_logic;
SIGNAL fetch_memory, restore_flags,INT_en, pc_src: std_logic;
SIGNAL reset_or_interrupt: std_logic;
SIGNAL ALU_op: std_logic_vector(4 downto 0);

-- Memory signals
SIGNAL read_data, memoryWrite: std_logic_vector(31 downto 0);

-- Hazard Detection signal
SIGNAL pc_write, hazard_Results: std_logic;
SIGNAL IF_ID_WRITE: std_logic;

--memory stage signals
SIGNAL Rsrc1_mem_out, Rsrc2_mem_out,Mem_dataWrite,mem_stage_output, StoreAddress: std_logic_vector(31 downto 0);
SIGNAL regAddress_wb,Write_address_in: std_logic_vector(2 downto 0);
SIGNAL wb_signal_in, mem_sig_toforward,wb_sig_toforward ,wb_signal_out: std_logic;

SIGNAL Execute_out, Load_value: std_logic_vector(31 downto 0);

--wb stage signals
SIGNAL WB_adress_to_forward:std_logic_vector(2 downto 0);
BEGIN

index <= (31 downto 2 => '0') & index_out_DSTAGE;
fetch: fetch_stage PORT MAP (
        clk => clk,

        --control signals
        pc_src => pc_src,
        RESET_OR_INTR => reset_or_interrupt,
        fetch_memory => fetch_memory_ExMem,
        int_en => int_en,
        reset_in => RESET_IN,
        intr_in => INTR_IN,
        return_en => return_en,
        pc_write => pc_write,
        mem_write => mem_write,

        --other values
        PC_buffer => buffer_pc,
        index => index, 
        mem_ex_output => StoreAddress,
        memory_block_output => read_data,
        EA_in => IMM,

        --output
        pc_out => pc_out,
        address => address
);
MUXPC: mux2x1  GENERIC MAP (32) PORT MAP (Mem_dataWrite, buffer_PC_out , INTR_IN, memoryWrite);

ram: Memory PORT MAP(
	clk => clk,
	interrupt => INTR_IN,
	mem_read => mem_read_ExMem, --enables
	mem_write => mem_write_ExMem,
	stack_en => stack_en_ExMem,
	address => address,--address to read or write
	write_data => memoryWrite,
	read_data => read_data
);

hazards: Hazard_detection PORT MAP(
        clk => clk,
        Rd_in => Rd_out_exBuff,
		RESET_IN => RESET_IN,
		INTR_IN => INTR_IN,
        ID_EX_MemRead => ID_EX_MemRead,--memory enable
        IF_ID_write => IF_ID_write,
        opcode => read_data(31 downto 27),
        Rs_in => instruction(23 downto 21),
        Rt_in => instruction(20 downto 18),
        Pc_write => pc_write,
        hazard_Results => hazard_results
);

controlUnit: control_unit PORT MAP(
	clk => clk,
	rst => RESET_IN,
	intr => INTR_IN,
	opcode => Instruction(31 downto 27), -- will be changed after as the bits must be sent after F/D buffer
	CCR_OUT => CCR_out,
	ccr_wr_en => CCR_write_en,
	reg_write => reg_write_en,
	alu_src => ALU_src,
	alu_op => ALU_op,
	in_select => in_select,
	fetch_memory => fetch_memory,
	mem_write => mem_write,
	mem_read => mem_read,
	stack_en => stack_en,
	mem_to_reg => mem_to_reg,
	return_en => return_en,
	restore_flags => restore_flags,
	int_en => INT_en,
	pc_src => pc_src,
    flush_if => flush_if,
	flush_id => flush_id,
	flush_ex => flush_ex

);
reset_or_interrupt <= int_en or RESET_IN or INTR_IN;

-- Fetch Decode Buffer
bufferFD: buffer_IF_ID PORT MAP(
	clk => clk, 
	rst => RESET_IN,
	flush => flush_if,
	write_en => IF_ID_write,
	instruction_in => read_data,
	pc_in => pc_out,
	instruction => instruction,
	pc => pc_in_id
);

-- Decode Stage
Dstage: Decode_stage PORT MAP (
	clk => clk, 
	rst => RESET_IN,
	instruction => instruction,
	reg_write => reg_write_en_MemWb,
	flush_id => flush_id, 
	hazard_Results => hazard_Results,
	writeData => write_data,
	writeReg => write_reg,
	readData1 => reg1_in_ex, 
	readData2 => reg2_in_ex,
	Rd => Rd_in_exBuff,
	Rs => Rs_in_exBuff, 
	Rt => Rt_in_exBuff, 
	index => index_out_DStage,
	LoadUseAndFlush => LoadUseAndFlush, 
	IMM_out => imm_ea_in
);

-- Decode Execute Buffer
bufferDE: buffer_ID_EX PORT MAP (
	clk => clk, 
	rst => RESET_IN,
	flush => LoadUseAndFlush, 
	pc_in => pc_in_id, 
	reg1_in => reg1_in_ex, 
	reg2_in => reg2_in_ex,
	imm_ea_in => imm_ea_in,
	rsrc1_in => Rs_in_exBuff, 
	rsrc2_in => Rt_in_exBuff, 
	rd_in => Rd_in_exBuff, 
	pc => buffer_PC, 
	reg1 => Rsrc1_instruction, 
	reg2 => Rsrc2_instruction, 
	imm_ea_extend => IMM,
	rsrc1 => Rs_out_exBuff, 
	rsrc2 => Rt_out_exBuff, 
	rd => Rd_out_exBuff, 
	ID_EX_MemRead => ID_EX_MemRead, 
	restore_flags => restore_flags,
	INT_en => INT_en,
	CCR_write_en => CCR_write_en,
	ALU_src => ALU_src,
	ALU_op => ALU_op,
	in_select => in_select,
	fetch_memory => fetch_memory,
	mem_read => mem_read,
	mem_write => mem_write,
	stack_en => stack_en,
	mem_to_reg => mem_to_reg,
	reg_write => reg_write_en, 
	restore_flags_out => restoreflags_idEX, 
	int_en_out => int_en_IdEx,
	CCR_write_en_out => CCR_wr_en_idEx,
	ALU_src_out => ALU_src_idEX, 
	ALU_op_out => ALU_OP_idEx, 
	in_select_out => in_select_idEX,
	fetch_memory_out => fetch_memory_idEx,
	mem_read_out => mem_read_idEX,
	mem_write_out => mem_write_idEx,
	stack_en_out => stack_en_idEx,
	mem_to_reg_out => mem_to_reg_idEX,
	reg_write_out => reg_write_en_idEX,
	jmp_address => jmp_addres_from_IDEx
);
	
ex: ExecuteStage PORT MAP (
		clk => clk, 
		rst => RESET_IN,
		IMM => IMM, 
		IN_PORT => IN_PORT, 
		in_select => in_select_idEX, 
		Rsrc2_mem_in => Rsrc2_mem,
		Rsrc2_wb_in => Rsrc2_wb,
		Rsrc2_instruction => Rsrc2_instruction,
		isForward2 => isForward2, 
		Rsrc1_mem_in => Rsrc1_mem, 
		Rsrc1_wb_in => Rsrc1_wb,
		Rsrc1_instruction => Rsrc1_instruction,
		isForward1 => isForward1,
		alu_src => ALu_src_idEX, 
		ALU_op => ALU_OP_idEx,
		Rd_in => Rd_out_exBuff,
		Rs_in => Rs_out_exBuff, 
		Rt_in => Rt_out_exBuff,
		buffer_PC_in => buffer_PC,
		restore_flags => restoreflags_idEX,
		CCR_write_en => CCR_wr_en_idEx, 
		INT_en => int_en_IdEx, 
		ALU_out => ALU_out,
		OUT_PORT => OUT_PORT, 
		Rsrc1_mem_out => Rsrc1_memBuffer, 
		Rsrc2_mem_out => Rsrc2_memBuffer,
		Rd_Rs_Out => Rd_Rs_Out, 
		Rs_out => Rs_in_memBuff, 
		Rt_out => Rt_in_memBuff,
		Rd_out => Rd_in_memBuff,
		buffer_PC_out => buffer_PC_out, 
		CCR_output => CCR_out
);

bufferEM: buffer_EX_MEM PORT MAP (
		clk => clk, 
		rst => RESET_IN,
		flush => flush_ex,
		alu_in => ALU_out,
		reg_in => Rd_Rs_Out,
		reg1_in => Rsrc1_memBuffer,
		reg2_in => Rsrc2_memBuffer,
		alu => execution_output,
		reg => regAddress,
		reg1 => Rsrc1_memStage,
		reg2 => Rsrc2_memStage,
		fetch_memory => fetch_memory_idEx,
		mem_read => mem_read_idEX,
		mem_write => mem_write_idEx,
		stack_en => stack_en_idEx,
		mem_to_reg => mem_to_reg_idEX,
		reg_write => reg_write_en_idEX,
		fetch_memory_out => fetch_memory_ExMem,
		mem_read_out => mem_read_ExMem, 
		mem_write_out => mem_write_ExMem, 
		stack_en_out => stack_en_ExMem, 
		mem_to_reg_out => mem_to_reg_ExMem,
		reg_write_out => reg_write_en_ExMem
);

				
Rsrc1_mem <= Rsrc1_mem_out;--setting the data going from memory stage to eexecute stage
Rsrc2_mem <= Rsrc2_mem_out;--setting the data going from memory stage to eexecute stage
Mem_dataWrite <= Rsrc1_mem_out;--in store operations this is the value stored
StoreAddress<=mem_stage_output;--in store operations thi is store adress
mem1: MemoryStage PORT MAP (
		Rsrc1_mem_in => Rsrc1_memStage,
		Rsrc2_mem_in => Rsrc2_memStage,	
		Rsrc1_mem_out => Rsrc1_mem_out,--going to execute stage and the MEM/WB buffer and data write 
		Rsrc2_mem_out => Rsrc2_mem_out,--to be used in forwarding
		--enable signals in/out
		execution_output => execution_output,
		mem_stage_output => mem_stage_output,--could be store adress OR vslue to be passed to MEM/WB buffer
		Rd_Rs_in => regAddress,
		Rd_Rs_out => regAddress_wb
);--going to forwarding unit and  MEM/WB buffer

bufferMW: buffer_MEM_WB  PORT MAP (
		clk => clk ,
		rst => RESET_IN,
		flush => flush_wb, 
		opcode_in => read_data,
		alu_in => mem_stage_output,
		reg_in => regAddress_wb,
		reg1_in => Rsrc1_mem_out,--going to execute stage and the MEM/WB buffer and data write 
		reg2_in => Rsrc2_mem_out,--to be used in forwarding
		opcode => Load_value,
		alu => Execute_out,
		reg => Write_address_in,--destination adress for the register file comming from buffer (Rd aw Rs) to wb stage
		reg1 => Rsrc1_wb,
		reg2 => Rsrc2_wb,
		mem_to_reg => mem_to_reg_ExMem,
		reg_write => reg_write_en_ExMem,
		mem_to_reg_out => mem_to_reg_MemWb,
		reg_write_out => reg_write_en_MemWb
);

wb: WBStage PORT MAP (
		Write_address_in, --destination adress for the register file comming from buffer (Rd aw Rs)
		write_reg, --destination adress going to reg file
		Execute_out,--value comming from execute stage(ALU)
		Load_value, --value comming from memory
		mem_to_reg_MemWb,
		Write_address_in,--destination wrue back for previous instruction-> for forwarding unit
		WB_adress_to_forward,--going to the forwarding unit
		
		--going to forwarding unit
		write_data
);
--write back adress and data are connected to the register file inside the decode stage

forwarding: forwardingUnit PORT MAP(
	data1Dst => Rs_out_exBuff,
	data2Dst => Rt_out_exBuff,
	dataMemDst => regAddress_wb,
	dataWbDst => WB_adress_to_forward,
	RegWriteMem => reg_write_en_ExMem,
	RegWriteWb =>  reg_write_en_MemWb,
	selData1 => isForward1,
	selData2 => isForward2);

END ARCHITECTURE;