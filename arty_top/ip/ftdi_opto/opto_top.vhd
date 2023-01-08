---------------------------------CONFIDENTIAL-----------------------------------
--
-- File name    : opto_top.vhd
-- Title        : FTDI (OPTO) Fast Serial Interface w/ Head & Tail
-- Designer     : A.E. LaBarge
-- Created On   : 21.APR.2020
--
-- -----------------------------------------------------------------------------
--
-- Copyright (c) 2020 Omniware
-- 3830 Valley Centre Dr. Suite 705-361
-- San Diego, CA  92130
-- www.omniware.us
--
-- -----------------------------------------------------------------------------
-- Revision History:
--   03/12/20   [ael] Genesis
--
--------------------------------------------------------------------------------
--
-- Description :     Top Level Entity file for the Avalon-MM Packet based
--                   FTDI (OPTO) Fast Serial Inteface w/ Head & Tail
--
---------------------------------CONFIDENTIAL-----------------------------------
--
--=======1=========2=========3=========4=========5=========6=========7=========8

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity opto_top is
   port (
      -- Avalon Memory-Mapped Slave
      clk                  : in    std_logic;
      reset_n              : in    std_logic;
      read_n               : in    std_logic;
      write_n              : in    std_logic;
      address              : in    std_logic_vector(11 downto 0);
      readdata             : out   std_logic_vector(31 downto 0);
      writedata            : in    std_logic_vector(31 downto 0);
      irq                  : out   std_logic;
      -- Avalon Memory-Mapped Read Master
      m1_read              : out   std_logic;
      m1_rd_address        : out   std_logic_vector(31 downto 0);
      m1_readdata          : in    std_logic_vector(31 downto 0);
      m1_rd_waitreq        : in    std_logic;
      m1_rd_burstcount     : out   std_logic_vector(15 downto 0);
      m1_rd_datavalid      : in    std_logic;
      -- Memory Head-Tail Pointers
      head_addr            : in    std_logic_vector(15 downto 0);
      tail_addr            : out   std_logic_vector(15 downto 0);
      -- Exported Signals
      fsclk                : out   std_logic;
      fscts                : in    std_logic;
      fsdo                 : in    std_logic;
      fsdi                 : out   std_logic;
      test_bit             : out   std_logic;
      debug                : out   std_logic_vector(3 downto 0)
   );
end entity opto_top;

architecture rtl of opto_top is

--
-- MAIN CODE
--
begin

   OPTO_CORE_I : entity work.opto_core
      generic map (
         C_DWIDTH          => 32,
         C_NUM_REG         => 16
      )
      port map (
         clk               => clk,
         reset_n           => reset_n,
         read_n            => read_n,
         write_n           => write_n,
         address           => address,
         readdata          => readdata,
         writedata         => writedata,
         irq               => irq,
         m1_read           => m1_read,
         m1_rd_address     => m1_rd_address,
         m1_readdata       => m1_readdata,
         m1_rd_waitreq     => m1_rd_waitreq,
         m1_rd_burstcount  => m1_rd_burstcount,
         m1_rd_datavalid   => m1_rd_datavalid,
         head_addr         => head_addr,
         tail_addr         => tail_addr,
         fsclk             => fsclk,
         fscts             => fscts,
         fsdo              => fsdo,
         fsdi              => fsdi,
         test_bit          => test_bit,
         debug             => debug
      );

end rtl;

