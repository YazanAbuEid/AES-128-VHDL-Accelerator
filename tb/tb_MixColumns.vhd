library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_MixColumns is
end tb_MixColumns;

architecture behavior of tb_MixColumns is

    component MixColumns
    Port ( state_in  : in  STD_LOGIC_VECTOR(127 downto 0);
           state_out : out STD_LOGIC_VECTOR(127 downto 0));
    end component;

    signal state_in  : std_logic_vector(127 downto 0) := (others => '0');
    signal state_out : std_logic_vector(127 downto 0);

begin
    uut: MixColumns PORT MAP (
          state_in => state_in,
          state_out => state_out
        );

    stim_proc: process
    begin		
        wait for 20 ns;	

        -- Official AES standard intermediate state going into MixColumns (Round 1)
        state_in <= x"d4bf5d30e0b452aeb84111f11e2798e5";
        
        wait for 20 ns;
        -- EXPECTED OUTPUT in ModelSim:
        -- x"046681e5e0cb199a48f8d37a2806264c"

        wait;
    end process;
end behavior;