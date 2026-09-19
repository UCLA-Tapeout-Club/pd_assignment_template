## READ THIS: this is the raw file i received from another school's tapeout-esque team member that worked for their inputs, but not ours. fix pointers that don't exist based on context, read warnings/error messages and determine if you need to address them or not. use the Cadence Ask site to look up command documentation if needed: https://support.cadence.com/ ##
## one potentially helpful hint: we need to read all .sv files in /rtl but the current script only reads one file. else the tool will complain, and you will set it. ##
## you can skip to running the correct, complete flow if you're short on time. this is just for learning the specific genus commands and practicing tcl scripting. ##
## correct flow can be found here: /home/nadersb/ucla-tapeout/ecao/pd-assignment/synth/scripts/genus-synth.tcl ##

set_db init_lib_search_path /home/nadersb/ucla-tapeout/libraries/freepdk-45nm-d3be42a72ca6eabff54a4f3be50c16613f69f1b6/
set_db init_hdl_search_path /home/nadersb/ucla-tapeout/ucla-chip-design-main/design/

set_db library stdcells.lib
read_hdl des.v

elaborate fsm100g

# dont uses ? scan flip flops in nangate

set clock [create_clock -period 1 -name clk clk]
# external_delay -input <>
# external_delay -output <>

syn_generic #rtl optimization

syn_map #mapping

report_timing >
report_area >

write_hdl > post-synth.v
write_script > 

quit
