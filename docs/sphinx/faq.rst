Frequently Asked Questions (FAQ)
********************************

This page will be updated to reflect commonly asked questions to provide a common reference point for questions and answers.  Users may also wish to search for answers on the general `OCP Support mailing list <https://groups.google.com/forum/#!forum/ocp-support>`_ archives.

New questions should be asked to `NeuroData Support <support@neurodata.io>`_.

**How do I get started?**

Please begin with the configuration page, which should get you up and running quickly, and then proceed to the tutorial pages.

**What are the limitations of your protocol?**

This initial version of vesicle-rf depends on membrane boundaries completed as a prior step (this will be documented separately).  Neurotransmitter-containing vesicles are computed as a separate preprocessing step, using code provided in this repo.  (This can be integrated, but is quite lightweight and requires different padding, and so is computed separately for simplicity.)

vesicle-cnn has no prior dependencies.  We have only tested the code with two datasets to date:  kasthuri14 and bock11.
