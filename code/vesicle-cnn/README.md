## vesicle-cnn

The vesicle-cnn package constructs a convolutional neural network (CNN) for detecting synapses in electron microscopy (EM) image volumes (tensors of dimension #rows x #columms #slices).  In particular, synapse detection is framed as a sequence of binary classification problems induced by sliding a small (65x65) pixel window over each slice of a data volume.  For each tile (data in a single window) the classification problem is to determine the class label of the center pixel in the tile, which is either a synapse pixel (class label +1) or a non-synapse pixel (class label 0).  This approach is inspired by the paper by [Ciresan et. al.](http://papers.nips.cc/paper/4741-deep-neural-networks-segment-neuronal-membranes-in-electron-microscopy-images) which uses the same technique to classify membranes in EM data.  As opposed to constructing features by hand, this approach simultaneously learns features and classifier parameters as part of the CNN training process.  An approchable tutorial for CNNs and deep learning can be found [here](http://deeplearning.net/tutorial/lenet.html).

To implement the CNN we used the [Caffe](http://caffe.berkeleyvision.org/) deep learning framework developed by UC Berkeley.  As of this writing Caffe does not provide a sliding window classification procedure out-of-the-box; for this we use the Caffe-based Object Classification and Annotation [COCA](https://github.com/isco/coca) package.  The Caffe and COCA do all of the work; vesicle-cnn is itself not a software produce but merely a merely a particular invocation of COCA tailored for the synapse detection problem. More specifically, vesicle-cnn provides the scripts/information needed to run the synapse detection approach described in [Gray Roncal et. al. 2015](http://arxiv.org/abs/1403.3724).  It can be readily used for other applications by changing the inputs (data volumes and class labels) and configuration parameters appropriately.

vesicle-cnn includes two main steps: 
- training a CNN and then 
- deploying the trained model on held-out test data.  

Complete examples are provided in the vesicle-cnn Makefile and are described briefly below.  Note that we generally assume a linux-like operating system, that Caffe has been installed and that COCA has been downloaded.

### Preprocessing
The COCA PyCaffe wrapper assumes all input volumes (data and class labels) are tensors of dimension (#rows x #columns x #slices) saved as separate matlab files that using the '-v7.3' flag (i.e. are hdf files).  For further details, please see the *load_cube()* function in COCA's *emlib.py* module.  Example inputs are provided [here](TODO).

While not technically data preprocessing, the COCA scripts will need to be told where Caffe is installed (in order to import the PyCaffe API).  The recommended (i.e. least painful) way to do this is to set the *CAFFE_DIR* macro in the vesicle-cnn Makefile and use this to carry out the training and deploy steps.

    vi Makefile   # change macros at top of makefile as needed 


### Training
Training the CNN involves running the COCA $train.py$ script from the command-line.  The Makefile targets *train-all* and *train-and-valid* provide two examples of this procedure (the former uses the entire training volume for training while the latter holds some slices out for validation).  Assuming everything has been installed and configured properly, training is carried out from the command line via

    make train-all

### Deployment
Once a CNN model has been trained, this model can be applied to new data volumes.  The makefile targets *deploy-valid* and *deploy-test* provide two examples of this procedure.  The first evaluates the classifier on the training volume (usually done for the purposes of analyzing performance on the held-out validation slices) and the latter runs the model on the held-out test volume.

    make deploy-valid


### Miscellaneous

There are a few other "utility" targets in the Makefile that provide a few useful shortcuts for administrative tasks.  To download the COCA package from githup one can use the "coca" target, i.e. 

    make coca     # check out a copy of the COCA package

If you are running caffe on your local machine, you can run make targets associated with the experiment at this point (e.g. "make train-all").  If you will be running on a remote machine (which is what we usually do - training and evaluation are computationally expensive and we run them on our GPU cluster) you can use the makefile to create a tar file:

    make tar-all

The above should create a file "tocluster.tar" that includes all the code and
data.  You'll then want to put this on the GPU processing machine 
(in the example below is a machine called "gpucluster1").  Unpackage the tarball somewhere and run your preferred makefile target.

    scp tocluster.tar gpucluster1:
    ssh -X gpucluster1
    mkdir /scratch/pekalmj1/SynapseDetectionRun
    cd /scratch/pekalmj1/SynapseDetectionRun
    tar xvf ~/tocluster.tar
    cd vesicle-cnn
    make train-all      # (or whatever target you want to run)

