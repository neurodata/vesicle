### Overview

This directory contains the scripts/information needed to run the Caffe CNN synapse detection approach described in [Gray Roncal et. al. 2015](http://arxiv.org/abs/1403.3724).

Note that this depends upon the Caffe-based Object Classification and
Annotation [(COCA)](https://github.com/iscoe/coca) package.

### Reproducing paper results
Here are "quick start" instructions; please see the Makefile for more
details.  Note this assumes you have a copy of the ISBI2013 data
on your local system (again, see Makefile).

    vi Makefile   # change macros at top of makefile as needed 
    make coca
    make data
    make tar-all

The above should create a file "tocluster.tar" with all the code and
data.  You'll then want to put this on a machine with a GPU
(e.g.,"gpucluster1").  Unpackage the tarball somewhere and launch a
makefile target.

    scp tocluster.tar gpucluster1:
    ssh -X gpucluster1
    mkdir /scratch/pekalmj1/SynapseDetectionRun
    cd /scratch/pekalmj1/SynapseDetectionRun
    tar xvf ~/tocluster.tar
    cd vesicle-cnn
    make train-all      # (or whatever target you want to run)


