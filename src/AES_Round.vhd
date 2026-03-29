library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AES_Round is
    Port ( 
        state_in       : in  STD_LOGIC_VECTOR (127 downto 0);
        round_key      : in  STD_LOGIC_VECTOR (127 downto 0);
        is_final_round : in  STD_LOGIC;
        state_out      : out STD_LOGIC_VECTOR (127 downto 0)
    );
end AES_Round;

architecture Structural of AES_Round is

    component SubBytes
        Port ( state_in : in STD_LOGIC_VECTOR(127 downto 0);
               state_out : out STD_LOGIC_VECTOR(127 downto 0));
    end component;

    component ShiftRows
        Port ( state_in : in STD_LOGIC_VECTOR(127 downto 0);
               state_out : out STD_LOGIC_VECTOR(127 downto 0));
    end component;

    component MixColumns
        Port ( state_in : in STD_LOGIC_VECTOR(127 downto 0);
               state_out : out STD_LOGIC_VECTOR(127 downto 0));
    end component;

    component AddRoundKey
        Port ( state_in  : in STD_LOGIC_VECTOR(127 downto 0);
               round_key : in STD_LOGIC_VECTOR(127 downto 0);
               state_out : out STD_LOGIC_VECTOR(127 downto 0));
    end component;

    signal sb_out, sr_out, mc_internal, mc_out : STD_LOGIC_VECTOR (127 downto 0);

begin

    Inst_SubBytes: SubBytes PORT MAP (state_in => state_in, state_out => sb_out);
    Inst_ShiftRows: ShiftRows PORT MAP (state_in => sb_out, state_out => sr_out);
    Inst_MixColumns: MixColumns PORT MAP (state_in => sr_out, state_out => mc_internal);

    -- Bypass MixColumns on round 10
    mc_out <= sr_out when is_final_round = '1' else mc_internal; 

    Inst_AddRoundKey: AddRoundKey PORT MAP (
        state_in  => mc_out, 
        round_key => round_key, 
        state_out => state_out 
    );

end Structural;