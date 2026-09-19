## this file need not be changed. ##

create_rc_corner -name typical \
   -cap_table "/home/nadersb/ucla-tapeout/libraries/freepdk-45nm-d3be42a72ca6eabff54a4f3be50c16613f69f1b6/rtk-typical.captable" \
   -T 25

create_library_set -name libs_typical \
   -timing [list "/home/nadersb/ucla-tapeout/libraries/freepdk-45nm-d3be42a72ca6eabff54a4f3be50c16613f69f1b6/stdcells.lib"]

## TODO: link library and RC to create a corner ##

create_delay_corner -name delay_default \
   -library_set libs_typical \
   -rc_corner typical

## TODO: load sdc to create a mode ##

create_constraint_mode -name constraints_default \
   -sdc_files [list ../../synth/output/post-synth.sdc]

## TODO: link mode and corner to create an analysis view ##

create_analysis_view -name analysis_default \
   -constraint_mode constraints_default \
   -delay_corner delay_default

## TODO: set setup and hold analyses ##

set_analysis_view -setup analysis_default -hold analysis_default