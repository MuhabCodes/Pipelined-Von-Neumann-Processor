library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY Memory IS 
PORT(
 clk: in std_logic; 
 
 mem_read: in std_logic; --enables
 mem_write: in std_logic;
 
 address: in std_logic_vector(22 downto 0);--address to read or write
 write_data: in std_logic_vector(31 downto 0);

 read_data: out std_logic_vector(31 downto 0)
);
END ENTITY;

ARCHITECTURE Memory_arch OF Memory IS

--defining a memory of 1 mega with 32 bits width
    TYPE mem_type IS ARRAY (0 to 8388607) OF std_logic_vector(31 downto 0);
    SIGNAL mem: mem_type;


BEGIN
   	PROCESS (clk)
	BEGIN
		--writing in memory with the rising edge
		IF rising_edge(clk) THEN  
		   IF mem_write = '1' THEN
			mem(to_integer(unsigned(address))) <= write_data;
		   END IF;
		END IF;

	END PROCESS;
--reading is asynchronous but with a read enable--> to be checked
read_data <= mem(to_integer(unsigned(address))) WHEN mem_read = '1';
    
END ARCHITECTURE;