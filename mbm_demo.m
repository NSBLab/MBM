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

global MBM

temp_list = regexp(fileread(fullfile('data','map_list.txt')),'\n','split');
MBM.maps.anat_list = fullfile('data','thick',temp_list(1:length(temp_list)-1)); % path to map list, removed the last empty line when reading the file
MBM.maps.mask_file = fullfile('data','mask_S1200.L.midthickness_MSMAll.32k_fs_LR.txt'); % path to mask

MBM.stat.test = 'two sample'; % stat test
MBM.stat.G = fullfile('data','G_mat.txt'); % path to indicator matrix

MBM.stat.N_per = 10; % number of permutations
MBM.stat.Pthr = 0.1; % threshold for tail approx
MBM.stat.thres = 0.05; % statistical threshold to be considered significant
MBM.stat.fdr = false; % FDR correction

MBM.eig.eig_file = fullfile('data', 'evec_501_masked_S1200.L.midthickness_MSMAll.32k_fs_LR.txt'); % path to eigenmode file
MBM.eig.N_eig = 150; % number of eigenmodes

MBM.plot.vis = true; % visualise results
MBM.plot.vtk = fullfile('data','fsLR_32k_midthickness-lh.vtk'); % path to vtk file
MBM.plot.hemis = 'left'; % hemisphere
MBM.plot.N_influ = 6; % number of most influential modes to be plot

%%save fig

MBM=mbm_main(MBM);
