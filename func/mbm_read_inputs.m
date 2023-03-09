function [input_maps, indicatorMatrix] = mbm_read_inputs()
% read inputs from paths
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022
global MBM

input_maps = read_gifti_map(MBM.maps.anatList);

indicatorMatrix = readmatrix(MBM.stat.indicatorMatrix);   % group indicator matrix [m subjects x k groups]: each column is a group and 1 indicates a subject in a group
if size(indicatorMatrix,1) ~= size(input_maps,1)
    error('Error. Numbers of subjects in the indicator matrix and input maps are different.');
end

MBM.maps.mask = readmatrix(MBM.maps.maskFile);
if size(MBM.maps.mask,1) ~= size(input_maps,2) & size(MBM.maps.mask,2) ~= size(input_maps,2)
    error('Error. Mask size is different from map size.');
elseif size(MBM.maps.mask,1) == size(input_maps,2)
    MBM.maps.mask = MBM.maps.mask';
end

MBM.eig.eig = readmatrix(MBM.eig.eigFile);
if size(MBM.eig.eig,1) ~= max(size(MBM.maps.mask))
    error('Error. Eigenmodes should be in columns with length compatible with that of the mask.')
end

end