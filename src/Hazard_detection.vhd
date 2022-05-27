LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Hazard_detection is
    port(
        clk: in std_logic;
        Rd_in: in std_logic_vector(2 downto 0);
        ID_EX_MemRead:  in std_logic;--memory enable
        IF_ID_write: out std_logic;
        opcode: in std_logic_vector(4 downto 0);
        Rs_in: in std_logic_vector(2 downto 0);
        Rt_in:in std_logic_vector(2 downto 0);
        Pc_write: out std_logic;
        hazard_Results: out std_logic
        --mem_to_reg: in std_logic
    );
end entity;

architecture HazardArch of Hazard_detection is

    
begin
    process(clk)
    begin
        -- if mem_to_reg = '1' and( opcode = "11110" or opcode = "11101")then 
        --     if Rd_in = Rs_in OR Rd_in = Rt_in then
        --         hazard_Results<='1';
       
        if ID_EX_MemRead = '1' and ((Rd_in = Rs_in) or (Rd_in = Rt_in)) then
            hazard_Results<='1';
            Pc_write<='0';
            IF_ID_write<='0';
        else
            hazard_Results<='0';
            Pc_write<='1';
            IF_ID_write<='1';
end if;
end process;






    
end architecture HazardArch;