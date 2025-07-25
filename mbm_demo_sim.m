% Demo code for mapping cortical thickness difference, i.e., two sample t-test, using MBM.
%
% This demo uses the thickness maps generated by the framework described in
% the MBM paper. In particular, 25 maps were generated from each of the two
% ground truths. The list of the paths of the maps stored in 'thickness'
% folder is in 'inputMaps_filename.txt'. 'mbm_demo_prerequisite.m' needs to be run before running this demo 
% in order to generate 'inputMaps_full_path.txt' containing the paths to these maps 
% by adding the directory of these files in your local computer to the filenames.
%
% The text file 'mask_S1200.L.midthickness_MSMAll.32k_fs_LR.txt' contains
% a binary mask where values '1' or '0' indicating the vertices of the
% applied maps to be used or removed.
% 
% The design matrix that identifies the two groups of the maps is stored in
% 'G_two_sample.txt'. 
%
% VTK file 'fsLR_32k_midthickness-lh.vtk' contains the surface to plot.
%
% Eigenmodes in columns are in
% 'fsLR_32k_midthickness-lh_emode_150.txt'. Mass matrix is in
% 'fsLR_32k_midthickness-lh_mass_150.txt'.
% 
% All input files are stored in 'data/demo_sim' folder.
%
% Using MBM, we obtain the \beta spectrum, significant pattern that
% comprises the weighted significant modes, and a number of the most influential modes.
%
% This code can also be use to demontrate one way anova test by changing
% MBM.stat.test.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

clear all
close all

rng(2); % set the default seed for random generation to ensure the results are reproducible.

wdir = pwd();
dataDir = fullfile(wdir, 'data', 'demo_sim');

% use a map list
MBM.maps.anatListFile = fullfile(dataDir, 'inputMaps_full_path.txt'); % text file comprise the list of paths to the anatomical maps

MBM.maps.maskFile = fullfile(dataDir, 'mask_S1200.L.midthickness_MSMAll.32k_fs_LR.txt'); % path to mask

% comment the following couple lines for one sample t-test, two sample t-test, or one way ANOVA
% MBM.stat.test = 'one sample'; % statistical test
% MBM.stat.designFile = fullfile(dataDir, 'G_one_sample.txt'); % path to design matrix

MBM.stat.test = 'two sample'; % statistical test
MBM.stat.designFile = fullfile(dataDir, 'G_onewayANOVA_twosample.txt'); % path to design matrix, can try other format 'G_onewayANOVA_twosample.csv'

% MBM.stat.test = 'one way ANOVA'; % statistical test
% MBM.stat.designFile = fullfile(dataDir, 'G_onewayANOVA_twosample.txt'); % path to design matrix, can try other format 'G_onewayANOVA_twosample.csv'

MBM.stat.nPer = 10; % number of permutations
MBM.stat.pThr = 0.1; % threshold for tail estimation
MBM.stat.thres = 0.05; % statistical threshold to be considered significant
MBM.stat.fdr = true; % FDR correction

% comment the two following lines to calculate the eigenmodes from the vtk
% file or do not comment to use the pre-calculated eigenmodes and mass
% matrix.
MBM.eig.eigFile = fullfile(dataDir,'fsLR_32k_midthickness-lh_emode_150.txt'); % path to eigenmode file, available in .txt or .mat
MBM.eig.massFile = fullfile(dataDir,'fsLR_32k_midthickness-lh_mass_150.txt'); % path to mass matrix file, available in .txt or .mat
MBM.eig.nEigenmode = 150; % number of eigenmodes for analysis
MBM.eig.saveResult = true; % save the results, i.e., MBM structure
MBM.eig.resultFile = fullfile(dataDir,'mbm_demo_sim.mat'); % where to save the results

MBM.plot.visualize = true; % visualise the results
MBM.plot.saveFig = true; % save the visualisation of the results
MBM.plot.figFile = fullfile(dataDir, 'demo_sim.fig'); % where to save the visualisation of the results.
MBM.plot.vtkFile = fullfile(dataDir, 'fsLR_32k_midthickness-lh.vtk'); % path to vtk file
MBM.plot.hemis = 'left'; % hemisphere to be analysed
MBM.plot.nInfluentialMode = 6; % number of most influential modes to be plotted

MBM = mbm_main(MBM);
