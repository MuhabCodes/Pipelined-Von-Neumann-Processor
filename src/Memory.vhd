library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY Memory IS 
PORT(
 clk: in std_logic; 
 
 mem_read: in std_logic; --enables
 mem_write: in std_logic;
 stack_en: in std_logic;
 
 address: in std_logic_vector(31 downto 0);--address to read or write
 write_data: in std_logic_vector(31 downto 0);

 read_data: out std_logic_vector(31 downto 0)
);
END ENTITY;

ARCHITECTURE Memory_arch OF Memory IS
component mini_alu is
    port(
        clk: in std_logic;
        mem_write: in std_logic;
        stack_en: in std_logic;
        sp_in: in std_logic_vector(31 downto 0);
        sp_out: out std_logic_vector(31 downto 0)
    );
end component;

--defining a memory of 1 mega with 32 bits width
    TYPE mem_type IS ARRAY (0 to 2 ** 20 - 1) OF std_logic_vector(31 downto 0);
    SIGNAL mem: mem_type;
	SIGNAL sp_in: std_logic_vector(31 downto 0) := (31 downto 20 => '0') & (19 downto 1 => '1') & (0 => '0');
	SIGNAl sp_out: std_logic_vector(31 downto 0);
	SIGNAL write_data_signal: std_logic_vector(31 downto 0);

BEGIN
   	PROCESS (clk)
	BEGIN
		--writing in memory with the rising edge
		IF rising_edge(clk) THEN  
		   IF mem_write = '1' THEN
		   	IF stack_en = '1' THEN
				mem(to_integer(unsigned(sp_in))) <= write_data;
			ELSE
				mem(to_integer(unsigned(address))) <= write_data;
			END IF;
			sp_in <= sp_out;
			END IF;
		END IF;
	END PROCESS;
--reading is asynchronous but with a read enable--> to be checked
read_data <= mem(to_integer(unsigned(sp_in))) WHEN stack_en = '1' -- mem_read = '1' AND stack_en = '1'
		ELSE mem(to_integer(unsigned(address)));

miniALU: mini_alu port map (clk=>clk, mem_write=> mem_write, stack_en => stack_en, sp_in => sp_in, sp_out => sp_out);
    
END ARCHITECTURE;