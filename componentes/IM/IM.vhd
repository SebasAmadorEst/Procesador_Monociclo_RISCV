library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library STD;
use STD.TEXTIO.ALL;

entity IM is
    port (
        address     : in  std_logic_vector(31 downto 0);
        instruction : out std_logic_vector(31 downto 0)
    );
end entity IM;

architecture Behavioral of IM is
    type mem_type is array (0 to 127) of std_logic_vector(7 downto 0);

    impure function init_mem return mem_type is
        file f : text open read_mode is "instructions.txt";
        variable l : line;
        variable b : bit_vector(7 downto 0);
        variable m : mem_type := (others => (others => '0'));
        variable i : integer := 0;
    begin
        while not endfile(f) and i < 128 loop
            readline(f, l);
            read(l, b);
            m(i) := to_stdlogicvector(b);
            i := i + 1;
        end loop;
        return m;
    end function;

    signal rom : mem_type := init_mem;
begin
    process(address, rom)
        variable a : integer;
    begin
        instruction <= (others => '0');
        if not is_x(address) then
            if unsigned(address) <= to_unsigned(124, 32) then
                a := to_integer(unsigned(address));
                instruction <= rom(a + 3) & rom(a + 2) & rom(a + 1) & rom(a);
            end if;
        end if;
    end process;
end architecture Behavioral;
