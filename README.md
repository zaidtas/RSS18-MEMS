# Directionally controlled ToF Imaging

This repository is an implementation of the algorithms presented in  [Directionally Controlled Time-of-Flight Ranging for Mobile Sensing Platforms](http://www.roboticsproceedings.org/rss14/p11.pdf) in a simulation.


## Quick start
### Requirements
You will need the following Matlab toolboxes downloaded in your repository.

**[Ray/box intersection](https://www.mathworks.com/matlabcentral/fileexchange/26834-ray-box-intersection)** : Calculates whether a particular ray is passing a voxel or not.

**[Plane Fitting and Normal Calculation](https://www.mathworks.com/matlabcentral/fileexchange/37775-plane-fitting-and-normal-calculation)** : Fits a plane to a given point cloud and calculates the normal to that plane

### Data
We use a dense point cloud of a simulated scene imaged by the [Blensor](https://www.blensor.org/) software that acts as our ground truth for further simulations. It is stored as the **gt_dense_scan.mat**.

Additionally we have calculated the ICS for a dense set of trajectories to speed up the process of calculating CSQMI for potential trajectories.

### USE

* Run scan_calc_voxel_score.m to get a base scan and complexity score 
* Run the cluster_script.m to get the ROI
* Run calculate_CSQMI_for_potential_scans for calculating the CSQMI score for potential trajectories from the cluster calculated 
