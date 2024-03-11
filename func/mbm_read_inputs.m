function [inputMap, MBM] = mbm_read_inputs(MBM, varargin)
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
if ~isempty(varargin)
    fig = varargin{1};
end

% read anatomical maps
if isfield(MBM, 'maps')==0 | isfield(MBM.maps, 'anatListFile') == 0 | strcmp(MBM.maps.anatListFile,fullfile(0,0))

    if isempty(varargin)
        error('No input maps');
    else
        % change progress bar back to run button
        app.MaplistButton.Text = 'Map list';

        uialert(fig, 'No input maps', 'err');
        uiwait(fig)
    end
end

[filepath,name,ext] = fileparts(MBM.maps.anatListFile);

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
        error('Not supported format of input maps');
end

% read design matrix
if isfield(MBM.stat, 'designFile') == 0 | strcmp(MBM.stat.designFile,fullfile(0,0))
    if isempty(varargin)
        error('No designMatrix');
    else
        uialert(fig, 'No design matrix', 'err');
        uiwait(fig)
    end
end
MBM.stat.designMatrix = readmatrix(MBM.stat.designFile);   % design matrix [m subjects x k effects]
if size(MBM.stat.designMatrix, 1) ~= size(inputMap, 1)

    error('Error. Numbers of subjects in the design matrix and input maps are different.');

end

% read mask
MBM.maps.mask = readmatrix(MBM.maps.maskFile);
if size(MBM.maps.mask, 1) ~= size(inputMap, 2) & size(MBM.maps.mask, 2) ~= size(inputMap, 2)
    error('Error. Mask size is different from map size.');

elseif size(MBM.maps.mask, 1) == size(inputMap, 2)
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
        error('Not supported format of eigenmode file');
end
if size(MBM.eig.eig, 1) ~= max(size(MBM.maps.mask))
    error('Error. Eigenmodes should be in columns with length compatible with that of the mask.')

end

end