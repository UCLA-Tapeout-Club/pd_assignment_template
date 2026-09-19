## READ THIS: modify this file. the sections are out of order. rearrange based on your knowledge of the pnr flow. multiple orders may be correct, but there are also some orders that are incorrect but won't fatal, though warnings/log messages may clue you into if the order is wrong in those cases. ##

#### SECTION A ####
addTieHiLo -cell "LOGIC1_X1 LOGIC0_X1"

assignIoPins -pin *

globalNetConnect VDD -type pgpin -pin VDD -all -verbose
globalNetConnect VSS -type pgpin -pin VSS -all -verbose
globalNetConnect VDD -type tiehi -pin VDD -all -verbose
globalNetConnect VSS -type tielo -pin VSS -all -verbose
#### END SECTION A ####

#### SECTION B ####
create_ccopt_clock_tree_spec
set_ccopt_property update_io_latency false
# clock_opt_design
ccopt_design
#### END SECTION B ####

#### SECTION C ####
routeDesign
#### END SECTION C ####

#### SECTION D ####
set init_mmmc_file "../scripts/innovus-mcmm-setup.tcl"
set init_verilog   "../../synth/output/post-synth.v"
set init_top_cell  "tt_um_spi_reg_bank"
set init_lef_file  "/home/nadersb/ucla-tapeout/libraries/freepdk-45nm-d3be42a72ca6eabff54a4f3be50c16613f69f1b6/rtk-tech.lef  /home/nadersb/ucla-tapeout/libraries/freepdk-45nm-d3be42a72ca6eabff54a4f3be50c16613f69f1b6/stdcells.lef"
set init_gnd_net   "VSS"
set init_pwr_net   "VDD"

init_design
#### END SECTION D ####

#### SECTION E ####
addRing \
  -nets {VDD VSS} -width 0.8 -spacing 0.8 \
  -layer [list top 9 bottom 9 left 8 right 8]

addStripe \
  -nets {VSS VDD} -layer 9 -direction horizontal \
  -width 0.8 -spacing 4.8 \
  -set_to_set_distance 11.2 -start_offset 2.4

addStripe \
  -nets {VSS VDD} -layer 8 -direction vertical \
  -width 0.8 -spacing 4.8 \
  -set_to_set_distance 11.2 -start_offset 2.4
#### END SECTION E ####

#### SECTION F ####
optDesign -postCTS -setup
optDesign -postCTS -hold

#### END SECTION F ####

#### SECTION G ####
setDesignMode -process 45

setDelayCalMode -SIAware false
setOptMode -usefulSkew false

setOptMode -holdTargetSlack 0.010
setOptMode -holdFixingCells {BUF_X1 BUF_X1 BUF_X2 BUF_X4 BUF_X8 BUF_X16 BUF_X32}
#### END SECTION G ####

#### SECTION H ####
sroute -nets {VDD VSS}
#### END SECTION H ####

#### SECTION I ####
setFillerMode -core {FILLCELL_X4 FILLCELL_X2 FILLCELL_X1}
addFiller
#### END SECTION I ####

#### SECTION J ####
place_opt_design
#### END SECTION J ####

#### SECTION K ####
extractRC
#### END SECTION K ####

#### SECTION L ####
saveDesign ../output/post-pnr.enc

rcOut -rc_corner typical -spef ../output/post-pnr.spef
write_sdf ../output/post-pnr.sdf
saveNetlist ../output/post-pnr.v

streamOut ../output/post-pnr.gds \
  -merge "/home/nadersb/ucla-tapeout/libraries/freepdk-45nm-d3be42a72ca6eabff54a4f3be50c16613f69f1b6/stdcells.gds" \
  -mapFile "/home/nadersb/ucla-tapeout/libraries/freepdk-45nm-d3be42a72ca6eabff54a4f3be50c16613f69f1b6/rtk-stream-out.map"

report_timing -late -max_paths 999 > ../output/setup.rpt
report_timing -late -max_slack 0 > ../output/setup_negs.rpt
report_timing -early -max_paths 999 > ../output/hold.rpt
report_timing -early -max_slack 0 > ../output/hold_negs.rpt
report_area -verbose > ../output/area.rpt
report_power -hierarchy all > ../output/power.rpt
#### END SECTION L ####

#### SECTION M ####
floorPlan -r 1.0 0.70 4.0 4.0 4.0 4.0
#### END SECTION M ####

#### SECTION N ####
verifyConnectivity
verify_drc
#### END SECTION N ####

#### SECTION O ####
optDesign -postRoute -setup
optDesign -postRoute -hold
#### END SECTION O ####