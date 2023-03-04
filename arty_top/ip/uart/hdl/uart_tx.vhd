library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
   port (
      clk                  : in    std_logic;
      reset_n              : in    std_logic;
      ticks                : in    std_logic_vector(15 downto 0);
      sout                 : out   std_logic;
      send                 : in    std_logic;
      rdy                  : out   std_logic;
      din                  : in    std_logic_vector(7 downto 0)
   );
end uart_tx;

architecture rtl of uart_tx is

--
-- TYPES
--
type   tx_state_t is (IDLE, TX_DAT, TX_NEXT);

type  TX_SV_t is record
   state       : tx_state_t;
   dat         : std_logic_vector(9 downto 0);
   bit_cnt     : integer range 0 to 10;
   ticks       : unsigned(15 downto 0);
   send        : std_logic;
   busy        : std_logic;
   sout        : std_logic;
end record TX_SV_t;

--
-- CONSTANTS
--

-- TX State Vector Initialization
constant C_TX_SV_INIT : TX_SV_t := (
   state       => IDLE,
   dat         => (others => '0'),
   bit_cnt     => 0,
   ticks       => (others => '0'),
   send        => '0',
   busy        => '0',
   sout        => '1'
);

--
-- SIGNAL DECLARATIONS
--
--TX State Vector
signal tx               : TX_SV_t;

--
-- MAIN CODE
--
begin

   --
   -- COMBINATORIAL OUTPUTS
   --
   sout     <= tx.sout;
   rdy      <= not (tx.busy or send);

   --
   --  SERIAL TRANSMIT FSM
   --
   process(all) begin
      if (reset_n = '0') then

         -- Init the State Vector
         tx             <= C_TX_SV_INIT;

      elsif (rising_edge(clk)) then

         tx.send        <= send;

         case tx.state is
            --
            -- WAIT FOR DATA WRITE
            --
            when IDLE =>
               --
               -- Wait for Data Write
               --
               if (send = '1' and tx.send = '0') then
                  tx.state    <= TX_DAT;
                  -- serial bit period in units of clks
                  tx.ticks    <= unsigned(ticks);
                  tx.busy     <= '1';
                  -- start + symbol + stop, LSB first
                  tx.dat      <= '1' & din & '0';
                  tx.bit_cnt  <= 0;
               else
                  tx.state    <= IDLE;
                  tx.busy     <= '0';
                  tx.sout     <= '1';
               end if;

            --
            -- Assert Serial Bit for tx.ticks Period
            --
            when TX_DAT =>
               if (tx.ticks = 0) then
                  tx.state    <= TX_NEXT;
                  tx.ticks    <= unsigned(ticks);
                  -- next serial bit
                  tx.dat      <= '1' & tx.dat(9 downto 1);
                  tx.bit_cnt  <= tx.bit_cnt + 1;
               else
                  tx.state    <= TX_DAT;
                  tx.ticks    <= tx.ticks - 1;
                  tx.sout     <= tx.dat(0);
               end if;

            --
            -- 10-Bits per Symbol
            --
            when TX_NEXT =>
               if (tx.bit_cnt = 10) then
                  tx.state    <= IDLE;
                  tx.bit_cnt  <= 0;
               else
                  tx.state    <= TX_DAT;
               end if;

            when others =>
               tx.state       <= IDLE;

         end case;

      end if;
   end process;

end rtl;
