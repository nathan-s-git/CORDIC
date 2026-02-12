library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity right_shift is
    port(
        a: in  signed(20 downto 0);
		n: in  unsigned(4 downto 0);
        o: out signed(20 downto 0)
    );
end entity;

architecture behavior of right_shift is
begin

	o <= shift_right(a, to_integer(n));

end architecture;
