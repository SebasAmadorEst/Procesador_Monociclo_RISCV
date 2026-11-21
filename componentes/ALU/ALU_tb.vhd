library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_tb is
end entity ALU_tb;

architecture Testbench of ALU_tb is
    signal A     : std_logic_vector(31 downto 0) := (others => '0');
    signal B     : std_logic_vector(31 downto 0) := (others => '0');
    signal ALUop : std_logic_vector(3 downto 0) := (others => '0');
    signal ALUS  : std_logic_vector(31 downto 0);
begin
    UUT : entity work.ALU
        port map (
            A     => A,
            B     => B,
            ALUop => ALUop,
            ALUS  => ALUS
        );

    stimulus : process
    begin
        -- ADD
        A <= x"0000000A";
        B <= x"00000014";
        ALUop <= "0000";
        wait for 10 ns;
        assert ALUS = x"0000001E"
            report "ERROR: ADD" severity error;
        report "OK: ADD" severity note;

        -- SUB
        A <= x"00000032";
        B <= x"0000000F";
        ALUop <= "1000";
        wait for 10 ns;
        assert ALUS = x"00000023"
            report "ERROR: SUB" severity error;
        report "OK: SUB" severity note;

        -- AND
        A <= x"FF00FF00";
        B <= x"0F0F0F0F";
        ALUop <= "0111";
        wait for 10 ns;
        assert ALUS = x"0F000F00"
            report "ERROR: AND" severity error;
        report "OK: AND" severity note;

        -- OR
        A <= x"FF00FF00";
        B <= x"0F0F0F0F";
        ALUop <= "0110";
        wait for 10 ns;
        assert ALUS = x"FF0FFF0F"
            report "ERROR: OR" severity error;
        report "OK: OR" severity note;

        -- XOR
        A <= x"FF00FF00";
        B <= x"0F0F0F0F";
        ALUop <= "0100";
        wait for 10 ns;
        assert ALUS = x"F00FF00F"
            report "ERROR: XOR" severity error;
        report "OK: XOR" severity note;

        -- SLL
        A <= x"00000001";
        B <= x"00000004";
        ALUop <= "0001";
        wait for 10 ns;
        assert ALUS = x"00000010"
            report "ERROR: SLL" severity error;
        report "OK: SLL" severity note;

        -- SRL
        A <= x"00000100";
        B <= x"00000003";
        ALUop <= "0101";
        wait for 10 ns;
        assert ALUS = x"00000020"
            report "ERROR: SRL" severity error;
        report "OK: SRL" severity note;

        -- SRA
        A <= x"FFFFFF80";
        B <= x"00000002";
        ALUop <= "1101";
        wait for 10 ns;
        assert ALUS = x"FFFFFFE0"
            report "ERROR: SRA" severity error;
        report "OK: SRA" severity note;

        -- SLT
        A <= x"FFFFFFFB";
        B <= x"00000003";
        ALUop <= "0010";
        wait for 10 ns;
        assert ALUS = x"00000001"
            report "ERROR: SLT" severity error;
        report "OK: SLT" severity note;

        -- SLTU
        A <= x"00000005";
        B <= x"0000000A";
        ALUop <= "0011";
        wait for 10 ns;
        assert ALUS = x"00000001"
            report "ERROR: SLTU" severity error;
        report "OK: SLTU" severity note;

        -- SLT falso
        A <= x"00000003";
        B <= x"FFFFFFFB";
        ALUop <= "0010";
        wait for 10 ns;
        assert ALUS = x"00000000"
            report "ERROR: SLT falso" severity error;
        report "OK: SLT falso" severity note;

        -- SLTU falso
        A <= x"0000000A";
        B <= x"00000005";
        ALUop <= "0011";
        wait for 10 ns;
        assert ALUS = x"00000000"
            report "ERROR: SLTU falso" severity error;
        report "OK: SLTU falso" severity note;

        -- SLT vs SLTU
        A <= x"FFFFFFFF";
        B <= x"00000001";
        ALUop <= "0010";
        wait for 10 ns;
        assert ALUS = x"00000001"
            report "ERROR: SLT vs SLTU" severity error;
        report "OK: SLT vs SLTU" severity note;

        -- SLTU vs SLT
        A <= x"FFFFFFFF";
        B <= x"00000001";
        ALUop <= "0011";
        wait for 10 ns;
        assert ALUS = x"00000000"
            report "ERROR: SLTU vs SLT" severity error;
        report "OK: SLTU vs SLT" severity note;

        -- SLL shamt bajo
        A <= x"00000001";
        B <= x"00000024";
        ALUop <= "0001";
        wait for 10 ns;
        assert ALUS = x"00000010"
            report "ERROR: SLL shamt bajo" severity error;
        report "OK: SLL shamt bajo" severity note;

        -- ALUop default
        A <= x"00000001";
        B <= x"00000001";
        ALUop <= "1111";
        wait for 10 ns;
        assert ALUS = x"00000000"
            report "ERROR: ALUop default" severity error;
        report "OK: ALUop default" severity note;

        report "ALU: TODAS LAS 16 PRUEBAS TERMINARON" severity note;
        wait;
    end process;
end architecture Testbench;
