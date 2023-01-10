set_false_path -from [get_ports reset] -to [all_registers]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
