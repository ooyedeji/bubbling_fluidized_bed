#!/bin/bash

#===================================================================#
# allrun script for testcase as part of test routine
# run ErgunTestMPI
# Christoph Goniva - Sept. 2010
#===================================================================#

# - define variables
casePath="$(dirname "$(readlink -f ${BASH_SOURCE[0]})")"

# check if mesh was built
if [ -f "$casePath/CFD/constant/polyMesh/points" ]; then
    echo "mesh was built before - using old mesh"
else
    echo "mesh needs to be built"
    cd $casePath/CFD
    blockMesh
    snappyHexMesh -overwrite
fi

if [ -f "$casePath/DEM/post/restart/liggghts.restart" ]; then
    echo "LIGGGHTS init was run before - using existing restart file"
else
    #- run DEM in new terminal
    $casePath/parDEMrun.sh
fi

# keep old couplingProperties
cp $casePath/CFD/constant/couplingProperties $casePath/CFD/constant/couplingProperties_backup
cp $casePath/CFD/0/p $casePath/CFD/0/p_backup

#gnome-terminal --title='cfdemSolverPiso ErgunTestMPI CFD' -e "bash $casePath/parCFDDEMrun.sh"
. $casePath/parCFDDEMrun.sh

# restore old couplingProperties
mv $casePath/CFD/constant/couplingProperties_backup $casePath/CFD/constant/couplingProperties
mv $casePath/CFD/0/p_backup $casePath/CFD/0/p 