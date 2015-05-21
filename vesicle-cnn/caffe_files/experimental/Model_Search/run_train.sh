#!/bin/bash
#
#  Use this to launch a single synapse training run.
#  To run manually this might look like:
#
#        ./run_train.sh  n3-s2-solver.prototxt  1
#
#  However, the actual use case I have in mind is to have this script
#  be launched by the hyperparameter search consumer process.
#
#  May 2015, mjp

# Can change BASE_DIR to an absolute path so this script doesn't have
# to be run from pwd in order to work properly.
BASE_DIR=.

COCA_DIR=$BASE_DIR/../../../coca
DATA_DIR=$BASE_DIR/../../synapse_isbi2013
SOLVER_FILE="$1"
GPU_ID="$2"

#-------------------------------------------------------------------------------
echo "Caffe solver file: $SOLVER_FILE"
echo "GPU ID:            $GPU_ID"

PYTHONPATH=~/Apps/caffe/python python $COCA_DIR/train.py \
           -X $DATA_DIR/X_train.mat \
           -Y $DATA_DIR/Y_train2.mat \
           --train-slices "range(0,70)" \
           --valid-slices "range(70,100)" \
           --rotate-data 1 \
           -s $SOLVER_FILE \
           --omit-labels "[-1,]" \
           -gpu $GPU_ID
