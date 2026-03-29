library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRows is
    Port ( 
        state_in  : in  STD_LOGIC_VECTOR (127 downto 0);
        state_out : out STD_LOGIC_VECTOR (127 downto 0)
    );
end ShiftRows;

architecture Behavioral of ShiftRows is
begin
    -- Row 0: No shift
    state_out(127 downto 120) <= state_in(127 downto 120);
    state_out(95 downto 88)   <= state_in(95 downto 88);
    state_out(63 downto 56)   <= state_in(63 downto 56);
    state_out(31 downto 24)   <= state_in(31 downto 24);

    -- Row 1: Shift left by 1 byte
    state_out(119 downto 112) <= state_in(87 downto 80);   -- Grab Byte 5
    state_out(87 downto 80)   <= state_in(55 downto 48);   -- Grab Byte 9
    state_out(55 downto 48)   <= state_in(23 downto 16);   -- Grab Byte 13
    state_out(23 downto 16)   <= state_in(119 downto 112); -- Grab Byte 1 (wrap around)

    -- Row 2: Shift left by 2 bytes (Your code here was perfect!)
    state_out(111 downto 104) <= state_in(47 downto 40);  
    state_out(79 downto 72)   <= state_in(15 downto 8);   
    state_out(47 downto 40)   <= state_in(111 downto 104);
    state_out(15 downto 8)    <= state_in(79 downto 72);  

    -- Row 3: Shift left by 3 bytes (or right by 1)
    state_out(103 downto 96) <= state_in(7 downto 0);     -- Grab Byte 15 (wrap around)
    state_out(71 downto 64)  <= state_in(103 downto 96);  
    state_out(39 downto 32)  <= state_in(71 downto 64);   
    state_out(7 downto 0)    <= state_in(39 downto 32);   
end Behavioral;