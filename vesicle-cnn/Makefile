#-------------------------------------------------------------------------------
# Uses Caffe to find synapses in electron microscropy (EM) data.
#
#
# SETUP/MISC TARGETS
#
#  coca      :=  grabs a copy of the COCA package from github
#  data      :=  copies data from local storage into local directory
#  tar       :=  makes a tar file containing all source code (e.g. for copy to cluster)
#  tar-all   := Like 'tar', but also includes matlab data files (these are large)
#
# CNN PROCESSING TARGETS
#
#  train-all       := Trains a CNN using all slices of training data
#  train-and-valid := Trains using subset of training data and validates on rest
#  deploy-train    := Evaluate a trained CNN on (entire) training volume
#  deploy-test     := Evaluate a trained CNN on test volume
#
#
#
# NOTES:
#   Assumes Caffe will be running remotely (e.g. on a gpu cluster); hence
#   the use of nohup in some targets.
#
#   To run on CPU (vs GPU) remove the "-gpu X" from the command line (and make sure the
#   default in the solver prototxt is CPU)
#
#
# February 2015, Mike Pekala
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Update these macros to match your local system configuration and desired experiment.
#
#   CAFFE_DIR :=  pointer to the PyCaffe directory (Caffe's Python API)
#   TAR :=  Set to "tar" for a linux system; use "tar" or "guntar" for OSX
#
#   SYN_OUT_DIR := CNN outputs will be placed in caffe_files/$(SYN_OUT_DIR)
#   SYN_IN_DIR := CNN inputs (prototxt and data) will live in caffe_files/$(SYN_IN_DIR)
#
#-------------------------------------------------------------------------------
CAFFE_DIR := ~/Apps/caffe/python
COCA_DIR := ./coca
EM_DATA_DIR := ~/Data/SynapseData3

TAR := tar
TARFILE := tocluster.tar

SYN_OUT_DIR := SynapseDetection
SYN_IN_DIR := synapse_isbi2013

TRAIN_SLICES := "range(0,70)"
VALID_SLICES := "range(70,100)"
ALL_SLICES := "range(100)"

# The naming convention we used was "Y_train.mat" was synapse-vs-all while
# "Y_train2.mat" was synapse-vs-non-synapse-membranes.
Y_TRAIN := Y_train2.mat

# set ROTATE to {0,1} for {fewer,more} rotations of training data
ROTATE := 1

# Set mask to a non-empty string (filename) if you want to specify
# a subset of the test cube to evaluate (e.g. subsampling).
TEST_MASK := ""
#TEST_MASK := $(SYN_IN_DIR)/M5.mat


# the trained model to use for deploy targets
MODEL := $(SYN_OUT_DIR)/iter_080000.caffemodel


#-------------------------------------------------------------------------------
# Everything from here on down should be system-independent
# (so hopefully no changes needed beyond this point)
#-------------------------------------------------------------------------------
dirname = $(patsubst %/,%,$(dir $1))

# MKFILE_PATH  := full path to this makefile (regardless of where pwd is)
# PACKAGE_PATH := the full path to the directory containing this makefile
# DATA_PATH    := full path to the data directory
# PACKAGE_NAME := the name of the directory containing this makefile
#
MKFILE_PATH    := $(abspath $(lastword $(MAKEFILE_LIST)))
PACKAGE_PATH   := $(dir $(MKFILE_PATH))
PACKAGE_NAME   := $(notdir $(call dirname,$(MKFILE_PATH)))

PY_PATH := $(CAFFE_DIR):$(COCA_DIR)


#-------------------------------------------------------------------------------
# SETUP/MISC TARGETS
#-------------------------------------------------------------------------------
default :
	@echo "please select a specific target"

coca :
	git clone https://github.com/iscoe/coca.git

data :
	mkdir -p caffe_files/$(SYN_IN_DIR)
	cp $(EM_DATA_DIR)/X_train.mat $(EM_DATA_DIR)/X_test.mat $(EM_DATA_DIR)/Y_train2.mat caffe_files/$(SYN_IN_DIR)

tar :
	\rm -f $(TARFILE)
	pushd .. && $(TAR) cvf $(PACKAGE_NAME)/$(TARFILE) `find $(PACKAGE_NAME) -name \*.py -print`
	pushd .. && $(TAR) rvf $(PACKAGE_NAME)/$(TARFILE) `find $(PACKAGE_NAME) -name \*.prototxt -print`
	pushd .. && $(TAR) rvf $(PACKAGE_NAME)/$(TARFILE) `find $(PACKAGE_NAME) -name Makefile* -print`


tar-all : tar
	pushd .. && $(TAR) rvf $(PACKAGE_NAME)/$(TARFILE) `find $(PACKAGE_NAME) -name *.mat -print`


#-------------------------------------------------------------------------------
# CNN PROCESSING TARGETS
#-------------------------------------------------------------------------------
train-all:
	PYTHONPATH=$(PY_PATH) nohup python $(COCA_DIR)/train.py  \
		-X $(SYN_IN_DIR)/X_train.mat \
		-Y $(SYN_IN_DIR)/$(Y_TRAIN)  \
		--train-slices $(ALL_SLICES) \
		--rotate-data $(ROTATE) \
		--snapshot-prefix $(SYN_OUT_DIR) \
		-s caffe_files/n3-solver.prototxt \
		--omit-labels "[-1,]" \
		-gpu 1 &> nohup.train.all.synapse &


train-and-valid:
	PYTHONPATH=$(PY_PATH) nohup python $(COCA_DIR)/train.py  \
		-X $(SYN_IN_DIR)/X_train.mat \
		-Y $(SYN_IN_DIR)/$(Y_TRAIN) \
		--train-slices $(TRAIN_SLICES) \
		--valid-slices $(VALID_SLICES) \
		--rotate-data $(ROTATE) \
		--snapshot-prefix $(SYN_OUT_DIR) \
		-s caffe_files/n3-solver.prototxt \
		--omit-labels "[-1,]" \
		-gpu 2 &> nohup.train.and.valid.synapse &


# Technically we don't need to evaluate the entire training cube, just
# the subset we hold out for validation.  However, for some purposes
# it is convenient to assess the performance on the entire training
# data set, so we do this here.
deploy-valid:
	PYTHONPATH=$(PY_PATH) nohup python $(COCA_DIR)/deploy.py  \
		-X $(SYN_IN_DIR)/X_train.mat \
		-s caffe_files/n3-solver.prototxt \
		-m $(MODEL) \
		--eval-slices $(ALL_SLICES) \
		--yhat-file $(SYN_OUT_DIR)/Yhat_train \
		-gpu 5 &> nohup.deploy.train.synapse &


deploy-test:
	PYTHONPATH=$(PY_PATH) nohup python $(COCA_DIR)/deploy.py  \
		-X $(SYN_IN_DIR)/X_test.mat \
		-M $(TEST_MASK) \
		-s caffe_files/n3-solver.prototxt \
		-m $(MODEL) \
		--yhat-file $(SYN_OUT_DIR)/Yhat_test \
		-gpu 4 &> nohup.deploy.synapse &


# These next few targets are for feature extraction
extract-train:
	PYTHONPATH=$(PY_PATH) nohup python $(COCA_DIR)/deploy.py  \
		-X $(SYN_IN_DIR)/X_train.mat \
		-s caffe_files/n3-solver.prototxt \
		-m $(MODEL) \
		--yhat-file $(SYN_OUT_DIR)/Yhat_train \
		--feature-file $(SYN_OUT_DIR)/Xprime_train \
		-gpu 3 &> nohup.extract.train.synapse  &

extract-test:
	PYTHONPATH=$(PY_PATH) nohup python $(COCA_DIR)/deploy.py  \
		-X $(SYN_IN_DIR)/X_test.mat \
		-s caffe_files/n3-solver.prototxt \
		-m $(MODEL) \
		--yhat-file $(SYN_OUT_DIR)/Yhat_test \
		--feature-file $(SYN_OUT_DIR)/Xprime_test \
		-gpu 4 &> nohup.extract.test.synapse &
