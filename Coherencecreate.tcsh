#!/bin/tcsh

### Create coherence pairs

if ($#argv != 2) then
  echo " "
  echo " usage: sentinel_gamma_proc_ifgms.tcsh masterdate interferogramlist.txt"
  echo " e.g. sentinel_gamma_proc_ifgms.tcsh 20180105 ifgmlist.txt"
  echo " Processes Sentinel Interferometric WideSwath Data in TOPS mode using Gamma"
  echo " Requires:"
  echo "           that you have already run: sentinel_gamma_proc_rslc.tcsh masterdate slclist"
  echo "           DEM of the area"
  echo "           a Processing Parameter File"
  echo "           a list of interferogram date pairs to process"
  echo "John Elliott: 24/10/2018, Leeds, based upon sentinel_gamma.tcsh John Elliott: 20/02/2015, Oxford"
  echo "Last Updated: 14/05/2019, Leeds"
  exit
endif

# Make a list of interferograms

# Store processing directory
set topdir = `pwd`
echo Processing in $topdir

# Master Date (for geodem)
set dateM = $1
echo Using Master Date: $dateM

# Interferogram List File
set listfile = $topdir/$2
if (-e $listfile) then
        echo "Using interferogram list file $listfile"
else
        echo "\033[1;31m ERROR - Interferogram list file $listfile missing - Exiting \033[0m"
        exit
endif


# Parameter File
set paramfile = $topdir/proc.param
if (-e $paramfile) then
        echo "Using parameter file $paramfile"
else
	echo "\033[1;31m ERROR - Parameter file $paramfile missing - Exiting \033[0m"
        exit
endif


# Select Gamma Version
set gammaver = `grep gammaver $paramfile | awk '{print $2}'`
app setup gamma/$gammaver
echo "\033[1;31m Using Gamma Version: \033[0m"
which par_S1_SLC

echo Procesing with SComplex Storage

setenv OMP_NUM_THREADS 12


# PARAMETERS
# Number of Looks
set lksrng = 20 #`grep lksrng $paramfile | awk '{print $2}'`
set lksazi = 4 #`grep lksazi $paramfile | awk '{print $2}'`
echo Looks in range: $lksrng and azimuth: $lksazi
