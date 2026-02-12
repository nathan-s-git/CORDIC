library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comp_unsigned is
    port(
        a: in  unsigned(4 downto 0);
		b: in  unsigned(4 downto 0);
    	status: out std_logic
    );
end entity;

architecture behavior of comp_unsigned is
begin

	status <= '0' when a < b else '1';

end architecture;
