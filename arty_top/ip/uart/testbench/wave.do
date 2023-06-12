onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_aclk
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_aresetn
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_awaddr
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_awprot
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_awvalid
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_awready
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_wdata
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_wstrb
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_wvalid
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_wready
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_bresp
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_bvalid
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_bready
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_araddr
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_arprot
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_arvalid
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_arready
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_rdata
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_rresp
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_rvalid
add wave -noupdate -expand -group AXI_SLAVE -radix hexadecimal /uart_tb/s_axi_rready
add wave -noupdate -expand -group CPU -radix hexadecimal /uart_tb/UART_TOP_I/UART_CTL_I/cpu_RXD
add wave -noupdate -expand -group CPU -radix hexadecimal /uart_tb/UART_TOP_I/UART_CTL_I/cpu_TXD
add wave -noupdate -expand -group CPU -radix hexadecimal /uart_tb/UART_TOP_I/UART_CTL_I/cpu_ADDR
add wave -noupdate -expand -group CPU -radix hexadecimal /uart_tb/UART_TOP_I/UART_CTL_I/cpu_WE
add wave -noupdate -expand -group CPU -radix hexadecimal /uart_tb/UART_TOP_I/UART_CTL_I/cpu_RE
add wave -noupdate -expand -group CPU -radix hexadecimal /uart_tb/UART_TOP_I/UART_CTL_I/uart_CONTROL
add wave -noupdate -expand -group CPU -radix hexadecimal /uart_tb/UART_TOP_I/UART_CTL_I/uart_TICKS
add wave -noupdate -expand -group CPU -radix hexadecimal /uart_tb/UART_TOP_I/UART_CTL_I/uart_STATUS
add wave -noupdate -expand -group CPU -radix hexadecimal /uart_tb/UART_TOP_I/UART_CTL_I/uart_PTR_STA
add wave -noupdate -expand -group CPU -radix hexadecimal /uart_tb/UART_TOP_I/UART_CTL_I/uart_PTR_CTL
add wave -noupdate /uart_tb/UART_TOP_I/irq
add wave -noupdate /uart_tb/UART_TOP_I/rxd
add wave -noupdate /uart_tb/UART_TOP_I/txd
add wave -noupdate -radix hexadecimal -childformat {{/uart_tb/UART_TOP_I/UART_CTL_I/tx.state -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/tx.data -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/tx.tail -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/tx.irq -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/tx.wr -radix hexadecimal}} -subitemconfig {/uart_tb/UART_TOP_I/UART_CTL_I/tx.state {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/tx.data {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/tx.tail {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/tx.irq {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/tx.wr {-height 15 -radix hexadecimal}} /uart_tb/UART_TOP_I/UART_CTL_I/tx
add wave -noupdate -radix hexadecimal -childformat {{/uart_tb/UART_TOP_I/UART_CTL_I/rx.state -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/rx.data -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/rx.head -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/rx.timeout -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/rx.count -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/rx.msg -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/rx.irq -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/rx.wr -radix hexadecimal} {/uart_tb/UART_TOP_I/UART_CTL_I/rx.rd -radix hexadecimal}} -expand -subitemconfig {/uart_tb/UART_TOP_I/UART_CTL_I/rx.state {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/rx.data {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/rx.head {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/rx.timeout {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/rx.count {-format Analog-Step -height 74 -max 32.0 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/rx.msg {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/rx.irq {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/rx.wr {-height 15 -radix hexadecimal} /uart_tb/UART_TOP_I/UART_CTL_I/rx.rd {-height 15 -radix hexadecimal}} /uart_tb/UART_TOP_I/UART_CTL_I/rx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4001441672 ps} 0}
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
WaveRestoreZoom {0 ps} {5591782382 ps}
