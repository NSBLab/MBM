function mbm_check_read_inputs_app(MBM, inputMap)
% Read inputs for analysis from file paths given in MBM.
%
%% Input:
% MBM         - structure having the fields:
%             MBM.maps.anatListFile     - Character vector.
%                                       - Path to either:
%                                         + a text file comprising the list
%                                         of paths to the anatomical maps
%                                         in GIFTI or .mgh format.
%                                         + a .mat file
%                                         containing a matrix
%                                         whose each row is a map.
%                                         + a .mgh file
%                                         containing a matrix
%                                         whose each row is a
%                                         map. (can be obtained
%                                         from freesurfer
%                                         mri_glmgit output)
%
%             MBM.maps.maskFile         - Character vector.
%                                       - Path to a text file containing
%                                       a binary mask where values '1' or
%                                       '0' indicating the vertices of the
%                                       applied maps to be used or removed.
%
%             MBM.stat.designFile    - Character vector.
%                                       - Path to a text file containing
%                                       design matrix [m
%                                       subjects by k effects].
%
%             MBM.eig.eigFile           - Path to a text file containing
%                                       eigenmodes in columns.
%
%% Outputs:
% inputMap    - Matrix of rows of anatomical maps.
%
% MBM         - structure having the fields:
%
%             MBM.maps.mask             - Vector of the binary mask.
%
%             MBM.stat.designMatrix  - Design matrix [m subjects by k effects].
%                                                  - For the design matrix in the statistical test:
%                                                           'one sample': one column, '1' or '0' indicates a subject in the group or not.
%                                                           'two sample': two columns, '1' or '0' indicates a subject in a group or not.
%                                                           'one way ANOVA': k columns, '1' or '0' indicates a subject in a group or not, number of subjects in each group must be equal.
%                                                           'ANCOVA': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%
%             MBM.eig.eig               - Matrix of columns of eigenmodes.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

% input UIFigure when using the app



if size(MBM.stat.designMatrix, 1) ~= size(inputMap, 1)

    error('Error. Numbers of subjects in the design matrix and input maps are different.');

end



if size(MBM.maps.mask, 1) ~= size(inputMap, 2) & size(MBM.maps.mask, 2) ~= size(inputMap, 2)
    error('Error. Mask size is different from map size.');


end
if size(MBM.eig.eig, 1) ~= max(size(MBM.maps.mask))
    error('Error. Eigenmodes should be in columns with length compatible with that of the mask.')

end

end