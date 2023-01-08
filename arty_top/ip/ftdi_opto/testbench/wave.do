onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group SLAVE /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/clk
add wave -noupdate -expand -group SLAVE /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/reset_n
add wave -noupdate -expand -group SLAVE /ftdi_opto_tb/FTDI_OPTO_I/read_n
add wave -noupdate -expand -group SLAVE /ftdi_opto_tb/FTDI_OPTO_I/write_n
add wave -noupdate -expand -group SLAVE -radix hexadecimal /ftdi_opto_tb/FTDI_OPTO_I/address
add wave -noupdate -expand -group SLAVE -radix hexadecimal /ftdi_opto_tb/FTDI_OPTO_I/readdata
add wave -noupdate -expand -group SLAVE -radix hexadecimal /ftdi_opto_tb/FTDI_OPTO_I/writedata
add wave -noupdate /ftdi_opto_tb/FTDI_OPTO_I/irq
add wave -noupdate -expand -group OPTO /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/fsclk
add wave -noupdate -expand -group OPTO /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/fscts
add wave -noupdate -expand -group OPTO /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/fsdo
add wave -noupdate -expand -group OPTO /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/fsdi
add wave -noupdate -radix hexadecimal -childformat {{/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/FTDI_RTX_I/tx.dat -radix hexadecimal}} -expand -subitemconfig {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/FTDI_RTX_I/tx.dat {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/FTDI_RTX_I/tx.bit_cnt {-format Analog-Step -height 74 -max 10.0}} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/FTDI_RTX_I/tx
add wave -noupdate /ftdi_opto_tb/fsclk_r0
add wave -noupdate /ftdi_opto_tb/bit_cnt
add wave -noupdate /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/tx_rdy
add wave -noupdate /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/FTDI_RTX_I/dat_wr
add wave -noupdate -radix hexadecimal -childformat {{/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.state -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_head -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_tail -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_ptr -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_din -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_rd -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_we -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_int -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_esc -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_busy -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_tail -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_head -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_ptr -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_len -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_cnt -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_din -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_wr -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_int -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_busy -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.dout -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_ptr -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_busy -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_ack -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_int -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_cnt -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_run -radix hexadecimal} {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.flush_cnt -radix hexadecimal}} -expand -subitemconfig {/ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.state {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_head {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_tail {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_ptr {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_din {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_rd {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_we {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_int {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_esc {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.rx_busy {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_tail {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_head {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_ptr {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_len {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_cnt {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_din {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_wr {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_int {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.tx_busy {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.dout {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_ptr {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_busy {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_ack {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_int {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_cnt {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.pipe_run {-height 15 -radix hexadecimal} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft.flush_cnt {-height 15 -radix hexadecimal}} /ftdi_opto_tb/FTDI_OPTO_I/OPTO_CORE_I/OPTO_CTL_I/ft
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {42267289 ps} 0}
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
configure wave -timelineunits us
update
WaveRestoreZoom {40833689 ps} {44929689 ps}
