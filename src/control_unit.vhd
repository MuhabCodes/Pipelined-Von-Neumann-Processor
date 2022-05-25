library IEEE;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity control_unit IS
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
	-- flush_if : out std_logic;
	-- flush_id : out std_logic;
	-- flush_ex : out std_logic;
	-- flush_wb : out std_logic;
);
end entity;

architecture struct of control_unit is
begin
	process(clk) is
	begin
		if rising_edge(clk) then 
			if (opcode = "XXXXX") THEN
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= "00000";
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= "00";
			-- NOP
			elsif (opcode = "00000") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode;
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- HLT
			elsif (opcode = "00001") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '1';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '0';
			-- SETC
			elsif (opcode = "00010") then
				ccr_wr_en <= "100";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- RET
			elsif (opcode = "00011") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '1';
				stack_en <= '1';
				mem_to_reg <= '0';
				return_en <= '1';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '01';
			-- RTI
			elsif (opcode = "00100") then
				ccr_wr_en <= "111";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '1';
				stack_en <= '1';
				mem_to_reg <= '0';
				return_en <= '1';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '1';
				int_en <= '0';
				pc_src <= '01';
			-- PUSH
			elsif (opcode = "01000") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '1';
				mem_read <= '0';
				stack_en <= '1';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- POP
			elsif (opcode = "01001") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '1';
				stack_en <= '1';
				mem_to_reg <= '1';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- OUT
			elsif (opcode = "01010") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '1';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- IN
			elsif (opcode = "01011") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '1';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- CALL
			elsif (opcode = "01100") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '1';
				alu_op <= opcode
				alu_imm <= '1';
				mem_write <= '1';
				mem_read <= '1';
				stack_en <= '1';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- INT
			elsif (opcode = "01101") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '1';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '1';
				mem_read <= '1';
				stack_en <= '1';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '1';
				pc_src <= '00';
			end if;
			-- INC
			elsif (opcode = "01110") then
				ccr_wr_en <= "111";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- NOT
			elsif (opcode = "01111") then
				ccr_wr_en <= "011";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- MOV
			elsif (opcode = "10000") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- SWAP
			elsif (opcode = "10001") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- ADD
			elsif (opcode = "10010") then
				ccr_wr_en <= "111";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- SUB
			elsif (opcode = "10011") then
				ccr_wr_en <= "111";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- AND
			elsif (opcode = "10100") then
				ccr_wr_en <= "111";
				reg_write <= '1';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '0';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- JZ
			elsif (opcode = "11000") then
				ccr_wr_en <= "001";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '1';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "1";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '11';
			-- JN
			elsif (opcode = "11001") then
				ccr_wr_en <= "010";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '1';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "1";
				jmp_op <= "01";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '11';
			-- JC
			elsif (opcode = "11010") then
				ccr_wr_en <= "100";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '1';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "1";
				jmp_op <= "10";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '11';
			-- JMP
			elsif (opcode = "11011") then
				ccr_wr_en <= "000";
				reg_write <= '0';
				alu_src <= '0';
				alu_op <= opcode
				alu_imm <= '1';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "1";
				jmp_op <= "11";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '11';
			-- IADD
			elsif (opcode = "11100") then
				ccr_wr_en <= "111";
				reg_write <= '1';
				alu_src <= '1';
				alu_op <= opcode
				alu_imm <= '1';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- LDM
			elsif (opcode = "11101") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '1';
				alu_op <= opcode
				alu_imm <= '1';
				mem_write <= '0';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '0';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- LDD
			elsif (opcode = "11110") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '1';
				alu_op <= opcode
				alu_imm <= '1';
				mem_write <= '0';
				mem_read <= '1';
				stack_en <= '0';
				mem_to_reg <= '1';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
			-- STD
			elsif (opcode = "11111") then
				ccr_wr_en <= "000";
				reg_write <= '1';
				alu_src <= '1';
				alu_op <= opcode
				alu_imm <= '1';
				mem_write <= '1';
				mem_read <= '0';
				stack_en <= '0';
				mem_to_reg <= '1';
				return_en <= '0';
				jmp_en <= "0";
				jmp_op <= "00";
				restore_flags <= '0';
				int_en <= '0';
				pc_src <= '00';
		end if;
	end process;
end architecture;