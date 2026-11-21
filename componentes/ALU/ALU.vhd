library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    port (
        A     : in  std_logic_vector(31 downto 0);
        B     : in  std_logic_vector(31 downto 0);
        ALUop : in  std_logic_vector(3 downto 0);
        ALUS  : out std_logic_vector(31 downto 0)
    );
end entity ALU;

architecture Behavioral of ALU is
    signal shamt : natural range 0 to 31 := 0;
begin
    shamt_calc : process(B)
    begin
        if Is_X(B(4 downto 0)) then
            shamt <= 0;
        else
            shamt <= to_integer(unsigned(B(4 downto 0)));
        end if;
    end process;

    alu_calc : process(A, B, ALUop, shamt)
    begin
        case ALUop is
            when "0000" =>  -- ADD
                ALUS <= std_logic_vector(unsigned(A) + unsigned(B));
            when "1000" =>  -- SUB
                ALUS <= std_logic_vector(unsigned(A) - unsigned(B));
            when "0111" =>  -- AND
                ALUS <= A and B;
            when "0110" =>  -- OR
                ALUS <= A or B;
            when "0100" =>  -- XOR
                ALUS <= A xor B;
            when "0001" =>  -- SLL
                ALUS <= std_logic_vector(shift_left(unsigned(A), shamt));
            when "0101" =>  -- SRL
                ALUS <= std_logic_vector(shift_right(unsigned(A), shamt));
            when "1101" =>  -- SRA
                ALUS <= std_logic_vector(shift_right(signed(A), shamt));
            when "0010" =>  -- SLT (signed)
                if signed(A) < signed(B) then
                    ALUS <= (0 => '1', others => '0');
                else
                    ALUS <= (others => '0');
                end if;
            when "0011" =>  -- SLTU (unsigned)
                if unsigned(A) < unsigned(B) then
                    ALUS <= (0 => '1', others => '0');
                else
                    ALUS <= (others => '0');
                end if;
            when others =>
                ALUS <= (others => '0');
        end case;
    end process;
end architecture Behavioral;
