source ../script/settings.tcl

set ip_dir ../../$ip_name

set display_name $ip_display_name

# Erase the IP in the repo (if it exists), and create a directory for it
file delete -force $ip_dir/component.xml
file delete -force $ip_dir/xgui

update_compile_order -fileset sources_1
ipx::package_project -root_dir $ip_dir -vendor omniware.com -library user -taxonomy /UserIP -import_files -set_current false
ipx::unload_core $ip_dir/component.xml
ipx::edit_ip_in_project -upgrade true -name tmp_edit_project -directory $ip_dir $ip_dir/component.xml

set_property display_name $display_name [ipx::current_core]
set_property description $display_name [ipx::current_core]

set_property core_revision 1 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]

close_project -delete
