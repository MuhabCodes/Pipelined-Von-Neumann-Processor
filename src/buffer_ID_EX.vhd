Library ieee;
use ieee.std_logic_1164.all;

entity buffer_ID_EX is 
port(
	clk : in std_logic;
	rst : in std_logic;
	flush : in std_logic;
	--- INPUTS
	-- --- START stored control signals
	-- ex_signal_in : in std_logic;
	-- mem_signal_in : in std_logic;
	-- wb_signal_in : in std_logic;
	-- --- END stored control signals

	


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
	ID_EX_MemRead: out std_logic;

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

end entity;

architecture struct of buffer_ID_EX is
begin
	process(rst, flush, clk)
	begin
		if falling_edge(clk) and (rst = '1' or flush = '1') then
			--ex_signal <= '0';
			--mem_signal <= '0';
			--wb_signal <= '0';
			pc <= (others => '0');
			reg1 <= (others => '0');
			reg2 <= (others => '0');
			imm_ea_extend <= (31 downto 16 => '0') & imm_ea_in(15 downto 0);
			jmp_address <= (31 downto 16 => '0') & imm_ea_in(15 downto 0);
			rsrc1 <= (others => '0');
			rsrc2 <= (others => '0');
			rd <= (others => '0');
			ID_EX_MemRead <= '0';

			restore_flags_out <= '0';
			INT_en_out <= '0';
			CCR_write_en_out <= (others=>'0');
			ALU_src_out <= '0'; --control signal to choose the second source in ALU op
			ALU_op_out <= (others=>'0');
			in_select_out <= '0';

			--memory stage control signals out
			fetch_memory_out <= '0';
			mem_read_out <= '0'; --sent to forwarding
			mem_write_out <= '0';
			stack_en_out <= '0';

			--wb stage control signals out
			mem_to_reg_out <= '0';
			reg_write_out<='0';
		elsif falling_edge(clk) then

			--ex_signal <= ex_signal_in;
			--mem_signal <= mem_signal_in;
			--wb_signal <= wb_signal_in;
			imm_ea_extend <= (31 downto 16 => '0') & imm_ea_in(15 downto 0);
			pc <= pc_in;
			reg1 <= reg1_in;
			reg2 <= reg2_in;
			rsrc1 <= rsrc1_in;
			rsrc2 <= rsrc2_in;
			rd <= rd_in;
			ID_EX_MemRead <= mem_read;

			restore_flags_out <= restore_flags;
			INT_en_out <= INT_en;
			CCR_write_en_out <= CCR_write_en;
			ALU_src_out <= alu_src; --control signal to choose the second source in ALU op
			ALU_op_out <= ALU_op;
			in_select_out <= in_select;

			--memory stage control signals out
			fetch_memory_out <= fetch_memory;
			mem_read_out <= mem_read; --sent to forwarding
			mem_write_out <= mem_write;
			stack_en_out <= stack_en;

			--wb stage control signals out
			mem_to_reg_out <= mem_to_reg;
			reg_write_out<= reg_write;
		end if;
	end process;
end architecture;