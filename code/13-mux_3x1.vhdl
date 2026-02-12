library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_3x1 is
    port(
		zero: in signed(20 downto 0);
		one: in signed(20 downto 0);
		two: in signed(20 downto 0);
		sel: in std_logic_vector(1 downto 0);
        o: out signed(20 downto 0)
    );
end entity;

architecture behavior of mux_3x1 is

begin

	o <= zero when sel = "00" else
	     one  when sel = "01" else
		 two  when sel = "10";

end architecture;
