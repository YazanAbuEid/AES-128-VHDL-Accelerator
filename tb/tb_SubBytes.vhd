library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_SubBytes is
end tb_SubBytes;

architecture behavior of tb_SubBytes is

    component SubBytes
    Port ( state_in  : in  STD_LOGIC_VECTOR(127 downto 0);
           state_out : out STD_LOGIC_VECTOR(127 downto 0));
    end component;

    signal state_in  : std_logic_vector(127 downto 0) := (others => '0');
    signal state_out : std_logic_vector(127 downto 0);

begin
    uut: SubBytes PORT MAP (
          state_in => state_in,
          state_out => state_out
        );

    stim_proc: process
    begin		
        wait for 20 ns;	

        -- Test Case: Sequential bytes to test multiple S-Box lookups at once
        -- Inputs:  00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 0A, 0B, 0C, 0D, 0E, 0F
        state_in <= x"000102030405060708090A0B0C0D0E0F";
        
        wait for 20 ns;
        -- EXPECTED OUTPUT in ModelSim: 
        -- x"637C777BF26B6FC53001672BFED7AB76"

        wait;
    end process;
end behavior;