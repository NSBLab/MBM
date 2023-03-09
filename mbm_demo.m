%              ********************************************
%         ********************************************************
%         *               Mode-based Morphometry                 *
%         *                       Trang Cao                      *
%         *           Neural Systems and Behaviour Lab           *
%         *                   Monash University                  *
%         *                         2022                         *
%         ********************************************************
%% ---------------------------<< INTRODUCTION >>---------------------------
% Demo code for mapping cortical thickness difference using MBM

%% --------------------------<< INITIALIZATION >>--------------------------
clear all
close all

%global MBM

tempList = regexp(fileread(fullfile('data', 'map_list.txt')), '\n', 'split');
MBM.maps.anatList = fullfile('data','thick',tempList(1:length(tempList)-1)); % path to map list, removed the last empty line when reading the file
MBM.maps.maskFile = fullfile('data','mask_S1200.L.midthickness_MSMAll.32k_fs_LR.txt'); % path to mask

MBM.stat.test = 'two sample'; % stat test
MBM.stat.indicatorMatrix = fullfile('data','G_mat.txt'); % path to indicator matrix

MBM.stat.nPer = 10; % number of permutations
MBM.stat.pThr = 0.1; % threshold for tail approx
MBM.stat.thres = 0.05; % statistical threshold to be considered significant
MBM.stat.fdr = false; % FDR correction

MBM.eig.eigFile = fullfile('data', 'evec_501_masked_S1200.L.midthickness_MSMAll.32k_fs_LR.txt'); % path to eigenmode file
MBM.eig.nEigenmode = 150; % number of eigenmodes

MBM.plot.vis = true; % visualise results
MBM.plot.vtk = fullfile('data','fsLR_32k_midthickness-lh.vtk'); % path to vtk file
MBM.plot.hemis = 'left'; % hemisphere
MBM.plot.nInfluentialMode = 6; % number of most influential modes to be plot

%%save fig

MBM = mbm_main(MBM);
