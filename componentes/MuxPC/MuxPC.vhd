library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MuxPC is
    port (
        PC_4      : in  std_logic_vector(31 downto 0);
        AluJump   : in  std_logic_vector(31 downto 0);
        NextPCSrc : in  std_logic;
        NextPC    : out std_logic_vector(31 downto 0)
    );
end entity MuxPC;

architecture Behavioral of MuxPC is
begin
    NextPC <= AluJump when NextPCSrc = '1' else
              std_logic_vector(unsigned(PC_4) + 4);
end architecture Behavioral;
