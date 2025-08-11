% Demo code for mapping cortical thickness difference taking into account covariate of sex and age, i.e., ANCOVA, using MBM.
%
% This demo uses 72 empirical thickness maps from T1 maps in an open
% dataset: https://openneuro.org/datasets/ds002748/versions/1.0.5
% 
% All input files are stored in 'data/demo_book_chapter' folder.
%
% Demographic information is in data/demo_book_chapter/RD/participants.tsv
%
% Cortical thickness maps derived from FreeSurfer are in
% 'data/demo_book_chapter/RD/derivatives/freesurfer'
%
% The text file 'data/demo_book_chapter/RD/derivatives/mbm/fsaverage_164k_cortex-lh_mask.txt' contains
% a binary mask where values '1' or '0' indicating the vertices of the
% applied maps to be used or removed.
%
% VTK file 'data/demo_book_chapter/RD/derivatives/mbm/fsaverage_164k_midthickness-lh.vtk' contains the midthickness surface mesh.
%
% Eigenmodes in columns are in
% 'data/demo_book_chapter/RD/derivatives/mbm/fsaverage_164k_midthickness-lh_emode_200.mat'.
% Mass matrix associating with the eigenmodes is in
% 'data/demo_book_chapter/RD/derivatives/mbm/fsaverage_164k_midthickness-lh_mass_200.mat'.
%
% Using MBM, we obtain the \beta spectrum, significant pattern that
% comprises the weighted significant modes, and a number of the most influential modes.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2025.

clear all
%close all

rng(2); % set the default seed for random generation to ensure the results are reproducible.

wdir = pwd();
dataDir = fullfile(wdir, 'data', 'demo_book_chapter','RD','derivatives','mbm');


%% use a map list
% make the map list file that have the path to thickness maps
participantFile = readtable(fullfile('data','demo_book_chapter','RD','participants.tsv'), 'FileType', 'text', 'Delimiter', '\t','VariableNamingRule','preserve');
MBM.maps.anatListFile = fullfile(dataDir, 'inputMaps_full_path.txt'); % text file comprise the list of paths to the anatomical maps
writelines(fullfile(wdir, 'data', 'demo_book_chapter','RD','derivatives','freesurfer',participantFile.participant_id, 'surf', 'lh.thickness.fwhm0.fsaverage.mgh'), MBM.maps.anatListFile);

%%
MBM.maps.maskFile = fullfile(dataDir, 'fsaverage_164k_cortex-lh_mask.txt'); % path to mask file

%% statistical test
MBM.stat.test = 'ANCOVA_Z'; % statistical test
% make the design matrix that identifies the two groups of the maps and covariates
metaTable = [ismember(participantFile.group,'depr')+1, participantFile.age, ismember(participantFile.gender,'m')];
MBM.stat.designFile = fullfile(dataDir, 'mbmDesignMat.txt'); % path to design matrix
writematrix(metaTable,MBM.stat.designFile);

MBM.stat.nPer = 10; % number of permutations
MBM.stat.pThr = 0.1; % threshold for tail estimation
MBM.stat.thres = 0.05; % statistical threshold to be considered significant
MBM.stat.fdr = false; % FDR correction

% comment the two following lines to calculate the eigenmodes from the vtk
% file or do not comment to use the pre-calculated eigenmodes and mass
% matrix.
MBM.eig.eigFile = fullfile(dataDir, 'fsaverage_164k_midthickness-lh_emode_200.mat'); % path to eigenmode file
MBM.eig.massFile = fullfile(dataDir, 'fsaverage_164k_midthickness-lh_mass_200.mat'); % path to eigenmode file
MBM.eig.nEigenmode = 200; % number of eigenmodes for analysis
MBM.eig.saveResult = true; % save the results, i.e., MBM structure
MBM.eig.resultFile = fullfile(dataDir,['mbm_demo_book_chapter.mat']); % folder where to save the results

MBM.plot.visualize = true; % visualise the results
MBM.plot.saveFig = false; % save the visualisation of the results
MBM.plot.figFile = fullfile(dataDir, 'mbm_demo_book_chapter.fig'); % where to save the visualisation of the results.
MBM.plot.vtkFile = fullfile(dataDir, 'fsaverage_164k_midthickness-lh.vtk'); % path to vtk file
MBM.plot.hemis = 'left'; % hemisphere to be analysed
MBM.plot.nInfluentialMode = 5; % number of most influential modes to be plotted

MBM = mbm_main(MBM);
