transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {../../../packages/lib_pkg.vhd}
vcom -2008 -work work {../../../packages/PCK_tb.vhd}
vcom -2008 -work work {../../../packages/PCK_print_utilities.vhd}
vcom -2008 -work work {../../../packages/PCK_FIO_1993.vhd}
vcom -2008 -work work {../../../packages/PCK_FIO_1993_BODY.vhd}
vcom -2008 -work work {../uart_rx_ram.vhd}
vcom -2008 -work work {../uart_tx_ram.vhd}
vcom -2008 -work work {../uart_rx.vhd}
vcom -2008 -work work {../uart_tx.vhd}
vcom -2008 -work work {../uart_ctl.vhd}
vcom -2008 -work work {../uart_irq.vhd}
vcom -2008 -work work {../uart_regs.vhd}
vcom -2008 -work work {../uart_core.vhd}
vcom -2008 -work work {../uart_top.vhd}
