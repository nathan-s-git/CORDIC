library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arctans is
    port(
		address: in unsigned(4 downto 0);
        o: out signed(20 downto 0)
    );
end entity;

architecture behavior of arctans is

	type array_of_signed is array(0 to 31) of signed(20 downto 0);
	constant table: array_of_signed := (
        0  => to_signed(51471, 21),
        1  => to_signed(30385, 21),
        2  => to_signed(16054, 21),
        3  => to_signed(8149,  21),
        4  => to_signed(4090,  21),
        5  => to_signed(2047,  21),
        6  => to_signed(1023,  21),
        7  => to_signed(511,   21),
        8  => to_signed(255,   21),
        9  => to_signed(127,   21),
        10 => to_signed(63,    21),
        11 => to_signed(31,    21),
        12 => to_signed(15,    21),
        13 => to_signed(7,     21),
        14 => to_signed(3,     21),
        15 => to_signed(1,     21),
        others => to_signed(0, 21)
	);

begin

	o <= table(to_integer(address));

end architecture;
