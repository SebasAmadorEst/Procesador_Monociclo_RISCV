library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IM_tb is
end entity IM_tb;

architecture testbench of IM_tb is
    signal address: std_logic_vector(31 downto 0):=(others=>'0');
    signal instruction: std_logic_vector(31 downto 0);
begin
    uut: entity work.IM
        port map (
            address=>address,
            instruction=>instruction
        );

    stim_proc: process
    begin
        address<=x"00000000";
        wait for 10 ns;
        assert instruction=x"00500093"
            report "Fallo instruccion 0"
            severity failure;
        address<=x"00000004";
        wait for 10 ns;
        assert instruction=x"00A00113"
            report "Fallo instruccion 4"
            severity failure;
        address<=x"00000008";
        wait for 10 ns;
        assert instruction=x"002081B3"
            report "Fallo instruccion 8"
            severity failure;
        address<=x"00000080";
        wait for 10 ns;
        assert instruction=x"00000000"
            report "Fallo fuera de ROM"
            severity failure;
        report "IM: TODAS LAS PRUEBAS OK"
            severity note;
        wait;
    end process;
end architecture testbench;
