library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MixColumns is
    Port ( 
        state_in  : in  STD_LOGIC_VECTOR (127 downto 0);
        state_out : out STD_LOGIC_VECTOR (127 downto 0)
    );
end MixColumns;

architecture Behavioral of MixColumns is

    function xtime(x: std_logic_vector) return std_logic_vector is
    begin
        if x(7) = '1' then
            return (x(6 downto 0) & '0') xor x"1B";
        else
            return (x(6 downto 0) & '0');
        end if;
    end function;

begin
    process(state_in)
        variable b0, b1, b2, b3 : std_logic_vector(7 downto 0);
    begin
        for i in 0 to 3 loop
            b3 := state_in((i*32)+31 downto (i*32)+24);
            b2 := state_in((i*32)+23 downto (i*32)+16);
            b1 := state_in((i*32)+15 downto (i*32)+8);
            b0 := state_in((i*32)+7 downto (i*32)+0);

            state_out((i*32)+31 downto (i*32)+24) <= (xtime(b3) xor (xtime(b2) xor b2)) xor (b1 xor b0);
            state_out((i*32)+23 downto (i*32)+16) <= (b3 xor xtime(b2)) xor ((xtime(b1) xor b1) xor b0);
            state_out((i*32)+15 downto (i*32)+8)  <= ((b3 xor b2) xor xtime(b1)) xor (xtime(b0) xor b0);
            state_out((i*32)+7 downto (i*32)+0)   <= ((xtime(b3) xor b3) xor (b2 xor b1)) xor xtime(b0);
        end loop;
    end process;
end Behavioral;
