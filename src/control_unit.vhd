library IEEE;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity control_unit IS
port (
	clk : in std_logic;
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
end entity;

architecture struct of control_unit is

component mux4x1 is 
generic (n: integer := 32);
port (
    in1, in2, in3, in4 : in std_logic_vector (n - 1 downto 0);
    sel : in std_logic_vector(1 downto 0);
    out1 : out std_logic_vector (n - 1 downto 0)
);
end component mux4x1;

signal ccr_2, ccr_1, ccr_0, is_jump: std_logic_vector(0 downto 0);
signal jmp_op : std_logic_vector(1 downto 0);
signal jmp_en: std_logic;

begin
	ccr_0(0) <= ccr_out(0);
	ccr_1(0) <= ccr_out(1);
	ccr_2(0) <= ccr_out(2);
	jumpCU: mux4x1 generic map (1) port map (ccr_0, ccr_1, ccr_2, "1", jmp_op, is_jump);

	process(clk) is
	begin
		-- if rising_edge(clk) then 
			if (opcode = "XXXXX") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= "00000";
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- NOP
			elsif (opcode = "00000") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- HLT
			elsif (opcode = "00001") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '1';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- SETC
			elsif (opcode = "00010") then
				ccr_wr_en <= "100";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- RET
			elsif (opcode = "00011") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '1';
				stack_en <= '1';
				mem_to_reg <= '0';
				return_en <= '1';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- RTI
			elsif (opcode = "00100") then
				ccr_wr_en <= "111";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '1';
				stack_en <= '1';
				mem_to_reg <= '0';
				return_en <= '1';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '1';
				int_en <= '0';
				pc_src <= '0';
			-- PUSH
			elsif (opcode = "01000") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '1';
				mem_read <= '0';
				stack_en <= '1';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- POP
			elsif (opcode = "01001") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '1';
				mem_write <= '0';
				mem_read <= '1';
				stack_en <= '1';
				mem_to_reg <= '1';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- OUT
			elsif (opcode = "01010") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '1';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- IN
			elsif (opcode = "01011") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '1';
				alu_op <= opcode;
				in_select <= '1';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- CALL
			elsif (opcode = "01100") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '1';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '1';
				mem_read <= '1';
				stack_en <= '1';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- INT
			elsif (opcode = "01101") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '1';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '1';
				mem_read <= '1';
				stack_en <= '1';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '1';
				pc_src <= '0';
			-- INC
			elsif (opcode = "01110") then
				ccr_wr_en <= "111";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- NOT
			elsif (opcode = "01111") then
				ccr_wr_en <= "011";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- MOV
			elsif (opcode = "10000") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- SWAP
			elsif (opcode = "10001") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- ADD
			elsif (opcode = "10010") then
				ccr_wr_en <= "111";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- SUB
			elsif (opcode = "10011") then
				ccr_wr_en <= "111";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- AND
			elsif (opcode = "10100") then
				ccr_wr_en <= "011";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- JZ
			elsif (opcode = "11000") then
				ccr_wr_en <= "001";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '1';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				if (jmp_en = '1' and is_jump = "1") then 
					pc_src <= '1';
					flush_ex <= '1';
					flush_id <='1';
					flush_if <= '1';
				else
					pc_src <= '0';
				end if;
			-- JN
			elsif (opcode = "11001") then
				ccr_wr_en <= "010";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '1';
				jmp_op <= "01";
				restore_flags <= '0';
				int_en <= '0';
				if(jmp_en = '1' and is_jump = "1") then 
					pc_src <= '1';
					flush_ex <= '1';
					flush_id <='1';
					flush_if <= '1';
				else
					pc_src <= '0';
				end if;
			-- JC
			elsif (opcode = "11010") then
				ccr_wr_en <= "100";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '1';
				jmp_op <= "10";
				restore_flags <= '0';
				int_en <= '0';
				if(jmp_en = '1' and is_jump = "1") then 
					pc_src <= '1';
					flush_ex <= '1';
					flush_id <='1';
					flush_if <= '1';
				else
					pc_src <= '0';
				end if;
			-- JMP
			elsif (opcode = "11011") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '1';
				jmp_op <= "11";
				restore_flags <= '0';
				int_en <= '0';
				if(jmp_en = '1' and is_jump = "1") then 
					pc_src <= '1';
					flush_ex <= '1';
					flush_id <='1';
					flush_if <= '1';
				else
					pc_src <= '0';
				end if;
			-- IADD
			elsif (opcode = "11100") then
				ccr_wr_en <= "111";
				reg_write <= '1';
				alu_src <= '1';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- LDM
			elsif (opcode = "11101") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '1';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- LDD
			elsif (opcode = "11110") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '1';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '1';
				mem_write <= '0';
				mem_read <= '1';
				stack_en <= '0';
				mem_to_reg <= '1';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- STD
			elsif (opcode = "11111") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '1';
				alu_op <= opcode;
				in_select <= '0';
				fetch_memory <= '1';
				mem_write <= '1';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			else
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= "00000";
				in_select <= '0';
				fetch_memory <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= '0';
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			end if;
		--send if;
	end process;
end architecture;