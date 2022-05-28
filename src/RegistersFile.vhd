library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity registersFile is
    port(
        reg_write: in std_logic;-- write enable in register file
        clk, rst: in std_logic;
        Rsrc1,Rsrc2: in std_logic_vector(2 downto 0); --reading source adresses
        write_reg: in std_logic_vector(2 downto 0); --writing destination adresses
        write_data: in std_logic_vector(31 downto 0);
        read_data1,read_data2: out std_logic_vector(31 downto 0)
    );
end entity;


architecture registersFile_arch of registersFile is

    type reg_file is array (0 to 7) of std_logic_vector(31 downto 0);
    signal regOut: reg_file;

    signal wReg: std_logic_vector(7 downto 0);

    component reg is 
    generic(n: integer :=32);
        port(
            d:	in	std_logic_vector(n-1 downto 0) := (others=>'0');
            q:	out	std_logic_vector(n-1 downto 0) := (others=>'0');
            en, clk, rst:	in	std_logic
        );
    end component;

	


begin
   	process (clk)
	begin
		wReg <= (others => '0');
		wReg(to_integer(unsigned(write_reg))) <= reg_write;
	end process;

	loop1: for i in 0 to 7 generate
		regX: reg generic map(32) port map(write_data, regOut(i), wReg(i), clk, rst);
	end generate;

    read_data1 <= regOut(to_integer(unsigned(Rsrc1)));
    read_data2 <= regOut(to_integer(unsigned(Rsrc2)));

end registersFile_arch ; -- arch