function errReturn = mbm_check_read_inputs_app(MBM, inputMap)
% Check read inputs are compatable with each other.
%
%% Input:
% MBM         - structure having the fields:
%             MBM.maps.anatListFile     - Character vector.
%                                       - Path to either:
%                                         + a text file comprising the list
%                                         of paths to the anatomical maps
%                                         in GIFTI, NIFTI, or .mgh format.
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
%                                                           'ANCOVA_F': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%                                                           'ANCOVA_Z': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%
%             MBM.eig.eig               - Matrix of columns of eigenmodes.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

% input UIFigure when using the app


errReturn = false;
dumvar = 1; %to use break in while
while dumvar
    if size(MBM.stat.designMatrix, 1) ~= size(inputMap, 1)

        msgbox('Error. Numbers of subjects in the design matrix and input maps are different.');

        errReturn = true;
        break
    end

    switch MBM.stat.test

        case 'one sample'
            if size(MBM.stat.designMatrix,2) ~= 1

                msgbox('Design matrix for one sample t-test must have one column.');
                errReturn = true;
                break
            end

        case 'two sample'
            if size(MBM.stat.designMatrix,2) ~= 2

                msgbox('The design matrix for two sample t-test must have two columns.');
                errReturn = true;
                break
            end
        case 'one way ANOVA'

            if size(MBM.stat.designMatrix,2)==1
                msgbox('The design matrix for one way ANOVA must have at least two columns (two groups).');
                errReturn = true;
                break
            end
            for iCol = 2:size(MBM.stat.designMatrix,2)
                if sum(MBM.stat.designMatrix(:,iCol-1) == 1) ~= sum(MBM.stat.designMatrix(:,iCol) == 1)

                    msgbox('Numbers of subjects in each group are different.');
                    errReturn = true;
                    break
                end

            end
    end

    if size(MBM.maps.mask, 1) ~= size(inputMap, 2) & size(MBM.maps.mask, 2) ~= size(inputMap, 2)
        msgbox('Error. Mask size is different from map size.');

        errReturn = true;
        break

    end
    if size(MBM.eig.eig, 1) ~= max(size(MBM.maps.mask))
        msgbox('Error. Eigenmodes should be in columns with length compatible with that of the mask.')

        errReturn = true;
        break
    end
    dumvar = 0;
end
end