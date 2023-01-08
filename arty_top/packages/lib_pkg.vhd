library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package lib_pkg is

   --
   -- CONSTANTS, BASED ON 100MHZ FPGA CLOCK
   --
   constant C_CNTR_10MHZ      : unsigned(31 downto 0) := X"00000009";
   constant C_CNTR_1MHZ       : unsigned(31 downto 0) := X"00000063";
   constant C_CNTR_1KHZ       : unsigned(31 downto 0) := X"0001869F";

   constant C_SYNC_200US      : unsigned(31 downto 0) := X"00004E1F";
   constant C_SYNC_100MS      : unsigned(31 downto 0) := X"0098967F";

end lib_pkg;
