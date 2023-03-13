function [inputMap, MBM] = mbm_read_inputs(MBM)
% Read inputs for analysis from file paths given in MBM. 
% 
%% Input:    
% MBM         - structure having the fields:
%             MBM.maps.anatList         - Cell array of character vectors.
%                                       - Each array element contains the path to
%                                       an input anatomical map in a GIFTI file.
%
%             MBM.maps.maskFile         - Character vector.
%                                       - Path to a text file containing
%                                       a binary mask where values '1' or
%                                       '0' indicating the vertices of the
%                                       applied maps to be used or removed.
%
%             MBM.stat.indicatorFile    - Character vector. 
%                                       - Path to a text file containing
%                                       group indicator matrix [m
%                                       subjects by k groups].
%
%             MBM.eig.eigFile           - Path to a text file containing
%                                       eigenmodes in columns.
%
%% Outputs:  
% inputMap    - Matrix of rows of anatomical maps.
%
% MBM         - structure having the fields:
%             MBM.maps.mask             - Vector of the binary mask.
%
%             MBM.stat.indicatorMatrix  - Indicator matrix [m subjects
%                                       by k groups].
%                                       - '1' or '0' indicates a subject in
%                                       a group or not.
%
%             MBM.eig.eig               - Matrix of columns of eigenmodes.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

% read anatomical maps
inputMap = read_gifti_map(MBM.maps.anatList);

% read indicator matrix
MBM.stat.indicatorMatrix = readmatrix(MBM.stat.indicatorFile);   % group indicator matrix [m subjects x k groups]: each column is a group and 1 indicates a subject in a group
if size(MBM.stat.indicatorMatrix, 1) ~= size(inputMap, 1)
    error('Error. Numbers of subjects in the indicator matrix and input maps are different.');
end

% read mask
MBM.maps.mask = readmatrix(MBM.maps.maskFile);
if size(MBM.maps.mask, 1) ~= size(inputMap, 2) & size(MBM.maps.mask, 2) ~= size(inputMap, 2)
    error('Error. Mask size is different from map size.');
elseif size(MBM.maps.mask, 1) == size(inputMap, 2)
    MBM.maps.mask = MBM.maps.mask';
end

% read eigenmodes
MBM.eig.eig = readmatrix(MBM.eig.eigFile);
if size(MBM.eig.eig, 1) ~= max(size(MBM.maps.mask))
    error('Error. Eigenmodes should be in columns with length compatible with that of the mask.')
end

end