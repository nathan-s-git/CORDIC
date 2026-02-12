library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum is
    port(
		a: in signed(20 downto 0);
		b: in signed(20 downto 0);
        o: out signed(20 downto 0)
    );
end entity;

architecture behavior of sum is

begin

	o <= a + b;

end architecture;
