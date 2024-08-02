% to be run before running the demos in order to identify the location of
% input data on your computer and generate the paths to input data.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

clear all
close all

wdir = pwd();

%% make map list file by adding dataDir
% for demo_sim
dataDir = fullfile(wdir, 'data', 'demo_sim');
maps = table2cell(readtable(fullfile(dataDir,'inputMaps_filename.txt'), 'delimiter', '\t', 'ReadVariableNames', false));
MBM.maps.anatListFile = fullfile(dataDir, 'inputMaps_full_path.txt'); % text file comprise the list of paths to the anatomical maps
writelines(fullfile(dataDir, 'thickness', maps), MBM.maps.anatListFile);

% for demo_emp
dataDir = fullfile(wdir, 'data', 'demo_emp');
maps = table2cell(readtable(fullfile(dataDir,'inputMaps_filename.txt'), 'delimiter', '\t', 'ReadVariableNames', false)); %make map list file by adding dataDir
MBM.maps.anatListFile = fullfile(dataDir, 'inputMaps_full_path_ANCOVA.txt'); % text file comprise the list of paths to the anatomical maps
writelines(fullfile(dataDir, 'thickness', maps), MBM.maps.anatListFile);

mapsANOVA = table2cell(readtable(fullfile(dataDir,'inputMaps_filename_onewayANOVA.txt'), 'delimiter', '\t', 'ReadVariableNames', false)); %make map list file by adding dataDir
MBM.maps.anatListFile = fullfile(dataDir, 'inputMaps_full_path_onewayANOVA.txt'); % text file comprise the list of paths to the anatomical maps
writelines(fullfile(dataDir, 'thickness', mapsANOVA), MBM.maps.anatListFile);
