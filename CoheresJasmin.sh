#!/bin/bash

date1="$1"
date2="$2"
lksrng=20 
lksazi=4

#Multilook
multi_look $date1/$date1.rslc $date1/$date1.rslc.par $date1/$date1.mli $date1/$date1.mli.par $lksrng $lksazi

#dateM=

widthmli=`grep range_sample $date1/$date1.mli.par | awk '{print $2}'`


###########################
	# INTERFEROGRAM
create_offset $date1.rslc.par $date2.rslc.par $date1\_$date2.off 1 $lksrng $lksazi 0
phase_sim_orb $date1.rslc.par $date2.rslc.par $date1\_$date2.off $dateM.hgt $date1\_$date2.sim_unw $date1.rslc.par - - 1 1

SLC_diff_intf $date1.rslc $date2.rslc $date1.rslc.par $date2.rslc.par $date1\_$date2.off $date1\_$date2.sim_unw $date1\_$date2.diff $lksrng $lksazi 0 0 0.2 1 1


# Coherence
cc_wave $date1\_$date2.diff $date1.rslc.mli $date2.rslc.mli $date1\_$date2.cc $widthmli 5 5 1

