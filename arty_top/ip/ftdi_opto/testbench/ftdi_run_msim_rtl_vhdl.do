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
vcom -2008 -work work {../opto_2k.vhd}
vcom -2008 -work work {../opto_burst.vhd}
vcom -2008 -work work {../opto_fifo.vhd}
vcom -2008 -work work {../opto_rtx.vhd}
vcom -2008 -work work {../opto_ctl.vhd}
vcom -2008 -work work {../opto_irq.vhd}
vcom -2008 -work work {../opto_regs.vhd}
vcom -2008 -work work {../opto_core.vhd}
vcom -2008 -work work {../opto_top.vhd}
