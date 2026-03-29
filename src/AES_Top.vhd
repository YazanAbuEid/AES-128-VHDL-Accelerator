library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AES_Top is
    Port ( 
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        start      : in  STD_LOGIC;
        plaintext  : in  STD_LOGIC_VECTOR (127 downto 0);
        key        : in  STD_LOGIC_VECTOR (127 downto 0);
        ciphertext : out STD_LOGIC_VECTOR (127 downto 0);
        done       : out STD_LOGIC
    );
end AES_Top;

architecture Behavioral of AES_Top is

    component KeyExpansion
        Port ( key_in     : in  STD_LOGIC_VECTOR(127 downto 0);
               round_keys : out STD_LOGIC_VECTOR(1407 downto 0));
    end component;

    component AES_Round
        Port ( state_in       : in  STD_LOGIC_VECTOR(127 downto 0);
               round_key      : in  STD_LOGIC_VECTOR(127 downto 0);
               is_final_round : in  STD_LOGIC;
               state_out      : out STD_LOGIC_VECTOR(127 downto 0));
    end component;

    type state_type is (IDLE, INIT_ADD, ROUND_EXECUTE, FINISH);
    signal current_state : state_type := IDLE;

    signal all_round_keys : STD_LOGIC_VECTOR(1407 downto 0);
    type key_array_t is array (0 to 10) of std_logic_vector(127 downto 0);
    signal key_array : key_array_t;

    signal active_key      : STD_LOGIC_VECTOR(127 downto 0);
    signal round_in        : STD_LOGIC_VECTOR(127 downto 0);
    signal round_out       : STD_LOGIC_VECTOR(127 downto 0);
    signal data_reg        : STD_LOGIC_VECTOR(127 downto 0);
    
    signal round_counter   : integer range 0 to 15 := 0;
    signal is_final_flag   : STD_LOGIC := '0';

begin

    Inst_KeyExp: KeyExpansion PORT MAP(key_in => key, round_keys => all_round_keys);

    GEN_KEYS: for i in 0 to 10 generate
        key_array(i) <= all_round_keys((10-i)*128 + 127 downto (10-i)*128);
    end generate;

    Inst_AES_Round: AES_Round PORT MAP(
        state_in       => round_in,
        round_key      => active_key,
        is_final_round => is_final_flag,
        state_out      => round_out
    );

    -- Combinatorial logic routing for the AES_Round component
    active_key <= key_array(round_counter);
    is_final_flag <= '1' when round_counter = 10 else '0';
    round_in <= data_reg;

    -- Master Synchronous FSM
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= IDLE;
            data_reg <= (others => '0');
            round_counter <= 0;
            done <= '0';
            ciphertext <= (others => '0');
            
        elsif rising_edge(clk) then
            case current_state is
                when IDLE =>
                    done <= '0';
                    if start = '1' then
                        data_reg <= plaintext;
                        round_counter <= 0;
                        current_state <= INIT_ADD;
                    end if;

                when INIT_ADD =>
                    data_reg <= data_reg xor key_array(0);
                    round_counter <= 1;
                    current_state <= ROUND_EXECUTE;

                when ROUND_EXECUTE =>
                    data_reg <= round_out;
                    if round_counter = 10 then
                        current_state <= FINISH;
                    else
                        round_counter <= round_counter + 1;
                    end if;

                when FINISH =>
                    ciphertext <= data_reg;
                    done <= '1';
                    if start = '0' then
                        current_state <= IDLE;
                    end if;
            end case;
        end if;
    end process;

end Behavioral;