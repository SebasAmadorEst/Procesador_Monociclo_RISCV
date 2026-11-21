library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RU is
    port (
        clk    : in  std_logic;
        RUWr   : in  std_logic;
        rs1    : in  std_logic_vector(4 downto 0);
        rs2    : in  std_logic_vector(4 downto 0);
        rd     : in  std_logic_vector(4 downto 0);
        DataWr : in  std_logic_vector(31 downto 0);
        ruRs1  : out std_logic_vector(31 downto 0);
        ruRs2  : out std_logic_vector(31 downto 0)
    );
end entity RU;

architecture Behavioral of RU is
    type reg_file is array (0 to 31) of std_logic_vector(31 downto 0);
    signal regs : reg_file := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if RUWr = '1' and rd /= "00000" then
                regs(to_integer(unsigned(rd))) <= DataWr;
            end if;
        end if;
    end process;

    ruRs1 <= (others => '0') when rs1 = "00000" else
             regs(to_integer(unsigned(rs1)));

    ruRs2 <= (others => '0') when rs2 = "00000" else
             regs(to_integer(unsigned(rs2)));
end architecture Behavioral;
