%% to create two groups with the same number of subjects for one way anova test

clear all
close all

wdir = pwd();
dataDir = fullfile(wdir, 'data', 'demo_2');

% read the list of filenames that have unequal numbers of subjects
mapUnequalGroup = table2cell(readtable(fullfile(dataDir,'map_filename_ANCOVA.txt'), 'delimiter', '\t', 'ReadVariableNames', false));

% read the design matrix that have unequal numbers of subjects
designMatrixUnequal = readmatrix(fullfile(dataDir, 'G_two_sample.txt'));

% index of subjects in each group
iHC = find(designMatrixUnequal(:,1)==1);
iP = find(designMatrixUnequal(:,2)==1);

% number of subject per group to use
nPerGroup = min([length(iHC),length(iP)]);

% list of filenames that have equal numbers of subjects
mapEqualGroup = [mapUnequalGroup(iHC(1:nPerGroup)); mapUnequalGroup(iP(1:nPerGroup))];
writelines(fullfile(dataDir, 'thickness', mapEqualGroup), fullfile(dataDir, 'map_full_path_onewayANOVA.txt'));

% design matrix that have equal numbers of subjects
designMatrixEqual = [designMatrixUnequal(iHC(1:nPerGroup),:); designMatrixUnequal(iP(1:nPerGroup),:)];
writematrix(designMatrixEqual, fullfile(dataDir, 'G_one_way_ANOVA.txt'));
