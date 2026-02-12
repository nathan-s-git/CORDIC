library ieee;
use ieee.std_logic_1164.all;

entity control is
	port(
		-- 1) IN
		-- 1.1) data
		mode, start, reset: in std_logic;
		-- 1.2) signals
		i_comp, zero_comp: in std_logic;
		-- 1.3) clock
		clock: in std_logic;
		-- 2) OUT
		-- 2.1) data
		done: out std_logic;
		-- 2.2) signals
		enable_in_regs: out std_logic;
		enable_out_regs: out std_logic;
		enable_x_calc_reg: out std_logic;
		enable_yz_calc_regs: out std_logic;
		enable_count: out std_logic;
		sel_xyzin_set_rotate_or_vector: out std_logic;
		sel_xcalc_set_in_or_iter_or_m: out std_logic_vector(1 downto 0);
		sel_yzcalc_set_in_or_iter: out std_logic;
		sel_comp_y_or_z: out std_logic;
		reset_i: out std_logic;
		alu_op: out std_logic
	);
end control;

architecture behavior of control is

	type state is (
		idle_v,idle_r,
		init,
		check_v, check_r,
		iter_1_v, iter_2_v,
		iter_1_r, iter_2_r,
		adjust_x,
		ends
	);
	signal current_state, next_state: state;

begin

	state_register: process(clock)
    begin
		if reset = '1' then
			current_state <= idle_v;
        elsif rising_edge(clock) then
            current_state <= next_state;
        end if;
    end process state_register;


	next_state_handler: process(all)
	begin
		case current_state is

			when idle_v =>
				if start = '0' then
					if mode = '0' then
						next_state <= idle_r;
					else
						next_state <= idle_v;
					end if;
				else
					next_state <= init;
				end if;

			when idle_r =>
				if start = '0' then
					if mode = '0' then
						next_state <= idle_r;
					else
						next_state <= idle_v;
					end if;
				else
					next_state <= init;
				end if;

			when init =>
				if mode = '0' then
					next_state <= check_r;
				else
					next_state <= check_v;
				end if;

			when check_v =>
				if i_comp = '0' then
					if zero_comp = '0' then
						next_state <= iter_1_v;
					else
						next_state <= iter_2_v;
					end if;
				else
					next_state <= adjust_x;
				end if;

			when check_r =>
				if i_comp = '0' then
					if zero_comp = '0' then
						next_state <= iter_1_r;
					else
						next_state <= iter_2_r;
					end if;
				else
					next_state <= ends;
				end if;

			when iter_1_v =>
				next_state <= check_v;

			when iter_2_v =>
				next_state <= check_v;

			when iter_1_r =>
				next_state <= check_r;

			when iter_2_r =>
				next_state <= check_r;

			when adjust_x =>
				next_state <= ends;

			when ends =>
				if mode = '0' then
					next_state <= idle_r;
				else
					next_state <= idle_v;
				end if;

		end case;
	end process next_state_handler;

	output_assignment: process(current_state)
	begin
		case current_state is

			when idle_v =>
				enable_in_regs <= '1';
				enable_out_regs <= '0';
				enable_x_calc_reg <= '0';
				enable_yz_calc_regs <= '0';
				enable_count <= '0';
				sel_xyzin_set_rotate_or_vector <= '1';
				sel_xcalc_set_in_or_iter_or_m <= (others => '-'); --
				sel_yzcalc_set_in_or_iter <= '-'; --
				sel_comp_y_or_z <= '-'; --
				reset_i <= '1';
				alu_op <= '-'; --
				done <= '0';

			when idle_r =>
				enable_in_regs <= '1';
				enable_out_regs <= '0';
				enable_x_calc_reg <= '0';
				enable_yz_calc_regs <= '0';
				enable_count <= '0';
				sel_xyzin_set_rotate_or_vector <= '0';
				sel_xcalc_set_in_or_iter_or_m <= (others => '-'); --
				sel_yzcalc_set_in_or_iter <= '-'; --
				sel_comp_y_or_z <= '-'; --
				reset_i <= '1';
				alu_op <= '-'; --
				done <= '0';

			when init =>
				enable_in_regs <= '0';
				enable_out_regs <= '0';
				enable_x_calc_reg <= '1';
				enable_yz_calc_regs <= '1';
				enable_count <= '0';
				sel_xyzin_set_rotate_or_vector <= '-'; --
				sel_xcalc_set_in_or_iter_or_m <= "00";
				sel_yzcalc_set_in_or_iter <= '0';
				sel_comp_y_or_z <= '-'; --
				reset_i <= '-'; --
				alu_op <= '-'; --
				done <= '0';

			when check_v =>
				enable_in_regs <= '0';
				enable_out_regs <= '0';
				enable_x_calc_reg <= '0';
				enable_yz_calc_regs <= '0';
				enable_count <= '0';
				sel_xyzin_set_rotate_or_vector <= '-'; --
				sel_xcalc_set_in_or_iter_or_m <= (others => '-'); --
				sel_yzcalc_set_in_or_iter <= '-'; --
				sel_comp_y_or_z <= '0';
				reset_i <= '0';
				alu_op <= '-'; --
				done <= '0';

			when check_r =>
				enable_in_regs <= '0';
				enable_out_regs <= '0';
				enable_x_calc_reg <= '0';
				enable_yz_calc_regs <= '0';
				enable_count <= '0';
				sel_xyzin_set_rotate_or_vector <= '-'; --
				sel_xcalc_set_in_or_iter_or_m <= (others => '-'); --
				sel_yzcalc_set_in_or_iter <= '-'; --
				sel_comp_y_or_z <= '1';
				reset_i <= '0';
				alu_op <= '-'; --
				done <= '0';

			when iter_1_v =>
				enable_in_regs <= '0';
				enable_out_regs <= '0';
				enable_x_calc_reg <= '1';
				enable_yz_calc_regs <= '1';
				enable_count <= '1';
				sel_xyzin_set_rotate_or_vector <= '-'; --
				sel_xcalc_set_in_or_iter_or_m <= "01";
				sel_yzcalc_set_in_or_iter <= '1';
				sel_comp_y_or_z <= '-'; --
				reset_i <= '0';
				alu_op <= '0';
				done <= '0';

			when iter_1_r =>
				enable_in_regs <= '0';
				enable_out_regs <= '0';
				enable_x_calc_reg <= '1';
				enable_yz_calc_regs <= '1';
				enable_count <= '1';
				sel_xyzin_set_rotate_or_vector <= '-'; --
				sel_xcalc_set_in_or_iter_or_m <= "01";
				sel_yzcalc_set_in_or_iter <= '1';
				sel_comp_y_or_z <= '-'; --
				reset_i <= '0';
				alu_op <= '1';
				done <= '0';

			when iter_2_v =>
				enable_in_regs <= '0';
				enable_out_regs <= '0';
				enable_x_calc_reg <= '1';
				enable_yz_calc_regs <= '1';
				enable_count <= '1';
				sel_xyzin_set_rotate_or_vector <= '-'; --
				sel_xcalc_set_in_or_iter_or_m <= "01";
				sel_yzcalc_set_in_or_iter <= '1';
				sel_comp_y_or_z <= '-'; --
				reset_i <= '0';
				alu_op <= '1';
				done <= '0';

			when iter_2_r =>
				enable_in_regs <= '0';
				enable_out_regs <= '0';
				enable_x_calc_reg <= '1';
				enable_yz_calc_regs <= '1';
				enable_count <= '1';
				sel_xyzin_set_rotate_or_vector <= '-'; --
				sel_xcalc_set_in_or_iter_or_m <= "01";
				sel_yzcalc_set_in_or_iter <= '1';
				sel_comp_y_or_z <= '-'; --
				reset_i <= '0';
				alu_op <= '0';
				done <= '0';

			when adjust_x =>
				enable_in_regs <= '0';
				enable_out_regs <= '0';
				enable_x_calc_reg <= '1';
				enable_yz_calc_regs <= '0';
				enable_count <= '-'; --
				sel_xyzin_set_rotate_or_vector <= '-'; --
				sel_xcalc_set_in_or_iter_or_m <= "10";
				sel_yzcalc_set_in_or_iter <= '-'; --
				sel_comp_y_or_z <= '-'; --
				reset_i <= '-'; --
				alu_op <= '1';
				done <= '0';

			when ends =>
				enable_in_regs <= '0';
				enable_out_regs <= '1';
				enable_x_calc_reg <= '0';
				enable_yz_calc_regs <= '0';
				enable_count <= '0';
				sel_xyzin_set_rotate_or_vector <= '-'; --
				sel_xcalc_set_in_or_iter_or_m <= (others => '-'); --
				sel_yzcalc_set_in_or_iter <= '-'; --
				sel_comp_y_or_z <= '-'; --
				reset_i <= '1';
				alu_op <= '-'; --
				done <= '1';

		end case;
	end process output_assignment;

end;
