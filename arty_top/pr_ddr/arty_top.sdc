set_false_path -from [get_ports ext_resetn] -to [all_registers]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
