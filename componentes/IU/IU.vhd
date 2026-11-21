library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IU is
    port (
        imm : in  std_logic_vector(24 downto 0);
        src : in  std_logic_vector(2 downto 0);
        ext : out std_logic_vector(31 downto 0)
    );
end entity IU;

architecture Behavioral of IU is
    signal instruction : std_logic_vector(31 downto 0);
begin
    -- imm contiene los bits 31..7 de la instruccion original.
    instruction <= imm & "0000000";

    process(instruction, src)
        variable immediate : std_logic_vector(31 downto 0);
    begin
        immediate := (others => '0');

        case src is
            when "000" =>  -- I: incluye instrucciones de desplazamiento
                -- El puerto imm omite opcode (bits 6..0).
                -- Reconocemos los patrones de desplazamiento visibles.
                if (instruction(14 downto 12) = "001" and
                    instruction(31 downto 25) = "0000000") or
                   (instruction(14 downto 12) = "101" and
                    (instruction(31 downto 25) = "0000000" or
                     instruction(31 downto 25) = "0100000")) then
                    immediate := std_logic_vector(resize(unsigned(instruction(24 downto 20)), 32));
                else
                    immediate := std_logic_vector(resize(signed(instruction(31 downto 20)), 32));
                end if;

            when "001" =>  -- S
                immediate := std_logic_vector(resize(
                    signed(instruction(31 downto 25) & instruction(11 downto 7)), 32));

            when "101" =>  -- B
                immediate := std_logic_vector(resize(
                    signed(instruction(31) & instruction(7) &
                           instruction(30 downto 25) & instruction(11 downto 8) & '0'), 32));

            when "010" =>  -- U
                immediate := instruction(31 downto 12) & x"000";

            when "110" =>  -- J
                immediate := std_logic_vector(resize(
                    signed(instruction(31) & instruction(19 downto 12) &
                           instruction(20) & instruction(30 downto 21) & '0'), 32));

            when others =>
                immediate := (others => '0');
        end case;

        ext <= immediate;
    end process;
end architecture Behavioral;
