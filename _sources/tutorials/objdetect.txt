Object Detection
~~~~~~~~~~~~~~~~

To aid new algorithm development and deployment, this page provides and documents an end-to-end object detection pipeline.  Both standalone code and distributed versions (LONI modules and workflows) are provided, using vesicle-rf as an example.  This provides an easy starting point for users new to the OCP toolchain to accomplish commonly performed tasks, or to backend previously existing algorithms. These tasks are not exhaustive, but cover many common situations, including downloading data from OCP, running an algorithm, uploading the data, and evaluating the results. 

BYOODA:  Bring Your Own Object Detection Algorithm
--------------------------------------------------

This workflow is designed to make it easy to drop in your own object detection algorithm and run in a distributed LONI environment.  **However, LONI should only be attempted once you have working code.** This means that you should have a repository with all required dependencies, and your data in Open Connectome Project.  You should write function(s) that take in RAMONVolume(s) and output a single RAMONVolume containing your detected objects.  

In the example, we choose to split these functions into two parts:  pixel classification and objectification.  We use MATLAB for simplicity; it is possible to use algorithms written in other languages as well.  Documentation for this is forthcoming; in the meantime, if you need help connecting MATLAB RAMONVolumes to Python (...C, Java...), please post on [[https://groups.google.com/forum/#!forum/ocp-support|ocp-Support]].


.. figure:: ../images/objdetect_overview.png
    :width: 300px
    :align: center



A summary of each step is below.  Modules and functions that implement these steps are explained in detail on their respective pages.  *Download and Upload functions are part of the CAJAL toolbox and are documented and available here (TODO).*

- Compute Cutout Regions: A module to determine the operating region.
- Download Data:  Downloads the data volume(s) required for processing.
- Pixel Classification:  A module that begins with image data and a trained classifier and assigns probabilistic class labels as outputs.
- RAMON Objectification:  Turns probability maps of objects into discrete objects, through thresholding, connected components, and/or other techniques.
- Upload Data:  A module that uploads data - both voxel list (sparse) and dense options are available
- Evaluate Performance: A module to compute precision/recall for the chosen operating point

