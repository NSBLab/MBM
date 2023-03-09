function [input_maps, G] = mbm_read_inputs()
% read inputs from paths
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022
global MBM

input_maps = read_gifti_map(MBM.maps.anat_list);

G = readmatrix(MBM.stat.G);   % group indicator matrix [m subjects x k groups]: each column is a group and 1 indicates a subject in a group
if size(G,1) ~= size(input_maps,1)
    error('Error. Numbers of subjects in the indicator matrix and input maps are different.');
end

MBM.maps.mask = readmatrix(MBM.maps.mask_file);
if size(MBM.maps.mask,1) ~= size(input_maps,2) & size(MBM.maps.mask,2) ~= size(input_maps,2)
    error('Error. Mask size is different from map size.');
elseif size(MBM.maps.mask,1) == size(input_maps,2)
    MBM.maps.mask = MBM.maps.mask';
end

MBM.eig.eig = readmatrix(MBM.eig.eig_file);
if size(MBM.eig.eig,1) ~= max(size(MBM.maps.mask))
    error('Error. Eigenmodes should be in columns with length compatible with that of the mask.')
end

end