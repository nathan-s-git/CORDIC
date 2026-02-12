library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum_or_sub is
    port(
		a: in signed(20 downto 0);
		b: in signed(20 downto 0);
		op: in std_logic;
        o: out signed(20 downto 0)

    );
end entity;

architecture behavior of sum_or_sub is

begin

	o <= a-b when op = '0' else a+b;

end architecture;
