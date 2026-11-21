library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MuxPC_tb is
end entity MuxPC_tb;

architecture testbench of MuxPC_tb is
    signal PC_4,AluJump,NextPC: std_logic_vector(31 downto 0):=(others=>'0');
    signal NextPCSrc: std_logic:='0';
begin
    uut: entity work.MuxPC
        port map (
            PC_4=>PC_4,
            AluJump=>AluJump,
            NextPCSrc=>NextPCSrc,
            NextPC=>NextPC
        );

    stim_proc: process
    begin
        PC_4<=x"00000000";
        AluJump<=x"00000100";
        NextPCSrc<='0';
        wait for 10 ns;
        assert NextPC=x"00000004"
            report "Fallo secuencia 0"
            severity failure;
        PC_4<=x"00000008";
        wait for 10 ns;
        assert NextPC=x"0000000C"
            report "Fallo secuencia 8"
            severity failure;
        NextPCSrc<='1';
        wait for 10 ns;
        assert NextPC=x"00000100"
            report "Fallo salto"
            severity failure;
        AluJump<=x"00000008";
        wait for 10 ns;
        assert NextPC=x"00000008"
            report "Fallo salto atras"
            severity failure;
        NextPCSrc<='0';
        wait for 10 ns;
        assert NextPC=x"0000000C"
            report "Fallo selector"
            severity failure;
        PC_4<=x"FFFFFFFC";
        wait for 10 ns;
        assert NextPC=x"00000000"
            report "Fallo overflow"
            severity failure;
        report "MuxPC: TODAS LAS PRUEBAS OK"
            severity note;
        wait;
    end process;
end architecture testbench;
