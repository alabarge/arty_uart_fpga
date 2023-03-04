onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_tb/UART_TOP_I/clk
add wave -noupdate /uart_tb/UART_TOP_I/reset_n
add wave -noupdate -expand -group SLAVE /uart_tb/UART_TOP_I/read_n
add wave -noupdate -expand -group SLAVE /uart_tb/UART_TOP_I/write_n
add wave -noupdate -expand -group SLAVE -radix hexadecimal /uart_tb/UART_TOP_I/address
add wave -noupdate -expand -group SLAVE -radix hexadecimal /uart_tb/UART_TOP_I/readdata
add wave -noupdate -expand -group SLAVE -radix hexadecimal /uart_tb/UART_TOP_I/writedata
add wave -noupdate /uart_tb/UART_TOP_I/irq
add wave -noupdate /uart_tb/UART_TOP_I/rxd
add wave -noupdate /uart_tb/UART_TOP_I/txd
add wave -noupdate /uart_tb/UART_TOP_I/led
add wave -noupdate -radix hexadecimal -childformat {{/uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.state -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.data -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.head -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.tail -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.irq -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.wr -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.busy -radix hexadecimal}} -expand -subitemconfig {/uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.state {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.data {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.head {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.tail {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.irq {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.wr {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx.busy {-height 15 -radix hexadecimal}} /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx
add wave -noupdate /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx_rdy
add wave -noupdate -radix hexadecimal /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/tx_data
add wave -noupdate -radix hexadecimal /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/rx
add wave -noupdate /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/rx_rdy
add wave -noupdate -radix hexadecimal /uart_tb/UART_TOP_I/UART_CORE_I/UART_CTL_I/rx_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2724272120 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {524288 ns}
