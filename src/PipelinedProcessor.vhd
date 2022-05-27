
Library ieee;
use ieee.std_logic_1164.all;


ENTITY PipelinedProcessor IS 
PORT(
	clk:in std_logic;
	IN_PORT : in std_logic_vector(31 downto 0);
	OUT_PORT:out std_logic_vector(31 downto 0)
);
END ENTITY;

ARCHITECTURE PipelinedProcessor_arch OF PipelinedProcessor  IS
COMPONENT  control_unit IS
PORT(
	clk : in std_logic;
	opcode : in std_logic_vector(4 downto 0);
	CCR_OUT: in std_logic_vector(2 downto 0);
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
	restore_flags : out std_logic;
	int_en : out std_logic;
	pc_src : out std_logic_vector(1 downto 0);
        flush_if : out std_logic;
	flush_id : out std_logic;
	flush_ex : out std_logic;
	flush_wb : out std_logic);
END COMPONENT ;

COMPONENT decode_stage is
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
END COMPONENT;

COMPONENT buffer_ID_EX is 
PORT(
	clk : in std_logic;
	flush : in std_logic;
	--- INPUTS
	--- START stored control signals
	ex_signal_in : in std_logic;
	mem_signal_in : in std_logic;
	wb_signal_in : in std_logic;
	--- END stored control signals
	pc_in : in std_logic_vector(31 downto 0);
	reg1_in : in std_logic_vector(31 downto 0);
	reg2_in : in std_logic_vector(31 downto 0);
	imm_ea_in : in std_logic_vector(15 downto 0);
	rsrc1_in : in std_logic_vector(2 downto 0);
	rsrc2_in : in std_logic_vector(2 downto 0);
	rd_in : in std_logic_vector(2 downto 0);
	--- OUTPUTS
	--- START stored control signals
	ex_signal : out std_logic;
	mem_signal : out std_logic;
	wb_signal : out std_logic;
	--- END stored control signals
	pc : out std_logic_vector(31 downto 0);
	reg1 : out std_logic_vector(31 downto 0);
	reg2 : out std_logic_vector(31 downto 0);
	imm_ea_extend : out std_logic_vector(31 downto 0);
	rsrc1 : out std_logic_vector(2 downto 0);
	rsrc2 : out std_logic_vector(2 downto 0);
	rd : out std_logic_vector(2 downto 0);
	---
	ID_EX_MemRead:  out std_logic);
END COMPONENT ;

COMPONENT ExecuteStage IS 
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

 	buffer_PC_out:out std_logic_vector(31 downto 0));
END COMPONENT ;

COMPONENT buffer_EX_MEM is 
port(
	clk : in std_logic;
	flush : in std_logic;
	--- INPUTS
	--- START stored control signals
	mem_signal_in : in std_logic;
	wb_signal_in : in std_logic;
	--- END stored control signals
	alu_in : in std_logic_vector(31 downto 0);
	reg_in : in std_logic_vector(2 downto 0);
        reg1_in : in std_logic_vector(31 downto 0);
	reg2_in : in std_logic_vector(31 downto 0);
	--- OUTPUTS
	--- START stored control signals
	mem_signal : out std_logic;
	wb_signal : out std_logic;
	--- END stored control signals
	alu : out std_logic_vector(31 downto 0);
	reg : out std_logic_vector(2 downto 0);
	reg1 : out std_logic_vector(31 downto 0);
	reg2 : out std_logic_vector(31 downto 0));
END COMPONENT ;

COMPONENT MemoryStage IS 
PORT(
 	Rsrc1_mem_in : in std_logic_vector(31 downto 0); --comming from buffer EX/MEM-> it will go into the write data of the memory
 	Rsrc2_mem_in : in std_logic_vector(31 downto 0);
	Rsrc1_mem_out : out std_logic_vector(31 downto 0);--going to execute stage and the MEM/WB buffer and data write 
	Rsrc2_mem_out : out std_logic_vector(31 downto 0);--to be used in forwarding
	mem_en_in, wb_en_in: in std_logic;
 	mem_en_out, wb_en_out: out std_logic;
	execution_output: in std_logic_vector(31 downto 0); --value comming from execute stage (Rsrc2+offset)-> memory address
 	mem_stage_output: out std_logic_vector(31 downto 0);--could be store adress OR vslue to be passed to MEM/WB buffer
 	Rd_Rs_in: in std_logic_vector(2 downto 0);
 	Rd_Rs_out: out std_logic_vector(2 downto 0));--going to forwarding unit and  MEM/WB buffer);
END COMPONENT ;

COMPONENT Memory IS 
PORT(
 	 clk: in std_logic; 
	 mem_read: in std_logic; --enables
	 mem_write: in std_logic;
	 address: in std_logic_vector(22 downto 0);--address to read or write
 	 write_data: in std_logic_vector(31 downto 0);
	 read_data: out std_logic_vector(31 downto 0));
END COMPONENT ;


COMPONENT  buffer_MEM_WB is 
PORT(
	clk : in std_logic;
	flush : in std_logic;
	--- INPUTS
	--- START stored control signals
	wb_signal_in : in std_logic;
	--- END stored control signals
	opcode_in : in std_logic_vector(31 downto 0);
	alu_in : in std_logic_vector(31 downto 0);
	reg_in : in std_logic_vector(2 downto 0);
	reg1_in : in std_logic_vector(31 downto 0);
	reg2_in : in std_logic_vector(31 downto 0);
	--- OUTPUTS
	--- START stored control signals
	wb_signal : out std_logic;
	--- END stored control signals
	opcode : out std_logic_vector(31 downto 0);
	alu : out std_logic_vector(31 downto 0);
	reg : out std_logic_vector(2 downto 0);
	reg1 : out std_logic_vector(31 downto 0);
	reg2 : out std_logic_vector(31 downto 0));
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
 	Rsrc1_wb_in : in std_logic_vector(31 downto 0); --comming from buffer MEM/WB
	Rsrc2_wb_in : in std_logic_vector(31 downto 0);
 	Rsrc1_wb_out : out std_logic_vector(31 downto 0);--going to execute stage
 	Rsrc2_wb_out : out std_logic_vector(31 downto 0);
 	wb_enable_in :in std_logic;--comming from MEM/WB buffer
 	wb_enable_out:out std_logic; --going to forwarding unit
 	Write_back_out :out std_logic_vector(31 downto 0) );
END COMPONENT ;

COMPONENT  registersFile is
PORT(
        reg_write: in std_logic;-- write enable in register file
        clk, rst: in std_logic;
        Rsrc1,Rsrc2: in std_logic_vector(2 downto 0); --reading source adresses
        write_reg: in std_logic_vector(2 downto 0); --writing destination adresses
        write_data: in std_logic_vector(31 downto 0);
        read_data1,read_data2: out std_logic_vector(31 downto 0));
END COMPONENT ;

--Decode stage signals
SIGNAL reg_write, flush_id, WBen, MEMen, EXen, hazard_Results: std_logic; --control signals in
SIGNAL Instruction, write_data, PC_in_Dstage, IMM_in_Dstage: std_logic_vector(31 downto 0); --input addresses/instruction
SIGNAL write_reg: std_logic_vector(2 downto 0);--desitnation register address
--SIGNAL pc_out_Dstage, readData1, readData2, IMM_out_Dstage: std_logic_vector(31 downto 0); -- 32 bit outputs
SIGNAL Rd_Dstage, Rs_Dstage, Rt_Dstage: std_logic_vector(2 downto 0);--output registers
SIGNAL WBenSignal_DStage, MEMenSignal_DStage, EXenSignal_DStage: std_logic; --control signals out
SIGNAL index_out_DStage: std_logic_vector(1 downto 0);--index of pc 

--ID/EX BUFFER SIGNALS
SIGNAL flush,ex_signal_in_id_ex ,mem_signal_in_id_ex,wb_signal_in_id_ex: std_logic; --control signals inputs
SIGNAL ex_signal, mem_en_ex, wb_en_ex,ID_EX_MemRead: std_logic; --control signals output
SIGNAL pc_in,reg1_in_ex,reg2_in_ex : std_logic_vector(31 downto 0);--registers and PC values
SIGNAL imm_ea_in : std_logic_vector(15 downto 0);--immediate value
SIGNAL Rs_in_exBuff,Rt_in_exBuff,Rd_in_exBuff :std_logic_vector(2 downto 0);--registers addresses

SIGNAL buffer_PC ,Rsrc1_instruction,Rsrc2_instruction,IMM: std_logic_vector(31 downto 0);
SIGNAL Rs_out_exBuff,Rt_out_exBuff,Rd_out_exBuff :std_logic_vector(2 downto 0);

--Execute stage signals
SIGNAL in_select,ALU_src,restore_flags,INT_en: std_logic;--control signals
SIGNAL ALU_op: std_logic_vector(4 downto 0);
SIGNAL Rsrc1_mem,Rsrc1_wb,Rsrc2_mem,Rsrc2_wb,ALU_out : std_logic_vector(31 downto 0);--sources comming from ememory and write back stages

SIGNAL isForward1,isForward2: std_logic_vector(1 downto 0);--output of fw unit / input to execute stage
SIGNAL WB_en_mem,MEM_en_mem,WB_en_wb,MEM_en_wb : std_logic; --enable signals
SIGNAL Rsrc1_memBuffer,Rsrc2_memBuffer, buffer_PC_out,execution_output ,Rsrc1_memStage,Rsrc2_memStage: std_logic_vector(31 downto 0);--sources passed to buffers for forwarding
SIGNAL CCR_write_en, Rd_Rs_Out,Rs_in_memBuff,Rt_in_memBuff,Rd_in_memBuff, regAddress:std_logic_vector(2 downto 0);

--memory stage signals
SIGNAL Rsrc1_mem_out, Rsrc2_mem_out,Mem_dataWrite,mem_stage_output, StroreAdress: std_logic_vector(31 downto 0);
SIGNAL regAddress_wb,Write_address_in: std_logic_vector(2 downto 0);
SIGNAL wb_signal_in, mem_sig_toforward,wb_sig_toforward : std_logic;

SIGNAL Execute_out, Load_value: std_logic_vector(31 downto 0);
BEGIN


Dstage: Decode_stage PORT MAP (clk, '0', instruction, reg_write, flush, WBen, MEMen,
				EXen, hazard_Results, write_data,write_reg,PC_in_Dstage,
				pc_in, reg1_in_ex,reg2_in_ex,Rd_in_exBuff,Rs_in_exBuff,Rt_in_exBuff, 
				index_out_DStage,wb_signal_in_id_ex,mem_signal_in_id_ex,ex_signal_in_id_ex,
				imm_ea_in);


buffer1: buffer_ID_EX PORT MAP (clk,flush,ex_signal_in_id_ex ,mem_signal_in_id_ex,
				wb_signal_in_id_ex, pc_in,reg1_in_ex,reg2_in_ex ,imm_ea_in,
				Rs_in_exBuff,Rt_in_exBuff,Rd_in_exBuff ,ex_signal, mem_en_ex,
				wb_en_ex,buffer_PC,Rsrc1_instruction,Rsrc2_instruction,IMM,
				Rs_out_exBuff,Rt_out_exBuff,Rd_out_exBuff,ID_EX_MemRead);


ex: ExecuteStage PORT MAP (
   				clk,IMM,IN_PORT,in_select,Rsrc2_mem,Rsrc2_wb,Rsrc2_instruction,
 				isForward2,Rsrc1_mem,Rsrc1_wb ,Rsrc1_instruction ,isForward1,
 				ALU_src,ALU_op,Rd_out_exBuff,Rs_out_exBuff,Rt_out_exBuff,
 				buffer_PC,restore_flags,CCR_write_en,INT_en,
 				wb_en_ex,mem_en_ex,WB_en_mem,MEM_en_mem,ALU_out,
 				OUT_PORT,Rsrc1_memBuffer,Rsrc2_memBuffer,
 				Rd_Rs_Out,Rs_in_memBuff,Rt_in_memBuff,Rd_in_memBuff,buffer_PC_out);

 buffer2:buffer_EX_MEM PORT MAP (
	 			clk, flush ,MEM_en_mem,WB_en_mem,ALU_out,Rd_Rs_Out,Rsrc1_memBuffer,
				Rsrc2_memBuffer,WB_en_wb,MEM_en_wb,execution_output,regAddress,Rsrc1_memStage,Rsrc2_memStage);

				
Rsrc1_mem<=Rsrc1_mem_out;--setting the data going from memory stage to eexecute stage
Mem_dataWrite<=Rsrc1_mem_out;--in store operations this is the value stored
StroreAdress<=mem_stage_output;--in store operations thi is store adress
mem1: MemoryStage PORT MAP (
			Rsrc1_memStage,Rsrc2_memStage,	
			Rsrc1_mem_out,--going to execute stage and the MEM/WB buffer and data write 
			Rsrc2_mem_out,--to be used in forwarding
			MEM_en_wb,WB_en_wb,mem_sig_toforward,wb_signal_in,--enable signals in /out
			execution_output,
			mem_stage_output,--could be store adress OR vslue to be passed to MEM/WB buffer
			regAddress,
			regAddress_wb);--going to forwarding unit and  MEM/WB buffer

buffer3: buffer_MEM_WB  PORT MAP (
			clk ,flush ,wb_signal_in,mem_stage_output,execution_output,regAddress_wb,
			Rsrc1_mem_out,--going to execute stage and the MEM/WB buffer and data write 
			Rsrc2_mem_out,--to be used in forwarding
			wb_sig_toforward,Load_value,Execute_out,
			Write_address_in,--destination adress for the register file comming from buffer (Rd aw Rs) to wb stage
			Rsrc1_wb,Rsrc2_wb);
			
END ARCHITECTURE;
