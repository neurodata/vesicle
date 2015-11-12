.. meta::
   :description: Official documentation for vesicle:  Volumetric Evaluation of Synaptic Inferfaces using Computer vision at Large Scale
   :keywords: synapse, connectomics, object detection, computer vision, pipeline

.. title::
   vesicle

.. raw:: html

	<h1>vesicle:  Volumetric Evaluation of Synaptic Inferfaces using Computer vision at Large Scale </h1>
	<br>


vesicle provides a context-aware method for scalable synapse detection in anisotropic electron microscopy data.  We provide two methods for object detection:  vesicle-rf and vesicle-cnn, which have computational and performance tradeoffs.

This work also resulted in the creation of a general-purpose object detection framework that can be used in a LONI pipelining environment.  We explain this detection paradigm and provide vesicle-rf code as an example.

.. figure:: images/vesicle_banner.jpg
    :width: 800px
    :align: center


.. raw:: html

  <div>
    <img style="width:30px;height:30px;vertical-align:middle">
    <span style=""></span>
    <IMG SRC="_static/GitHub.png" height="50" width="50"> <a href="https://github.com/openconnectome/vesicle/zipball/master"> [ZIP]   </a>
    <a image="_static/GitHub.png" href="https://github.com/openconnectome/vesicle/tarball/master">[TAR.GZ] </a></p>
  </div>


.. sidebar:: vesicle Contact Us

   If you have questions about vesicle, or have data to analyze, let us know:  support@neurodata.io

.. toctree::
   :maxdepth: 1
   :caption: Documentation

   sphinx/introduction
   sphinx/local_config
   sphinx/neurodata
   sphinx/faq

.. toctree::
   :maxdepth: 1
   :caption: Tutorials

   tutorials/vesiclerf
   tutorials/vesiclecnn

.. toctree::
   :maxdepth: 1
   :caption: Paper

   paper/bmvc
   paper/results

.. toctree::
   :maxdepth: 1
   :caption: Further Reading

   api/functions
   api/loni
   Gitter chatroom <https://gitter.im/openconnectome/vesicle>
   Mailing List <https://groups.google.com/forum/#!forum/ocp-support/>
   Github repo <https://github.com/openconnectome/vesicle>
   Release Notes <https://github.com/openconnectome/vesicle/releases/>

If you use vesicle or its data derivatives, please cite:
  William Gray Roncal, Michael Pekala, Verena Kaynig-Fittkau, Dean M Kleissas, Joshua T Vogelstein, Hanspeter Pfister, Randal Burns, R Jacob Vogelstein, Mark A Chevillet and Gregory D Hager. VESICLE: Volumetric Evaluation of Synaptic Interfaces using Computer Vision at Large Scale. In Xianghua Xie, Mark W. Jones, and Gary K. L. Tam, editors, Proceedings of the British Machine Vision Conference (BMVC), pages 81.1-81.13. BMVA Press, September 2015.
