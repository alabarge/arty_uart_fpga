library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_ctl is
   port (
      clk                  : in    std_logic;
      reset_n              : in    std_logic;
      int                  : out   std_logic_vector(2 downto 0);
      cpu_RXD              : out   std_logic_vector(31 downto 0);
      cpu_TXD              : in    std_logic_vector(31 downto 0);
      cpu_ADDR             : in    std_logic_vector(6 downto 0);
      cpu_WE               : in    std_logic;
      cpu_RE               : in    std_logic;
      uart_CONTROL         : in    std_logic_vector(31 downto 0);
      uart_TICKS           : in    std_logic_vector(15 downto 0);
      uart_STATUS          : out   std_logic_vector(31 downto 0);
      rxd                  : in    std_logic;
      txd                  : out   std_logic
   );
end uart_ctl;

architecture rtl of uart_ctl is

--
-- TYPES
--
type tx_state_t    is (IDLE, TX_OCTET, TX_IRQ);
type rx_state_t    is (IDLE, RX_OCTET);

type  TX_SV_t is record
   state       : tx_state_t;
   data        : std_logic_vector(7 downto 0);
   head        : unsigned(8 downto 0);
   tail        : unsigned(8 downto 0);
   irq         : std_logic;
   wr          : std_logic;
end record TX_SV_t;

type  RX_SV_t is record
   state       : rx_state_t;
   data        : std_logic_vector(7 downto 0);
   head        : unsigned(8 downto 0);
   tail        : unsigned(8 downto 0);
   timeout     : unsigned(7 downto 0);
   msg         : std_logic;
   irq         : std_logic;
   wr          : std_logic;
   rd          : std_logic;
end record RX_SV_t;

--
-- CONSTANTS
--

constant C_CNTR_1KHZ    : unsigned(31 downto 0) := X"0001869F";

-- TX State Vector Initialization
constant C_TX_SV_INIT : TX_SV_t := (
   state       => IDLE,
   data        => (others => '0'),
   head        => (others => '0'),
   tail        => (others => '0'),
   irq         => '0',
   wr          => '0'
);

-- RX State Vector Initialization
constant C_RX_SV_INIT : RX_SV_t := (
   state       => IDLE,
   data        => (others => '0'),
   head        => (others => '0'),
   tail        => (others => '0'),
   timeout     => (others => '0'),
   msg         => '0',
   irq         => '0',
   wr          => '0',
   rd          => '0'
);

--
-- SIGNAL DECLARATIONS
--

-- State Machine Data Types
signal tx               : TX_SV_t;
signal rx               : RX_SV_t;

-- 32-Bit State Machine Status
alias  xl_TX_TAIL       : std_logic_vector(8 downto 0) is uart_STATUS(8 downto 0);
alias  xl_RX_HEAD       : std_logic_vector(8 downto 0) is uart_STATUS(17 downto 9);


-- 32-Bit Control Register
alias  xl_TX_HEAD       : std_logic_vector(8 downto 0) is uart_CONTROL(8 downto 0);
alias  xl_RX_TAIL       : std_logic_vector(8 downto 0) is uart_CONTROL(17 downto 9);
alias  xl_TIMEOUT       : std_logic_vector(7 downto 0) is uart_CONTROL(25 downto 18);
alias  xl_RX_INT        : std_logic is uart_CONTROL(27);
alias  xl_TX_INT        : std_logic is uart_CONTROL(28);
alias  xl_TERM          : std_logic is uart_CONTROL(29);
alias  xl_TX_EN         : std_logic is uart_CONTROL(30);
alias  xl_ENABLE        : std_logic is uart_CONTROL(31);

signal ctr1ms_cnt       : unsigned(31 downto 0);
signal ctr1ms           : std_logic;

signal tx_data          : std_logic_vector(7 downto 0);
signal tx_addr          : std_logic_vector(8 downto 0);
signal tx_rdy           : std_logic;
signal rx_data          : std_logic_vector(7 downto 0);
signal rx_addr          : std_logic_vector(8 downto 0);
signal rx_rdy           : std_logic;

--
-- MAIN CODE
--
begin

   --
   -- COMBINATORIAL OUTPUTS
   --
   int(0)               <= tx.irq and xl_TX_INT;
   int(1)               <= rx.irq and xl_RX_INT;
   int(2)               <= '0';

   xl_TX_TAIL           <= std_logic_vector(tx.tail);
   xl_RX_HEAD           <= std_logic_vector(rx.head);

   uart_STATUS(29 downto 18) <= (others => '0');
   uart_STATUS(30)      <= tx_rdy;
   uart_STATUS(31)      <= xl_ENABLE;

   --
   --   THIS BRAM IS USED FOR TX ONLY
   --
   --   PORT A 128x32 CPU SIDE,  WRITE
   --   PORT B 512x8  UART SIDE, READ
   --
   UART_TX_RAM : entity work.uart_tx_ram
      port map (
      clka           => clk,
      addra          => "000" & tx_addr,
      dina           => cpu_TXD,
      wea(0)         => cpu_WE,
      douta          => tx_data
   );

   tx_addr           <= ("00" & cpu_ADDR) when cpu_WE = '1' else std_logic_vector(tx.tail);

   --
   --   UART TX
   --
   UART_TX_I: entity work.uart_tx
   port map (
      clk            => clk,
      reset_n        => reset_n and xl_ENABLE,
      ticks          => uart_TICKS,
      sout           => txd,
      send           => tx.wr,
      rdy            => tx_rdy,
      din            => tx.data
   );

   --
   --  TX STATE MACHINE
   --
   process(all) begin
      if (reset_n = '0' or xl_ENABLE = '0') then

         -- Init the State Vector
         tx             <= C_TX_SV_INIT;

      elsif (rising_edge(clk)) then

         tx.head        <= unsigned(xl_TX_HEAD);

         case tx.state is

            --
            -- WAIT FOR TRANSMIT REQUEST
            --
            when IDLE =>
               -- head not equal to tail then transmit
               if (tx.head /= tx.tail and tx_rdy = '1') then
                  tx.state    <= TX_OCTET;
                  tx.wr       <= '1';
                  tx.data     <= tx_data;
                  tx.tail     <= tx.tail + 1;
               else
                  tx.state    <= IDLE;
                  tx.irq      <= '0';
               end if;

            --
            -- NEXT POSITION IN QUEUE
            --
            when TX_OCTET =>
               if (tx_rdy = '1') then
                  tx.state    <= TX_IRQ;
                  tx.wr       <= '0';
               else
                  tx.state    <= TX_OCTET;
                  tx.wr       <= '0';
               end if;

            --
            -- TRANSMITTER EMPTY IRQ
            --
            when TX_IRQ =>
               if (tx.head = tx.tail) then
                  tx.state    <= IDLE;
                  tx.irq      <= '1';
               else
                  tx.state    <= IDLE;
               end if;

            when others =>
               tx.state       <= IDLE;

         end case;

      end if;
   end process;

   --
   --   THIS BRAM IS USED FOR RX ONLY
   --
   --   PORT A 512x8 UART SIDE,  WRITE
   --   PORT B 64x8  CPU SIDE,   READ
   --
   UART_RX_RAM : entity work.uart_rx_ram
      port map (
      clka           => clk,
      ena            => '1',
      addra          => "000" & rx_addr,
      dina           => rx.data,
      wea(0)         => rx.wr,
      douta          => cpu_RXD
   );

   rx_addr           <= ("00" & cpu_ADDR) when cpu_RE = '1' else std_logic_vector(rx.head);

   --
   --   UART RX
   --
   UART_RX_I: entity work.uart_rx
   port map (
      clk            => clk,
      reset_n        => reset_n and xl_ENABLE,
      ticks          => uart_TICKS,
      sin            => rxd,
      ack            => rx.rd,
      rdy            => rx_rdy,
      dout           => rx_data
   );

   --
   --  RX STATE MACHINE
   --
   process(all) begin
      if (reset_n = '0' or xl_ENABLE = '0') then

         -- Init the State Vector
         rx             <= C_RX_SV_INIT;

      elsif (rising_edge(clk)) then

         rx.tail        <= unsigned(xl_RX_TAIL);

         case rx.state is

            --
            -- WAIT FOR OCTET READY
            --
            when IDLE =>
               -- (head + 1) not equal to tail then receive
               if ((rx.head + 1) /= rx.tail and rx_rdy = '1') then
                  rx.state    <= RX_OCTET;
                  rx.rd       <= '1';
                  rx.wr       <= '1';
                  rx.msg      <= '1';
                  rx.timeout  <= (others => '0');
                  rx.data     <= rx_data;
               elsif (ctr1ms = '1' and rx.msg = '1' and xl_TIMEOUT /= X"00" and
                      rx.timeout = unsigned(xl_TIMEOUT)) then
                  rx.state    <= IDLE;
                  rx.timeout  <= (others => '0');
                  rx.irq      <= '1';
                  rx.msg      <= '0';
               elsif (ctr1ms = '1' and rx.msg = '1' and xl_TIMEOUT /= X"00" and
                      rx.timeout /= unsigned(xl_TIMEOUT)) then
                  rx.state    <= IDLE;
                  rx.timeout  <= rx.timeout + 1;
               else
                  rx.state    <= IDLE;
                  rx.irq      <= '0';
               end if;

            --
            -- RECEIVER IRQ
            --
            when RX_OCTET =>
               -- generate interrupt per character received
               if (xl_TIMEOUT = X"00") then
                  rx.state       <= IDLE;
                  rx.rd          <= '0';
                  rx.wr          <= '0';
                  rx.irq         <= '1';
                  rx.head        <= rx.head + 1;
               -- generate interrupt based on timeout
               else
                  rx.state       <= IDLE;
                  rx.rd          <= '0';
                  rx.wr          <= '0';
                  rx.irq         <= '0';
                  rx.head        <= rx.head + 1;
               end if;

            when others =>
               rx.state       <= IDLE;

         end case;

      end if;
   end process;

   --
   --  1MS TIMEOUT COUNTER
   --
   process(all) begin
      if (reset_n = '0' or xl_ENABLE = '0') then
         ctr1ms_cnt     <= (others => '0');
         ctr1ms         <= '0';
      elsif (rising_edge(clk)) then
         if (ctr1ms_cnt = C_CNTR_1KHZ) then
            ctr1ms_cnt  <= (others => '0');
            ctr1ms      <= '1';
         else
            ctr1ms_cnt  <= ctr1ms_cnt + 1;
            ctr1ms      <= '0';
         end if;
      end if;
   end process;

end rtl;
