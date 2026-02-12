library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity q45_to_q516 is
    port(
        a: in  signed(8 downto 0);
        o: out signed(20 downto 0)
    );
end entity;

architecture behavior of q45_to_q516 is
begin

	o <= shift_left( resize(a,21), 11 );

end architecture;
