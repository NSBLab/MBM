function [inputMap, MBM, varargout] = mbm_read_inputs(MBM, varargin)
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

% read anatomical maps

[filepath,name,ext] = fileparts(MBM.maps.anatListFile);
dumvar = 1; %to use break in while
while dumvar
    switch char(ext)
        case '.txt'
            anatList = table2cell(readtable(MBM.maps.anatListFile, 'delimiter', '\t', 'ReadVariableNames', false));   % text file comprise the list of paths to the anatomical maps
            inputMap = mbm_read_map(anatList);

        case '.mat'
            mapFile = load(MBM.maps.anatListFile);
            fieldF = fieldnames(mapFile);
            inputMap = getfield(mapFile,char(fieldF));

        case '.mgh'
            inputMap = squeeze(load_mgh(MBM.maps.anatListFile));
            inputMap = inputMap';
        otherwise
            if isempty(varargin) % varargin indicates of app usage
                error('Not supported format of input maps');
            else
                msgbox('Not supported format of input maps');
                varargout{1} = true; % report error
                break
            end
    end

    % read design matrix

    MBM.stat.designMatrix = readmatrix(MBM.stat.designFile);   % design matrix [m subjects x k effects]


    % read mask
    MBM.maps.mask = readmatrix(MBM.maps.maskFile);
    if size(MBM.maps.mask, 1) == size(inputMap, 2)
        MBM.maps.mask = MBM.maps.mask';
    end

    % read eigenmodes
    switch MBM.eig.eigFile(end-3:end)
        case '.mat'
            st = load(MBM.eig.eigFile);
            MBM.eig.eig = st.eig;
        case '.txt'
            MBM.eig.eig = readmatrix(MBM.eig.eigFile);
        otherwise
            if isempty(varargin) % varargin indicates app usage

                error('Not supported format of eigenmode file');
            else
                msgbox('Not supported format of input maps');
                varargout{1} = true; % report error
                break
            end
    end
    dumvar = 0;
end

if ~isempty(varargin) % varargin indicates app usage
    varargout{1} = false; % report error
end

end