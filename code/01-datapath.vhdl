library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	port(
		-- 1) IN
		-- 1.1) data
		x_in, y_in: in signed(8 downto 0);
		z_in: in signed(19 downto 0);
		-- 1.2) signals
		enable_in_regs: in std_logic;
		enable_out_regs: in std_logic;
		enable_x_calc_reg: in std_logic;
		enable_yz_calc_regs: in std_logic;
		enable_count: in std_logic;
		sel_xyzin_set_rotate_or_vector: in std_logic;
		sel_xcalc_set_in_or_iter_or_m: in std_logic_vector(1 downto 0);
		sel_yzcalc_set_in_or_iter: in std_logic;
		sel_comp_y_or_z: in std_logic;
		reset_i: in std_logic;
		alu_op: in std_logic;
		-- 1.3) clock
		clock: in std_logic;
		-- 2) OUT
		-- 2.1) data
		x_out, y_out, z_out: out signed(20 downto 0);
		-- 2.2) signals
		i_comp, zero_comp: out std_logic
	);
end datapath;

architecture behavior of datapath is

	signal i: unsigned(4 downto 0);

	signal q45_to_q516_x_out: signed(20 downto 0);
	signal q45_to_q516_y_out: signed(20 downto 0);
	signal q416_to_q516_z_out: signed(20 downto 0);

	signal xgiven_reg_out: signed(20 downto 0);
	signal ygiven_reg_out: signed(20 downto 0);
	signal zgiven_reg_out: signed(20 downto 0);

	signal xcalc_reg_out: signed(20 downto 0);
	signal ycalc_reg_out: signed(20 downto 0);
	signal zcalc_reg_out: signed(20 downto 0);

	signal xout_reg_out: signed(20 downto 0);
	signal yout_reg_out: signed(20 downto 0);
	signal zout_reg_out: signed(20 downto 0);

	signal sum_or_sub_1st_out: signed(20 downto 0);
	signal sum_or_sub_2nd_out: signed(20 downto 0);
	signal sum_or_sub_3rd_out: signed(20 downto 0);

	signal sum_out: signed(20 downto 0);

	signal x_shifted: signed(20 downto 0);
	signal y_shifted: signed(20 downto 0);

	signal atan: signed(20 downto 0);

	signal xcalc_shift_1: signed(20 downto 0);
	signal xcalc_shift_3: signed(20 downto 0);
	signal xcalc_shift_6: signed(20 downto 0);
	signal xcalc_shift_9: signed(20 downto 0);
	signal xcalc_shift_12: signed(20 downto 0);

	signal mux_for_xgiven_out: signed(20 downto 0);
	signal mux_for_ygiven_out: signed(20 downto 0);
	signal mux_for_zgiven_out: signed(20 downto 0);

	signal mux_for_xcalc_out: signed(20 downto 0);
	signal mux_for_ycalc_out: signed(20 downto 0);
	signal mux_for_zcalc_out: signed(20 downto 0);

	signal mux_for_1st_sum_or_sub_arg1_out: signed(20 downto 0);
	signal mux_for_1st_sum_or_sub_arg2_out: signed(20 downto 0);
	signal mux_for_2nd_sum_or_sub_arg1_out: signed(20 downto 0);
	signal mux_for_2nd_sum_or_sub_arg2_out: signed(20 downto 0);
	signal mux_for_3rd_sum_or_sub_arg1_out: signed(20 downto 0);
	signal mux_for_3rd_sum_or_sub_arg2_out: signed(20 downto 0);

	signal mux_for_y_or_z_comp_in: signed(20 downto 0);

begin

	-- muxes
	mux_for_xgiven: entity work.mux_2x1
	port map(
		zero => to_signed(39797,21),
		one => q45_to_q516_x_out,
		o => mux_for_xgiven_out,
		sel => sel_xyzin_set_rotate_or_vector
	);
	mux_for_ygiven: entity work.mux_2x1
	port map(
		zero => to_signed(0,21),
		one => q45_to_q516_y_out,
		o => mux_for_ygiven_out,
		sel => sel_xyzin_set_rotate_or_vector
	);
	mux_for_zgiven: entity work.mux_2x1
	port map(
		zero => q416_to_q516_z_out ,
		one => to_signed(0,21),
		o => mux_for_zgiven_out,
		sel => sel_xyzin_set_rotate_or_vector
	);
	mux_for_xcalc: entity work.mux_3x1
	port map(
		zero => xgiven_reg_out,
		one => sum_or_sub_1st_out,
		two => sum_or_sub_2nd_out,
		o => mux_for_xcalc_out,
		sel => sel_xcalc_set_in_or_iter_or_m
	);
	mux_for_ycalc: entity work.mux_2x1
	port map(
		zero => ygiven_reg_out,
		one => sum_or_sub_2nd_out,
		o => mux_for_ycalc_out,
		sel => sel_yzcalc_set_in_or_iter
	);
	mux_for_zcalc: entity work.mux_2x1
	port map(
		zero => zgiven_reg_out,
		one => sum_or_sub_3rd_out,
		o => mux_for_zcalc_out,
		sel => sel_yzcalc_set_in_or_iter
	);
	mux_for_y_or_z_comp: entity work.mux_2x1
	port map(
		zero => ycalc_reg_out,
		one => zcalc_reg_out,
		o => mux_for_y_or_z_comp_in,
		sel => sel_comp_y_or_z
	);
	mux_for_1st_sum_or_sub_arg1: entity work.mux_2x1
	port map(
		zero => xcalc_reg_out,
		one => xcalc_shift_1,
		o => mux_for_1st_sum_or_sub_arg1_out,
		sel => sel_xcalc_set_in_or_iter_or_m(1) -- select to calc for the main iteration or to calc m
	);
	mux_for_1st_sum_or_sub_arg2: entity work.mux_2x1
	port map(
		zero => y_shifted,
		one => xcalc_shift_3,
		o => mux_for_1st_sum_or_sub_arg2_out,
		sel => sel_xcalc_set_in_or_iter_or_m(1) -- select to calc for the main iteration or to calc m
	);
	mux_for_2nd_sum_or_sub_arg1: entity work.mux_2x1
	port map(
		zero => ycalc_reg_out,
		one => sum_or_sub_1st_out,
		o => mux_for_2nd_sum_or_sub_arg1_out,
		sel => sel_xcalc_set_in_or_iter_or_m(1) -- select to calc for the main iteration or to calc m
	);
	mux_for_2nd_sum_or_sub_arg2: entity work.mux_2x1
	port map(
		zero => x_shifted,
		one => sum_out,
		o => mux_for_2nd_sum_or_sub_arg2_out,
		sel => sel_xcalc_set_in_or_iter_or_m(1) -- select to calc for the main iteration or to calc m
	);
	mux_for_3rd_sum_or_sub_arg1: entity work.mux_2x1
	port map(
		zero => zcalc_reg_out,
		one => xcalc_shift_6,
		o => mux_for_3rd_sum_or_sub_arg1_out,
		sel => sel_xcalc_set_in_or_iter_or_m(1) -- select to calc for the main iteration or to calc m
	);
	mux_for_3rd_sum_or_sub_arg2: entity work.mux_2x1
	port map(
		zero => atan,
		one => xcalc_shift_9,
		o => mux_for_3rd_sum_or_sub_arg2_out,
		sel => sel_xcalc_set_in_or_iter_or_m(1) -- select to calc for the main iteration or to calc m
	);


	-- to expand chosen x,y,z
	q45_to_q516_x: entity work.q45_to_q516
	port map(
		a => x_in,
		o => q45_to_q516_x_out
	);
	q45_to_q516_y: entity work.q45_to_q516
	port map(
		a => y_in,
		o => q45_to_q516_y_out
	);
	q416_to_q516_z: entity work.q416_to_q516
	port map(
		a => z_in,
		o => q416_to_q516_z_out
	);


	-- sum_or_sub(s)
	sum_or_sub_1st: entity work.sum_or_sub
	port map(
		a => mux_for_1st_sum_or_sub_arg1_out,
		b => mux_for_1st_sum_or_sub_arg2_out,
		o => sum_or_sub_1st_out,
		op => alu_op
	);
	sum_or_sub_2nd: entity work.sum_or_sub
	port map(
		a => mux_for_2nd_sum_or_sub_arg1_out,
		b => mux_for_2nd_sum_or_sub_arg2_out,
		o => sum_or_sub_2nd_out,
		op => not alu_op
	);
	sum_or_sub_3rd: entity work.sum_or_sub
	port map(
		a => mux_for_3rd_sum_or_sub_arg1_out,
		b => mux_for_3rd_sum_or_sub_arg2_out,
		o => sum_or_sub_3rd_out,
		op => alu_op
	);


	-- sum
	sum: entity work.sum
	port map(
		a => sum_or_sub_3rd_out,
		b => xcalc_shift_12,
		o => sum_out
	);


	-- arctan
	for_arctan: entity work.arctans
	port map(
		address => i,
		o => atan
	);


	-- shift for x,y
	to_shift_x: entity work.right_shift
	port map(
		a => xcalc_reg_out,
		n => i,
		o => x_shifted
	);
	to_shift_y: entity work.right_shift
	port map(
		a => ycalc_reg_out,
		n => i,
		o => y_shifted
	);


	-- predefined shifts
	xcalc_shift_1 <= shift_right(xcalc_reg_out, 1);
	xcalc_shift_3 <= shift_right(xcalc_reg_out, 3);
	xcalc_shift_6 <= shift_right(xcalc_reg_out, 6);
	xcalc_shift_9 <= shift_right(xcalc_reg_out, 9);
	xcalc_shift_12 <= shift_right(xcalc_reg_out, 12);

	-- comparisons
	comp_to_zero: entity work.comp_signed
	port map(
		a => mux_for_y_or_z_comp_in,
		b => (others=>'0'),
		status => zero_comp
	);
	comp_to_i: entity work.comp_unsigned
	port map(
		a => i,
		b => to_unsigned(16,5),
		status => i_comp
	);


	-- counting
	i_count: entity work.counter
	port map(
		enable => enable_count,
		reset => reset_i,
		clock => clock,
		o => i
	);


	-- registers
	xgiven_reg: entity work.reg
	port map(
		a => mux_for_xgiven_out,
		o => xgiven_reg_out,
		enable => enable_in_regs,
		clock => clock
	);
	ygiven_reg: entity work.reg
	port map(
		a => mux_for_ygiven_out,
		o => ygiven_reg_out,
		enable => enable_in_regs,
		clock => clock
	);
	zgiven_reg: entity work.reg
	port map(
		a => mux_for_zgiven_out,
		o => zgiven_reg_out,
		enable => enable_in_regs,
		clock => clock
	);
	xcalc_reg: entity work.reg
	port map(
		a => mux_for_xcalc_out,
		o => xcalc_reg_out,
		enable => enable_x_calc_reg,
		clock => clock
	);
	ycalc_reg: entity work.reg
	port map(
		a => mux_for_ycalc_out,
		o => ycalc_reg_out,
		enable => enable_yz_calc_regs,
		clock => clock
	);
	zcalc_reg: entity work.reg
	port map(
		a => mux_for_zcalc_out,
		o => zcalc_reg_out,
		enable => enable_yz_calc_regs,
		clock => clock
	);
	xout_reg: entity work.reg
	port map(
		a => xcalc_reg_out,
		o => xout_reg_out,
		enable => enable_out_regs,
		clock => clock
	);
	yout_reg: entity work.reg
	port map(
		a => ycalc_reg_out,
		o => yout_reg_out,
		enable => enable_out_regs,
		clock => clock
	);
	zout_reg: entity work.reg
	port map(
		a => zcalc_reg_out,
		o => zout_reg_out,
		enable => enable_out_regs,
		clock => clock
	);
end;
