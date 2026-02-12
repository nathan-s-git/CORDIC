library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
    port(
		a: in signed(20 downto 0);
		enable: in std_logic;
		clock: in std_logic;
        o: out signed(20 downto 0)
    );
end entity;

architecture behavior of reg is
begin

	process(clock)
	begin
		if rising_edge(clock) then
			if enable = '1' then
				o <= a;
			end if;
		end if;
	end process;

end architecture;
