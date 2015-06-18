vesicle-rf
~~~~~~~~~~

To find the graph edges, we develop a lightweight, scalable Random Forest-based synapse classifier. We combine texture (i.e., intensity measures, image gradient magnitude, local binary patterns, structure tensors) with biological context (i.e., membranes and vesicles). We pruned a large feature set to just ten features and used this information to train a random forest. The pixel-level probabilities produced by the classifier were grouped into objects using size and probability thresholds and a connected component analysis. This method requires substantially less RAM than previous methods, which enables large-scale processing. A key insight was identifying neurotransmitter-containing vesicles present near (chemical, mammalian) synapses. 

These were located using a lightweight template correlation method and clustering. Performance was further enhanced by leveraging the high probability membrane voxels to restrict our search, improving both speed and precision. Our synapse performance was evaluated using the F1 object detection score, computed as the harmonic mean of the precision and recall, based on a gold-standard, neuroanatomist-derived dataset. We took care to define our object detection metric to disallow a single detection counting for multiple true synapses (as that result is ambiguous and allows for a single detection covering the whole volume to produce an F1 score of 1).

vesicle-rf is divided into three major sections:  training, evaluation, and deployment.

Preprocessing
-------------

Membrane detection is accomplished using caffe and is documented separately here (TODO).  vesicle-rf assumes that membrane detection is completed for the region of interest prior to synapse detection.

Vesicle detection (here referring to neurotransmitter-containing vesicles) is accomplished using template matching (derived from the source dataset).  To run vesicle detection on a dataset the following function should be used (TODO).

(HERE THE VESICLE FUNCTION IS EXPLAINED IN WORDS)

Training
--------

A training workflow - exists to download manual annotations and data and build a classifier (TODO).

(HERE THE TRAINING WORKFLOW OR SCRIPT IS INCLUDED)

Evaluation
----------

An evaluation workflow - based on a previously computed classifer, vesicle detections and membranes, synapses are computed for a single block of data and performance is computed.

(THIS IS A MATLAB SCRIPT AND PROBABLY ALSO A LONI WORKFLOW)

Deployment
----------

A deployment workflow - based on an operating point chosen in the evaluation step, this workflow runs at a chosen operating point across a larger dataset, and includes an example of block processing and merging. (TODO).

Block Processing Notes
======================
When running large datasets out of memory, cube boundaries need to be carefully considered. There are several ways to address this issue, all with various performance and accuracy considerations. 

Our object detection model is to do pixel level probability computations with padding, so that each pixel is evaluated with its proper context. 

Next, blocks are downloaded with a large pad (pad size is larger than a synapse), and objects are found through thresholding and connected components.  Objects that touch the cuboid boudary are discarded, as they will be uploaded in a subsequent block.  Finally, the remaining detections are uploaded; duplicates are eliminated by overwriting the previously uploaded detection and then eliminating duplicates.


Validation
----------

The expected results for the vesicle-rf evaluation pipeline, using default parameters and regions are as follows (pr-evaluate output). (NB: This is initially intended as a capability demonstration, and should not be used to assess the underlying algorithm quality, as it is for a very small region and is not tuned). 

For validation purposes, several (read only) tokens have been created, all on openconnecto.me:

These are defined for the AC3 Region:

.. code-block:: bash

  XRange = [5472, 6496]
  YRange = [8712, 9736]
  ZRange = [1000,1256]
  resolution = 1
 
- Server for all tokens is: ``openconnecto.me``
- EM token: ``kashuri11cc``
- Membrane token: ``kasthuri11_ac3_membranes``
- Vesicle token: ``kasthuri11cc_ac3_vesicles``
- Synapse truth token: ``kasthuri11_ac3_synapseTruth``
- Object Detection Reference Result (for z slices 1220-1236): ``exampleObjDetect``
- Writable tokens for testing are: ``testObjDetect3`` and ``testObjDetect4``


The entire workflow should have a runtime of about 10 minutes (2014 Macbook Pro, 3GHz, i7, 16GB RAM):


.. code-block:: bash

  Number Synapses detected: 22

  metrics = 
  precision: 0.7273
  recall: 0.4211
  TP: 16
  FP: 6
  FN: 22

A cutout of this result can be visualized using the following URL: http://openconnecto.me/ocp/overlay/0.6/exampleObjDetect/xy/1/5472,6496/8712,9736/1225/ or below.

.. figure:: ../images/vesiclerf_validation.png
    :align: center
