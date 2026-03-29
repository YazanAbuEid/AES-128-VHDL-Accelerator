library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_AES_Top is
end tb_AES_Top;

architecture behavior of tb_AES_Top is

    component AES_Top
    Port ( clk        : in STD_LOGIC;
           rst        : in STD_LOGIC;
           start      : in STD_LOGIC;
           plaintext  : in STD_LOGIC_VECTOR(127 downto 0);
           key        : in STD_LOGIC_VECTOR(127 downto 0);
           ciphertext : out STD_LOGIC_VECTOR(127 downto 0);
           done       : out STD_LOGIC);
    end component;

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal start      : std_logic := '0';
    signal plaintext  : std_logic_vector(127 downto 0) := (others => '0');
    signal key        : std_logic_vector(127 downto 0) := (others => '0');
    signal ciphertext : std_logic_vector(127 downto 0);
    signal done       : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin
    uut: AES_Top PORT MAP (
          clk => clk,
          rst => rst,
          start => start,
          plaintext => plaintext,
          key => key,
          ciphertext => ciphertext,
          done => done
        );

    -- Clock process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- Hold reset state for 20 ns.
        rst <= '1';
        wait for 20 ns;	
        rst <= '0';
        wait for clk_period*2;

        -- Load official AES-128 Test Vectors
        plaintext <= x"3243f6a8885a308d313198a2e0370734";
        key       <= x"2b7e151628aed2a6abf7158809cf4f3c";
        
        -- Start encryption
        start <= '1';
        wait for clk_period;
        start <= '0';

        -- Wait for the done signal
        wait until done = '1';
        
        -- The expected output on the ciphertext port should be:
        -- x"3925841D02DC09FBDC118597196A0B32"
        
        wait for clk_period*5;
        wait; -- Stop simulation
    end process;

end behavior;