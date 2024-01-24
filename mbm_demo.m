% Demo code for mapping cortical thickness difference using MBM.
% This demo uses the thickness maps generated by the framework described in
% the MBM paper. In particular, 25 maps were generated from each of the two
% ground truths. The list of maps' filenames is in 'map_list.txt'.  The
% indicator matrix that identifies the two groups of the maps is stored in
% 'G_two_sample.txt'. All input files are stored in 'data' folder.
% Using MBM, we obtain the \beta spectrum, significant pattern that
% comprises the weighted significant modes, and a number of the most influential modes.

clear all
close all

MBM.maps.anatListFile = fullfile('/home/trangc/kg98/trangc/VBM/data/HCP', 'map_list.txt'); % text file comprise the list of paths to the anatomical maps
MBM.maps.maskFile = fullfile('/home/trangc/kg98/trangc/VBM/data/MBM', 'fsaverage_164k_cortex-lh_mask.txt'); % path to mask

MBM.stat.test = 'two sample'; % statistical test
MBM.stat.indicatorFile = fullfile('data', 'G_two_sample.txt'); % path to indicator matrix

MBM.stat.nPer = 10; % number0 of permutations
MBM.stat.pThr = 0.1; % threshold for tail estimation
MBM.stat.thres = 0.05; % statistical threshold to be considered significant
MBM.stat.fdr = false; % FDR correction

MBM.eig.eigFile = fullfile('data', 'fsaverage_164k_midthickness-lh_eval_200.txt'); % path to eigenmode file
MBM.eig.nEigenmode = 150; % number of eigenmodes for analysis
MBM.eig.saveResult = true; % save the results, i.e., MBM structure
MBM.eig.resultFile = fullfile('results','demo.mat'); % folder where to save the results

MBM.plot.visualize = true; % visualise the results
MBM.plot.saveFig = true; % save the visualisation of the results
MBM.plot.vtkFile = fullfile('data', 'fsLR_32k_midthickness-lh.vtk'); % path to vtk file
MBM.plot.hemis = 'left'; % hemisphere to be analysed
MBM.plot.nInfluentialMode = 6; % number of most influential modes to be plotted

MBM = mbm_main(MBM);
