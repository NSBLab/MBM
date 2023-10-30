% Demo code for mapping cortical thickness difference using MBM.
% This demo uses the thickness maps generated by the framework described in
% the MBM paper. In particular, 25 maps were generated from each of the two
% ground truths. The list of maps' filenames is in 'map_list.txt'.  The
% indicator matrix that identifies the two groups of the maps is stored in
% 'G_mat.txt'. All input files are stored in 'data' folder.
% Using MBM, we obtain the \beta spectrum, significant pattern that
% comprises the weighted significant modes, and most influential modes.

clear all
close all

tempList = regexp(fileread(fullfile('data', 'map_list.txt')), '\n', 'split');
MBM.maps.anatList = fullfile('data', 'thick', tempList(1:length(tempList)-1)); % list of paths to maps, removed the last empty line when reading the file
MBM.maps.maskFile = fullfile('data', 'mask_S1200.L.midthickness_MSMAll.32k_fs_LR.txt'); % path to mask

MBM.stat.test = 'two sample'; % statistical test
MBM.stat.indicatorFile = fullfile('data', 'G_mat.txt'); % path to indicator matrix

MBM.stat.nPer = 10; % number0 of permutations
MBM.stat.pThr = 0.1; % threshold for tail estimation
MBM.stat.thres = 0.05; % statistical threshold to be considered significant
MBM.stat.fdr = false; % FDR correction

MBM.eig.eigFile = fullfile('data', 'evec_501_masked_S1200.L.midthickness_MSMAll.32k_fs_LR.txt'); % path to eigenmode file
MBM.eig.nEigenmode = 150; % number of eigenmodes for analysis
MBM.eig.saveResult = true; % save the results, i.e., MBM structure
MBM.eig.resultFolder = 'results'; % folder where to save the results

MBM.plot.visualize = true; % visualise the results
MBM.plot.saveFig = true; % save the visualisation of the results
MBM.plot.vtkFile = fullfile('data', 'fsLR_32k_midthickness-lh.vtk'); % path to vtk file
MBM.plot.hemis = 'left'; % hemisphere to be analysed
MBM.plot.nInfluentialMode = 6; % number of most influential modes to be plotted

% MBM.inApp = false; % indicate not using app

%%save fig

MBM = mbm_main(MBM);
