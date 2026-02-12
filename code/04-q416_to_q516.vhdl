library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity q416_to_q516 is
    port(
        a: in  signed(19 downto 0);
        o: out signed(20 downto 0)
    );
end entity;

architecture behavior of q416_to_q516 is
begin

	o <= resize(a,21);

end architecture;
