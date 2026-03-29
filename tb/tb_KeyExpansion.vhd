library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_KeyExpansion is
end tb_KeyExpansion;

architecture behavior of tb_KeyExpansion is

    component KeyExpansion
    Port ( key_in     : in  STD_LOGIC_VECTOR(127 downto 0);
           round_keys : out STD_LOGIC_VECTOR(1407 downto 0));
    end component;

    signal key_in     : std_logic_vector(127 downto 0) := (others => '0');
    signal round_keys : std_logic_vector(1407 downto 0);

begin
    uut: KeyExpansion PORT MAP (
          key_in => key_in,
          round_keys => round_keys
        );

    stim_proc: process
    begin		
        wait for 20 ns;	

        -- Standard AES-128 Test Key
        key_in <= x"2b7e151628aed2a6abf7158809cf4f3c";
        
        wait for 20 ns;
        
        -- EXPECTED OUTPUTS embedded in the 1408-bit bus (from MSB to LSB):
        -- Key 0 (Original):  2b7e151628aed2a6abf7158809cf4f3c
        -- Key 1 (Round 1):   a0fafe1788542cb123a339392a6c7605
        -- Key 2 (Round 2):   f2c295f27a96b9435935807a7359f67f
        -- ...
        -- Key 10 (Final):    d014f9a8c9ee2589e13f0cc8b6630ca6

        wait;
    end process;
end behavior;