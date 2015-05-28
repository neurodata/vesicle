### Overview

This directory contains the scripts/information needed to run the Caffe CNN synapse detection approach described in [Gray Roncal et. al. 2015](http://arxiv.org/abs/1403.3724).

Note that this depends upon the Caffe-based Object Classification and
Annotation [(COCA)](https://github.com/iscoe/coca) package.
You can either download this manually yourself or use the makefile (see the quick start instructions below).  

### Reproducing paper results
Here are "quick start" instructions; please see the Makefile for more
details.  Note this assumes you have a copy of the ISBI2013 data
on your local system (again, see Makefile).

    vi Makefile   # change macros at top of makefile as needed 
    make coca     # check out a copy of the COCA package
    make data     # put a copy of the EM data in a local directory

If you are running caffe on your local machine, you can run make targets associated with the experiment at this point (e.g. "make train-all").  If you will be running on a remote machine you can use the makefile to create a tar file:

    make tar-all

The above should create a file "tocluster.tar" that includes all the code and
data.  You'll then want to put this on a machine with a GPU
(in the example below is a machine called "gpucluster1").  Unpackage the tarball somewhere and launch a
makefile target.

    scp tocluster.tar gpucluster1:
    ssh -X gpucluster1
    mkdir /scratch/pekalmj1/SynapseDetectionRun
    cd /scratch/pekalmj1/SynapseDetectionRun
    tar xvf ~/tocluster.tar
    cd vesicle-cnn
    make train-all      # (or whatever target you want to run)

