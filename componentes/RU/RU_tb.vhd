library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RU_tb is
end entity RU_tb;

architecture testbench of RU_tb is
    signal clk: std_logic:='0';
    signal RUWr: std_logic:='0';
    signal rs1,rs2,rd: std_logic_vector(4 downto 0):=(others=>'0');
    signal DataWr,ruRs1,ruRs2: std_logic_vector(31 downto 0):=(others=>'0');
begin
    uut: entity work.RU
        port map (
            clk=>clk,
            RUWr=>RUWr,
            rs1=>rs1,
            rs2=>rs2,
            rd=>rd,
            DataWr=>DataWr,
            ruRs1=>ruRs1,
            ruRs2=>ruRs2
        );

    stim_proc: process
    begin
        rs1<="00000";
        rs2<="00000";
        wait for 2 ns;
        assert ruRs1=x"00000000"
            report "Fallo x0"
            severity failure;
        RUWr<='1';
        rd<="00001";
        DataWr<=x"0000000A";
        rs1<="00001";
        wait for 2 ns;
        assert ruRs1=x"00000000"
            report "Escritura antes del flanco"
            severity failure;
        clk<='1';
        wait for 2 ns;
        assert ruRs1=x"0000000A"
            report "Fallo escritura x1"
            severity failure;
        clk<='0';
        rd<="00010";
        DataWr<=x"00000014";
        rs2<="00010";
        wait for 2 ns;
        clk<='1';
        wait for 2 ns;
        assert ruRs1=x"0000000A" and ruRs2=x"00000014"
            report "Fallo doble lectura"
            severity failure;
        clk<='0';
        rd<="00000";
        DataWr<=x"FFFFFFFF";
        wait for 2 ns;
        clk<='1';
        rs1<="00000";
        wait for 2 ns;
        assert ruRs1=x"00000000"
            report "x0 fue modificado"
            severity failure;
        clk<='0';
        RUWr<='0';
        rd<="00001";
        DataWr<=x"FFFFFFFF";
        rs1<="00001";
        wait for 2 ns;
        clk<='1';
        wait for 2 ns;
        assert ruRs1=x"0000000A"
            report "Fallo permiso escritura"
            severity failure;
        report "RU: TODAS LAS PRUEBAS OK"
            severity note;
        wait;
    end process;
end architecture testbench;
