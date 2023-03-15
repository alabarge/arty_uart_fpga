do uart_run_msim_rtl_vhdl.do

vcom -2008 -work work {./uart_TB.vhd}

vsim -L rtl_work -L work -L blk_mem_gen_v8_4_5 -L xpm -L unisims_ver -L unimacro_ver -L secureip -voptargs="+acc"  uart_TB

do wave.do