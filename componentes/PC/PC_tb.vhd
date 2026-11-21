library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC_tb is
end entity PC_tb;

architecture testbench of PC_tb is
    signal clk: std_logic:='0';
    signal reset: std_logic:='0';
    signal PC_in: std_logic_vector(31 downto 0):=(others=>'0');
    signal PC_out: std_logic_vector(31 downto 0);
begin
    uut: entity work.PC
        port map (
            clk=>clk,
            reset=>reset,
            PC_in=>PC_in,
            PC_out=>PC_out
        );

    stim_proc: process
    begin
        reset<='1';
        PC_in<=x"00000040";
        wait for 5 ns;
        clk<='1';
        wait for 1 ns;
        assert PC_out=x"00000000"
            report "Fallo reset"
            severity failure;
        clk<='0';
        reset<='0';
        PC_in<=x"00000004";
        wait for 5 ns;
        assert PC_out=x"00000000"
            report "Cambio sin reloj"
            severity failure;
        clk<='1';
        wait for 1 ns;
        assert PC_out=x"00000004"
            report "Fallo PC=4"
            severity failure;
        clk<='0';
        PC_in<=x"00000008";
        wait for 5 ns;
        clk<='1';
        wait for 1 ns;
        assert PC_out=x"00000008"
            report "Fallo PC=8"
            severity failure;
        clk<='0';
        PC_in<=x"0000000C";
        wait for 5 ns;
        clk<='1';
        wait for 1 ns;
        assert PC_out=x"0000000C"
            report "Fallo PC=12"
            severity failure;
        clk<='0';
        reset<='1';
        wait for 5 ns;
        clk<='1';
        wait for 1 ns;
        assert PC_out=x"00000000"
            report "Fallo reset final"
            severity failure;
        report "PC: TODAS LAS PRUEBAS OK"
            severity note;
        wait;
    end process;
end architecture testbench;
