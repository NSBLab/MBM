% Demo code for mapping cortical thickness difference taking into account covariate of sex and age, i.e., ANCOVA, using MBM.
%
% This demo uses 95 emperical thickness maps from an open dataset.
% All maps are combined in y.mgh (or y.mat) where each row is a map.
% 
% The design matrix that identifies the two groups of the maps and covariates is stored in
% 'ANCOVA_matrix_4.txt'. 
% 
% All input files are stored in 'data/demo_2' folder.
%
% Using MBM, we obtain the \beta spectrum, significant pattern that
% comprises the weighted significant modes, and a number of the most influential modes.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

clear all
close all

rng(2); % set the default seed for random generation to ensure the results are reproducible.

wdir = pwd();
dataDir = fullfile(wdir, 'data', 'demo_2');

% change to use .mgh or .mat file
% MBM.maps.anatListFile = fullfile(dataDir, 'y.mgh'); % comprising all map where each row is a map
MBM.maps.anatListFile = fullfile(dataDir, 'y.mat'); % comprising all map where each row is a map

MBM.maps.maskFile = fullfile(dataDir, 'fsaverage_164k_cortex-lh_mask.txt'); % path to mask

% change statistical test as desired
MBM.stat.test = 'ANCOVA'; % statistical test
MBM.stat.designFile = fullfile(dataDir, 'G_ANCOVA.txt'); % path to design matrix
% MBM.stat.test = 'ANCOVA'; % statistical test
% MBM.stat.designFile = fullfile(dataDir, 'ANCOVA_matrix_4.txt'); % path to design matrix

MBM.stat.nPer = 10; % number0 of permutations
MBM.stat.pThr = 0.1; % threshold for tail estimation
MBM.stat.thres = 0.05; % statistical threshold to be considered significant
MBM.stat.fdr = false; % FDR correction

MBM.eig.eigFile = fullfile(dataDir, 'fsaverage_164k_midthickness-lh_emode_200.txt'); % path to eigenmode file
MBM.eig.nEigenmode = 150; % number of eigenmodes for analysis
MBM.eig.saveResult = true; % save the results, i.e., MBM structure
MBM.eig.resultFile = fullfile(dataDir,['mbm_demo_2.mat']); % folder where to save the results

MBM.plot.visualize = true; % visualise the results
MBM.plot.saveFig = true; % save the visualisation of the results
MBM.plot.figFile = fullfile(dataDir, 'demo_2.fig'); % where to save the visualisation of the results.
MBM.plot.vtkFile = fullfile(dataDir, 'fsaverage_164k_midthickness-lh.vtk'); % path to vtk file
MBM.plot.hemis = 'left'; % hemisphere to be analysed
MBM.plot.nInfluentialMode = 5; % number of most influential modes to be plotted

MBM = mbm_main(MBM);
