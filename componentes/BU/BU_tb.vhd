library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BU_tb is
end entity BU_tb;

architecture Testbench of BU_tb is
    signal A         : std_logic_vector(31 downto 0) := (others => '0');
    signal B         : std_logic_vector(31 downto 0) := (others => '0');
    signal BrOp      : std_logic_vector(4 downto 0) := (others => '0');
    signal NextPCSrc : std_logic;
begin
    UUT : entity work.BU
        port map (
            A         => A,
            B         => B,
            BrOp      => BrOp,
            NextPCSrc => NextPCSrc
        );

    stimulus : process
    begin
        -- Secuencial
        A <= x"0000000A";
        B <= x"0000000A";
        BrOp <= "00000";
        wait for 10 ns;
        assert NextPCSrc = '0'
            report "ERROR: Secuencial" severity error;
        report "OK: Secuencial" severity note;

        -- JAL/JALR
        A <= x"00000000";
        B <= x"00000000";
        BrOp <= "11111";
        wait for 10 ns;
        assert NextPCSrc = '1'
            report "ERROR: JAL/JALR" severity error;
        report "OK: JAL/JALR" severity note;

        -- BEQ verdadero
        A <= x"0000002A";
        B <= x"0000002A";
        BrOp <= "01000";
        wait for 10 ns;
        assert NextPCSrc = '1'
            report "ERROR: BEQ verdadero" severity error;
        report "OK: BEQ verdadero" severity note;

        -- BEQ falso
        A <= x"0000002A";
        B <= x"0000002B";
        BrOp <= "01000";
        wait for 10 ns;
        assert NextPCSrc = '0'
            report "ERROR: BEQ falso" severity error;
        report "OK: BEQ falso" severity note;

        -- BNE verdadero
        A <= x"00000002";
        B <= x"00000003";
        BrOp <= "01001";
        wait for 10 ns;
        assert NextPCSrc = '1'
            report "ERROR: BNE verdadero" severity error;
        report "OK: BNE verdadero" severity note;

        -- BNE falso
        A <= x"00000003";
        B <= x"00000003";
        BrOp <= "01001";
        wait for 10 ns;
        assert NextPCSrc = '0'
            report "ERROR: BNE falso" severity error;
        report "OK: BNE falso" severity note;

        -- BLT verdadero
        A <= x"FFFFFFFB";
        B <= x"00000003";
        BrOp <= "01100";
        wait for 10 ns;
        assert NextPCSrc = '1'
            report "ERROR: BLT verdadero" severity error;
        report "OK: BLT verdadero" severity note;

        -- BLT falso
        A <= x"00000003";
        B <= x"FFFFFFFB";
        BrOp <= "01100";
        wait for 10 ns;
        assert NextPCSrc = '0'
            report "ERROR: BLT falso" severity error;
        report "OK: BLT falso" severity note;

        -- BGE verdadero
        A <= x"00000003";
        B <= x"FFFFFFFB";
        BrOp <= "01101";
        wait for 10 ns;
        assert NextPCSrc = '1'
            report "ERROR: BGE verdadero" severity error;
        report "OK: BGE verdadero" severity note;

        -- BGE falso
        A <= x"FFFFFFFB";
        B <= x"00000003";
        BrOp <= "01101";
        wait for 10 ns;
        assert NextPCSrc = '0'
            report "ERROR: BGE falso" severity error;
        report "OK: BGE falso" severity note;

        -- BLTU verdadero
        A <= x"00000001";
        B <= x"FFFFFFFF";
        BrOp <= "01110";
        wait for 10 ns;
        assert NextPCSrc = '1'
            report "ERROR: BLTU verdadero" severity error;
        report "OK: BLTU verdadero" severity note;

        -- BLTU falso
        A <= x"FFFFFFFF";
        B <= x"00000001";
        BrOp <= "01110";
        wait for 10 ns;
        assert NextPCSrc = '0'
            report "ERROR: BLTU falso" severity error;
        report "OK: BLTU falso" severity note;

        -- BGEU verdadero
        A <= x"FFFFFFFF";
        B <= x"00000001";
        BrOp <= "01111";
        wait for 10 ns;
        assert NextPCSrc = '1'
            report "ERROR: BGEU verdadero" severity error;
        report "OK: BGEU verdadero" severity note;

        -- BGEU falso
        A <= x"00000001";
        B <= x"FFFFFFFF";
        BrOp <= "01111";
        wait for 10 ns;
        assert NextPCSrc = '0'
            report "ERROR: BGEU falso" severity error;
        report "OK: BGEU falso" severity note;

        -- Default
        A <= x"00000000";
        B <= x"00000000";
        BrOp <= "00111";
        wait for 10 ns;
        assert NextPCSrc = '0'
            report "ERROR: Default" severity error;
        report "OK: Default" severity note;

        -- BLT igual
        A <= x"00000005";
        B <= x"00000005";
        BrOp <= "01100";
        wait for 10 ns;
        assert NextPCSrc = '0'
            report "ERROR: BLT igual" severity error;
        report "OK: BLT igual" severity note;

        -- BGE igual
        A <= x"00000005";
        B <= x"00000005";
        BrOp <= "01101";
        wait for 10 ns;
        assert NextPCSrc = '1'
            report "ERROR: BGE igual" severity error;
        report "OK: BGE igual" severity note;

        -- BGEU igual
        A <= x"00000005";
        B <= x"00000005";
        BrOp <= "01111";
        wait for 10 ns;
        assert NextPCSrc = '1'
            report "ERROR: BGEU igual" severity error;
        report "OK: BGEU igual" severity note;

        report "BU: TODAS LAS 18 PRUEBAS TERMINARON" severity note;
        wait;
    end process;
end architecture Testbench;
