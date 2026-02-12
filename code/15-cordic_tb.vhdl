library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity cordic_tb is
end cordic_tb;

architecture sim of cordic_tb is

    -- input
    signal x_in   : std_logic_vector(8 downto 0) := (others => '0');
    signal y_in   : std_logic_vector(8 downto 0) := (others => '0');
    signal z_in   : std_logic_vector(19 downto 0) := (others => '0');
    signal start  : std_logic := '0';
    signal mode   : std_logic := '0';
    signal reset  : std_logic := '0';
    signal clock  : std_logic := '0';

    -- output
    signal x_out  : std_logic_vector(20 downto 0);
    signal y_out  : std_logic_vector(20 downto 0);
    signal z_out  : std_logic_vector(20 downto 0);
    signal done   : std_logic;

begin

    dut: entity work.cordic
    port map(
        mode => mode,
        start => start,
		reset => reset,
        clock => clock,
        x_in => x_in,
        y_in => y_in,
        z_in => z_in,
        done => done,
        x_out => x_out,
        y_out => y_out,
        z_out => z_out
    );

    -- clock: 10 ns
    clock <= not clock after 5 ns;

    -- stimuli
    stim: process
    begin

		-- reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
		wait for 10 ns;

		-- rotation (mode=0)
		mode <= '0';
		wait for 20 ns;
		x_in <= std_logic_vector(to_signed(0, 9));
		y_in <= std_logic_vector(to_signed(0, 9));
		z_in <= std_logic_vector(to_signed(51472, 20));
		start <= '1';
		wait for 10 ns;
		start <= '0';
		wait until done = '1';
		wait for 20 ns;

		-- vectorization (mode=1)
		mode <= '1';
		wait for 20 ns;
		x_in <= std_logic_vector(to_signed(96, 9));
		y_in <= std_logic_vector(to_signed(128, 9));
		z_in <= std_logic_vector(to_signed(0, 20));
		start <= '1';
		wait for 10 ns;
		start <= '0';
		wait until done = '1';
		wait for 20 ns;

		finish;

    end process;

end architecture sim;
