library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IU_tb is
end entity IU_tb;

architecture Testbench of IU_tb is
    signal instruction : std_logic_vector(31 downto 0) := (others => '0');
    signal src         : std_logic_vector(2 downto 0)  := "000";
    signal ext         : std_logic_vector(31 downto 0);
begin
    uut : entity work.IU
        port map (
            imm => instruction(31 downto 7),
            src => src,
            ext => ext
        );

    stimulus : process
    begin
        -- 1. I: ADDI positivo
        instruction <= x"00500093";
        src <= "000";
        wait for 10 ns;
        assert ext = x"00000005" report "ERROR: I ADDI +5" severity failure;
        report "OK: I ADDI +5" severity note;

        -- 2. I: ADDI negativo
        instruction <= x"FFF00093";
        src <= "000";
        wait for 10 ns;
        assert ext = x"FFFFFFFF" report "ERROR: I ADDI -1" severity failure;
        report "OK: I ADDI -1" severity note;

        -- 3. I: SLLI
        instruction <= x"00309093";
        src <= "000";
        wait for 10 ns;
        assert ext = x"00000003" report "ERROR: I SLLI 3" severity failure;
        report "OK: I SLLI 3" severity note;

        -- 4. I: SRAI
        instruction <= x"4050D093";
        src <= "000";
        wait for 10 ns;
        assert ext = x"00000005" report "ERROR: I SRAI 5" severity failure;
        report "OK: I SRAI 5" severity note;

        -- 5. S: desplazamiento positivo
        instruction <= x"0020A823";
        src <= "001";
        wait for 10 ns;
        assert ext = x"00000010" report "ERROR: S offset +16" severity failure;
        report "OK: S offset +16" severity note;

        -- 6. S: desplazamiento negativo
        instruction <= x"FE20AE23";
        src <= "001";
        wait for 10 ns;
        assert ext = x"FFFFFFFC" report "ERROR: S offset -4" severity failure;
        report "OK: S offset -4" severity note;

        -- 7. B: desplazamiento positivo
        instruction <= x"00000463";
        src <= "101";
        wait for 10 ns;
        assert ext = x"00000008" report "ERROR: B offset +8" severity failure;
        report "OK: B offset +8" severity note;

        -- 8. U: LUI
        instruction <= x"123450B7";
        src <= "010";
        wait for 10 ns;
        assert ext = x"12345000" report "ERROR: U LUI" severity failure;
        report "OK: U LUI" severity note;

        -- 9. J: desplazamiento cero
        instruction <= x"000000EF";
        src <= "110";
        wait for 10 ns;
        assert ext = x"00000000" report "ERROR: J offset 0" severity failure;
        report "OK: J offset 0" severity note;

        -- 10. Selector no definido
        instruction <= x"00000000";
        src <= "111";
        wait for 10 ns;
        assert ext = x"00000000" report "ERROR: Default" severity failure;
        report "OK: Default" severity note;

        report "IU: TODAS LAS 10 PRUEBAS TERMINARON" severity note;
        wait;
    end process;
end architecture Testbench;
