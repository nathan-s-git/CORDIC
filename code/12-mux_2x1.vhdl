library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2x1 is
    port(
		zero: in signed(20 downto 0);
		one: in signed(20 downto 0);
		sel: in std_logic;
        o: out signed(20 downto 0)
    );
end entity;

architecture behavior of mux_2x1 is

begin

	o <= zero when sel = '0' else one;

end architecture;
