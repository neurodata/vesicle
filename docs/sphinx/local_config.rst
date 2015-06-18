Configuration
*************

In order to use this truthing protocol, users should have the following software installed and configured appropriately.  A working understanding of machine learning and RAMON (TODO) are helpful but not absolutely required.  Their installation and configuration are documented on the linked websites:
 
* A recent version of MATLAB [vesicle-rf] http://www.mathworks.com
* `CAJAL Toolbox <http://github.com/openconnectome/cajal>`_
* LONI Pipeline 6.x for distributed computing http://pipeline.loni.usc.edu

* caffe and pycaffe [vesicle-cnn] http://caffe.berkeleyvision.org/
* Caffe-based Object Classification and Annotation (COCA) [vesicle-cnn] https://github.com/iscoe/coca

*vesicle-rf and vesicle-cnn have only been tested on mac and linux systems.* 

LONI Installation Notes
-----------------------

The workflow has been written to be simple to use and install.  The standalone MATLAB code has a driver script.  To demo the LONI distributed pipeline, To use this, follow the prerequisites and setup instructions and click RUN.  (estimated time to complete: 30-60 minutes prep-time and 10 minutes runtime).  If you are a new user, we recommend you install code in our suggested locations so that you don't need to modify the workflow.  The workflow should "just work."  You are welcome to write to our test annotation token, or get your own.

At a high-level, users should:

- Make sure that the two environment variables specified (for CAJAL and MATLAB) are on your LONI path for the vesicle package.  

.. code-block:: bash

  MATLAB_EXE_LOCATION='/Applications/MATLAB_R2014b.app/bin/matlab'
  CAJAL_LOCATION='/mnt/pipeline/tools/cajal'

- Adjust execution paths for modules and temp directories

Detailed LONI tips for new users
================================

For LONI, we assume the following installation paths:

- LONI: ``/Applications/LONI6``
- CAJAL: ``/mnt/pipeline/tools/CAJAL``
- temp directory: ``/mnt/tmp`` 

If running in LONI client mode, you may wish to add environment variables to your bash startup file to facilitate testing.  

On a Mac, this is best accomplished by adding the environment variables to your ~.bashrc file.  Because of the way that terminals are launched on a mac, it may be helpful to also create a ~/.bash_profile file with the following contents:

To launch LONI Pipeline to  Mac specific instructions:

.. code-block:: bash

  if [ -f ~/.bashrc ]; then
   source ~/.bashrc
  fi

When using LONI in a distributed server environment, environment variables are set on launch; this is best accomplished in a local processing environment by setting environment variables as documented above.  To launch LONI Pipeline in a way that includes these environment variables, run the following command:

  ``java -cp /Applications/LONI6.app/Contents/Resources/Java/Pipeline.jar ui.gui.Main``

Finally, to add the LONI modules and workflows from CAJAL to your personal LONI library, select your personal library location from LONI > Preferences > General > Personal Library Directory.  More information is `here <http://pipeline.loni.usc.edu/learn/user-guide/interface-overview/>`_.  Note that you can add multiple locations by specifying symbolic links in your personal library directory. 


