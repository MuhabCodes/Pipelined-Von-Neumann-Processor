library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch_stage is
port(
        clk: in std_logic;

        --control signals
        pc_src: in std_logic;
        control_signal: in std_logic;
        stack_en: in std_logic;
        fetch_memory: in std_logic;
        int_en: in std_logic;
        reset_in: in std_logic;
        intr_in: in std_logic;
        return_en: in std_logic;
        pc_write: in std_logic;

        --other values
        PC_buffer: in std_logic_vector(31 downto 0);
        sp: in std_logic_vector(31 downto 0);
        index: in std_logic_vector(31 downto 0);
        mem_ex_output: in std_logic_vector(31 downto 0);
        readDataMem: in std_logic_vector(31 downto 0);
        memory_block_output: in std_logic_vector(31 downto 0);
        EA_in: in std_logic_vector(31 downto 0);

        --output
        PC_out: out std_logic_vector(31 downto 0);
        address: out std_logic_vector(31 downto 0)
);
end entity;

architecture fetchArch of fetch_stage is
    component mux2x1 is 
        generic (n: integer := 32);
        port (
            in1, in2 : in std_logic_vector (n - 1 downto 0);
            sel : in  std_logic;
            out1: out std_logic_vector (n - 1 downto 0)
        );
    end component mux2x1;

    component program_counter is 
        port ( 
                clk: in  std_logic ;
                pc_write: in std_logic;
                input: in  std_logic_vector (31 downto 0);   
                output: out std_logic_vector (31 downto 0)
            );
    end component ;

    component adder is
        generic (n: integer := 16);
        port(
            cin: in std_logic;
            a,b: in std_logic_vector(n-1 downto 0);
            sum: out std_logic_vector(n-1 downto 0);
            cout: out std_logic
        );
end component;

signal pc_src_mux: std_logic_vector(31 downto 0);
--signal control_signal_mux: std_logic_vector(31 downto 0);
signal one: std_logic_vector(31 downto 0);
signal zero: std_logic_vector(31 downto 0);
signal stack_en_mux: std_logic_vector(31 downto 0);
signal fetch_mem_mux: std_logic_vector(31 downto 0);
signal int_en_mux: std_logic_vector(31 downto 0);
signal RESET_IN_mux: std_logic_vector(31 downto 0);
signal return_en_mux: std_logic_vector(31 downto 0);
signal PC_plus_one: std_logic_vector(31 downto 0);
signal PCinput: std_logic_vector(31 downto 0);
signal pc_out_signal: std_logic_vector(31 downto 0);
    
begin
    one <= (31 downto 1 => '0') & (0 downto 0 => '1');
    zero <= (31 downto 0 => '0');
    pc_portMap: program_counter port map(clk, pc_write, PCinput, pc_out_signal);
    returnadding: adder generic map (32) port map ('0', one, pc_out_signal, PC_plus_one, open);
    returnenMux: mux2x1 generic map (32) port map (PC_plus_one, PC_buffer, return_en, return_en_mux);
    pcSrcMux:  mux2x1 generic map (32) port map (EA_in, return_en_mux, pc_src, pc_src_mux);
    controlmux:  mux2x1 generic map (32) port map (pc_src_mux, memory_block_output, control_signal, PCinput);
    stackenmux:  mux2x1 generic map (32) port map (sp, MEM_EX_Output, stack_en, stack_en_mux);
    fetchmem:  mux2x1 generic map (32) port map (pc_out_signal, stack_en_mux, fetch_memory, fetch_mem_mux);
    intenmux:  mux2x1 generic map (32) port map (fetch_mem_mux, index, int_en, int_en_mux);
    resetINmux:  mux2x1 generic map (32) port map (int_en_mux, zero, RESET_IN, RESET_IN_mux);
    INTRINmux:  mux2x1 generic map (32) port map (RESET_IN_mux, one, INTR_IN,address);
    pc_out <= pc_out_signal;
end architecture fetchArch;