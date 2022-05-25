LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY forwardingUnit IS
    PORT (
        
        data1Dst, data2Dst, dataMemDst, dataWbDst : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        RegWriteMem, RegWriteWb : in std_logic ;

        selData1, selData2 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
    );
END forwardingUnit;

ARCHITECTURE forwardingUnit_arch OF forwardingUnit IS

BEGIN

    selData1 <= "00" WHEN data1Dst = dataMemDst and RegWriteMem='1' ELSE
        "01" WHEN data1Dst = dataWbDst and RegWriteWb='1' ELSE
        "10";

    selData2 <= "00" WHEN data2Dst = dataMemDst and RegWriteMem='1' ELSE
        "01" WHEN data2Dst = dataWbDst and RegWriteWb='1' ELSE
        "10";

END forwardingUnit_arch;