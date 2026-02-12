library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port(
		enable: in std_logic;
		reset: in std_logic;
		clock: in std_logic;
        o: out unsigned(4 downto 0)
    );
end entity;

architecture behavior of counter is

	signal stored: unsigned(4 downto 0);

begin

	process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				stored <= (others => '0');
			elsif enable = '1' then
				stored <= stored + 1;
			end if;
		end if;
	end process;

	o <= stored;

end architecture;
