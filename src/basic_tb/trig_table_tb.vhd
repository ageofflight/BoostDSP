--! @file trig_table_tb.vhd
--! @brief sin/cos lookup table generator testbench
--! @author Scott Teal (Scott@Teals.org)
--! @date 2013-11-2
--! @copyright
--! Copyright 2013 Richard Scott Teal, Jr.
--!
--! Licensed under the Apache License, Version 2.0 (the "License"); you may not
--! use this file except in compliance with the License. You may obtain a copy
--! of the License at
--!
--! http://www.apache.org/licenses/LICENSE-2.0
--!
--! Unless required by applicable law or agreed to in writing, software
--! distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
--! WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
--! License for the specific language governing permissions and limitations
--! under the License.

--! Standard IEEE library
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.fixed_float_types.all;

library boostdsp;
use boostdsp.fixed_pkg.all;
use boostdsp.util_pkg.all;
use boostdsp.basic_pkg;

--! Tests the boostdsp.trig_table entity.
--! @TODO Use sfixed_as_signed to get vis_sine & vis_cosine.
entity trig_table_tb is
end entity;

--! Tests the boostdsp.trig_table entity by running through all possible angle 
--! values.
architecture sim of trig_table_tb is

--! Half period of clock line
constant clk_hp : time := 1 ns;

signal clk    : std_logic := '0'; --! Clock for UUT
signal rst    : std_logic := '1'; --! Reset for UUT
signal angle  : ufixed(-1 downto -9) := to_ufixed(0.0, -1, -9); --! Input angle
signal sine   : sfixed(1 downto -6); --! Sine output
signal cosine : sfixed(1 downto -6); --! Cosine output

signal vis_sine : signed(7 downto 0); --! Visualize output in Modelsim
signal vis_cosine : signed(7 downto 0); --! Visualize output in Modelsim

constant angle_lsb : real := 2.0**(angle'low); --! LSB of angle counter

begin

  --! Trigometric Table Unit Under Test
  uut : basic_pkg.trig_table
  port map (
    clk    => clk,
    rst    => rst,
    angle  => angle,
    sine   => sine,
    cosine => cosine
  );

  --! Clock generator
  clk_proc : process
  begin
    wait for clk_hp;
    clk <= not clk;
  end process;

  --! Reset generator
  rst_proc : process
  begin
    wait for clk_hp * 4;
    rst <= '0';
    wait;
  end process;

  --! Incremeting angle through entire range
  test_input : process
  begin
    wait for clk_hp * 2;
    angle <= resize(angle + to_ufixed(angle_lsb,angle), angle'high, angle'low,
             fixed_wrap, fixed_truncate);
  end process;

  --! Visualize sine output
  vis_sine <= sfixed_as_signed(sine);
  --! Visualize cosine output
  vis_cosine <= sfixed_as_signed(cosine);

end sim;
