library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic is
	port(
		-- in
		mode, start, reset, clock: in std_logic;
		x_in, y_in: in std_logic_vector(8 downto 0);
		z_in: in std_logic_vector(19 downto 0);
		-- out
		done: out std_logic;
		x_out, y_out, z_out: out std_logic_vector(20 downto 0)
	);
end cordic;

architecture behavior of cordic is

	signal enable_in_regs: std_logic;
	signal enable_out_regs: std_logic;
	signal enable_x_calc_reg: std_logic;
	signal enable_yz_calc_regs: std_logic;
	signal enable_count: std_logic;
	signal sel_xyzin_set_rotate_or_vector: std_logic;
	signal sel_xcalc_set_in_or_iter_or_m: std_logic_vector(1 downto 0);
	signal sel_yzcalc_set_in_or_iter: std_logic;
	signal sel_comp_y_or_z: std_logic;
	signal reset_i: std_logic;
	signal alu_op: std_logic;
	signal i_comp: std_logic;
	signal zero_comp: std_logic;

	signal x_out_temp: signed(20 downto 0);
	signal y_out_temp: signed(20 downto 0);
	signal z_out_temp: signed(20 downto 0);

begin

	datapath: entity work.datapath
	port map(
		-- in --------------------------------------------------
		x_in => signed(x_in),
		y_in => signed(y_in),
		z_in => signed(z_in),

		enable_in_regs => enable_in_regs,
		enable_out_regs => enable_out_regs,
		enable_x_calc_reg => enable_x_calc_reg,
		enable_yz_calc_regs => enable_yz_calc_regs,
		enable_count => enable_count,
		sel_xyzin_set_rotate_or_vector => sel_xyzin_set_rotate_or_vector,
		sel_xcalc_set_in_or_iter_or_m => sel_xcalc_set_in_or_iter_or_m,
		sel_yzcalc_set_in_or_iter => sel_yzcalc_set_in_or_iter,
		sel_comp_y_or_z => sel_comp_y_or_z,
		reset_i => reset_i,
		alu_op => alu_op,

		clock => clock,
		-- out -------------------------------------------------
		x_out => x_out_temp,
		y_out => y_out_temp,
		z_out => z_out_temp,

		i_comp => i_comp,
		zero_comp => zero_comp
		--------------------------------------------------------
	);

	x_out <= std_logic_vector(x_out_temp);
	y_out <= std_logic_vector(y_out_temp);
	z_out <= std_logic_vector(z_out_temp);

	control: entity work.control
	port map(
		-- in --------------------------------------------------
		mode => mode,
		start => start,
		reset => reset,

		i_comp => i_comp,
		zero_comp => zero_comp,

		clock => clock,
		-- out -------------------------------------------------
		enable_in_regs => enable_in_regs,
		enable_out_regs => enable_out_regs,
		enable_x_calc_reg => enable_x_calc_reg,
		enable_yz_calc_regs => enable_yz_calc_regs,
		enable_count => enable_count,
		sel_xyzin_set_rotate_or_vector => sel_xyzin_set_rotate_or_vector,
		sel_xcalc_set_in_or_iter_or_m => sel_xcalc_set_in_or_iter_or_m,
		sel_yzcalc_set_in_or_iter => sel_yzcalc_set_in_or_iter,
		sel_comp_y_or_z => sel_comp_y_or_z,
		reset_i => reset_i,
		alu_op => alu_op,

		done => done
		--------------------------------------------------------
	);

end;
