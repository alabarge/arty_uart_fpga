source settings.tcl

# don't do anything if the build folder already exists
# otherwise, create the folder
if {[file exists $build_dir]} {
    puts "ERROR: Build directory already exists. Remove and try again. Aborting."
	exit
} else {
    file mkdir $build_dir
}

cd $build_dir

# create the project
create_project -part $fpga_device -force $project_name

set_property target_language VHDL [current_project]

# add the rtl files
add_files $src_dir/stamp_top.vhd
read_vhdl -vhdl2008 $src_dir/stamp_regs.vhd
read_vhdl -vhdl2008 $src_dir/fpga_build.vhd

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
