function MBM = mbm_indi_main(MBM)
% mbm_main is the main function of MBM toolbox which performs MBM analysis
%
%% Input:
% MBM       - Structure
%             MBM.maps    - Structure containing maps. Input fields are:
%                           MBM.maps.anatListFile - Character vector.
%                                                 - Path to either:
%                                                   + a text file comprising the list
%                                                 of paths to the anatomical maps
%                                                 in GIFTI, NIFTI, or .mgh format.
%                                                   + a .mat file
%                                                   containing a matrix
%                                                   whose each row is a map.
%                                                   + a .mgh file
%                                                   containing a 4-D matrix
%                                                   obtained as mri_glmgit
%                                                   output.
%
%                           MBM.maps.maskFile     - Character vector.
%                                                 - Path to a text file containing
%                                                   a binary mask where values '1' or
%                                                   '0' indicate the vertices of the
%                                                   applied maps to be used or removed.
%
%
%             MBM.stat    - Structure of parameters to produce a statistical map from
%                           the input maps for MBM analysis. Input fields are:
%                           MBM.stat.test         - Statistical test to be used:
%                                                 'one sample' one-sample t-test,
%                                                 'two sample' two-sample t-test,
%                                                 'one way ANOVA' one-way ANOVA,
%                                                 'ANCOVA_F' ANCOVA with two groups (f-test).
%                                                 'ANCOVA_Z' ANCOVA with two groups (z-test, producing z-map from FreeSurfer).
%
%                           MBM.stat.designFile    - Character vector.
%                                                  - Path to a text file containing a
%                                                    design matrix [m subjects by k effects].
%                                                  - For the design matrix in the statistical test:
%                                                           'one sample': one column, '1' or '0' indicates a subject in the group or not.
%                                                           'two sample': two columns, '1' or '0' indicates a subject in a group or not.
%                                                           'one way ANOVA': k columns, '1' or '0' indicates a subject in a group or not, number of subjects in each group must be equal.
%                                                           'ANCOVA_F': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%                                                           'ANCOVA_Z': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%
%                           MBM.stat.nPer         - Number
%                                                 - Number of permutations in the
%                                                   statistical test.
%
%                           MBM.stat.pThr         - Number
%                                                 - Threshold of p-values for
%                                                   tail approximation. If the
%                                                   p-values are below MBM.stat.pThr,
%                                                   these are refined further using a
%                                                   tail approximation from the
%                                                   Generalise Pareto Distribution (GPD).
%
%                           MBM.stat.thres        - Number
%                                                 - Threshold of p-values for
%                                                   being significant. When the
%                                                   p-value is below MBM.stat.thres,
%                                                   the statitical test is considered
%                                                   significant.
%
%                           MBM.stat.fdr          - Option ('true' or 'false') to
%                                                   correct multiple test with FDR or not.
%
%             MBM.eig     - Structure of MBM variables. Input fields are:
%                           MBM.eig.eigFile       - Character vector.
%                                                 - Path to a text file or .mat file containing
%                                                   eigenmodes in columns.
%                                                   If you do not have
%                                                   precalculated
%                                                   eigenmodes, this input
%                                                   can be omitted but
%                                                   MBM.plot.vtkFile is
%                                                   required. The code will
%                                                   calculate the
%                                                   eigenmodes from the
%                                                   surface given in
%                                                   MBM.plot.vtkFile.
%
%                           MBM.eig.massFile      - Character vector.
%                                                 - Path to a text file or .mat file containing
%                                                   the mass matrix when
%                                                   calculating the
%                                                   eigenmodes. See
%                                                   https://github.com/Deep-MI/LaPy
%                                                   and the reference
%                                                   papers to understand
%                                                   what is a mass matrix
%                                                   and how eigenmodes are
%                                                   calculated. If you do not have
%                                                   precalculated
%                                                   eigenmodes, this input
%                                                   can be omitted but
%                                                   MBM.plot.vtkFile is
%                                                   required. The code will
%                                                   calculate the mass
%                                                   matrix and
%                                                   eigenmodes from the
%                                                   surface given in
%                                                   MBM.plot.vtkFile.
%
%                           MBM.eig.nEigenmode    - Number
%                                                 - Number of eigenmodes to be used.
%
%
%                           MBM.eig.saveResult    - Option ('true' or 'false') to
%                                                   save the results, i.e., MBM
%                                                   structure.
%
%                           MBM.eig.resultFile    - Character vector.
%                                                 - Filename including path to save
%                                                   results.
%
%             MBM.plot    - Structure of parameters for plotting. Input fields are:
%
%                           MBM.plot.vtkFile      - Character vector.
%                                                 - Path to a vtk file containing a
%                                                   surface used to calculate the eigemodes and/or plot the results.
%
%                           MBM.plot.visualize    - Option ('true' or 'false') to
%                                                   visualize the results.
%
%                           MBM.plot.saveFig      - Option ('true' or 'false') to
%                                                   save the visualisation of the results.
%
%                           MBM.plot.figFile      - Character vector.
%                                                 - Filename including path to
%                                                   save the visualisation of the results.
%                                                 - File formats supported
%                                                 by 'saveas' in Matlab
%                                                 such as .fig .png .jpg
%                                                 .eps...
%
%                           MBM.plot.hemis        - 'left' or 'right' to visialise left or
%                                                   right hemisphere.
%
%                           MBM.plot.nInfluentialMode    - Number
%                                                        - Number of the most influential
%                                                          modes to plot.
%
%% Output:
% MBM       - Structure contains the following output fields:
%
%             MBM.maps    - MBM.maps.mask         - Vector of the binary mask.
%
%             MBM.stat    - Structure of parameters to produce a statistical map from
%                           the input maps for MBM analysis. Output fields are:
%
%                           MBM.stat.designMatrix  - Design matrix [m subjects by k effects].
%                                                  - For the design matrix in the statistical test:
%                                                           'one sample': one column, '1' or '0' indicates a subject in the group or not.
%                                                           'two sample': two columns, '1' or '0' indicates a subject in a group or not.
%                                                           'one way ANOVA': k columns, '1' or '0' indicates a subject in a group or not, number of subjects in each group must be equal.
%                                                           'ANCOVA_F': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%                                                           'ANCOVA_Z': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%
%
%                           MBM.stat.statMap      - Vector of a statistical map.
%
%                           MBM.stat.pMap         - Vector of p-values of the
%                                                   statistical map.
%
%                           MBM.stat.revMap       - Vector of "false" or "true"
%                                                   indicating the observed value of an
%                                                   element in the statistical map on
%                                                   the right or left tail of the null
%                                                   distribution.
%
%                           MBM.stat.thresMap     - Vector of a thresholded map.
%
%             MBM.eig     - Structure of MBM variables. Output fields are:
%                           MBM.eig.beta          - Vector of beta spectrum.
%
%                           MBM.eig.pBeta         - Vector of p-values of the
%                                                   beta spectrum.
%
%                           MBM.eig.revBeta       - Vector of "false" or "true"
%                                                   indicating the observed value of an
%                                                   element in the beta spectrum on
%                                                   the right or left tail of the null
%                                                   distribution.
%
%                           MBM.eig.significantBeta      - Vector of significant betas.
%
%                           MBM.eig.eig           - Matrix of columns of eigenmodes.
%
%                           MBM.eig.mass          - Mass matrix.
%
%                           MBM.eig.reconMap      - Vector of significant pattern.
%
%                           MBM.eig.betaOrder     - Vector of influential order.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

%% initialisation
% addpath to the included packages or modify the path to the packages in your system
currentPath = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(currentPath,'func')))
addpath(fullfile(currentPath,'utils'))
addpath(fullfile(currentPath,'utils','modes'))
addpath(fullfile(currentPath,'utils','fdr_bh'))
addpath(fullfile(currentPath,'utils','PALM-master'))
addpath(fullfile(currentPath,'utils','gifti-matlab'))


% check input
mbm_check_input(MBM);

% read inputs from paths
[inputMap, MBM] = mbm_read_inputs(MBM);
mbm_check_read_inputs(MBM, inputMap);

% remove the unused vertices, e.g., the medial wall
inputMap = inputMap(:, MBM.maps.mask == 1);
MBM.eig.eig = MBM.eig.eig(MBM.maps.mask == 1, 1:MBM.eig.nEigenmode);
MBM.eig.mass = MBM.eig.mass(MBM.maps.mask == 1, MBM.maps.mask == 1);

%% MBM
% normalize the eigenmodes
MBM.eig.eig = mbm_normalize_eig(MBM.eig.eig, MBM.eig.nEigenmode);

% eigenmode decomposision
MBM.eig.indiBeta = calc_eigendecomposition(inputMap', MBM.eig.eig, 'orthogonal', MBM.eig.mass);
MBM.eig.indiBeta = MBM.eig.indiBeta';

% reconstructe individual maps
reconMap = MBM.eig.indiBeta * MBM.eig.eig';

% calculate statistical map
MBM.stat.statMap = mbm_stat_map(reconMap, MBM.stat);

% permutation tests on the statitical map
[statMapNull, MBM.stat.pMap, MBM.stat.revMap] = mbm_perm_test_map(reconMap, MBM.stat, MBM.stat.statMap);

% thresholded map
MBM.stat.thresMap = sign(MBM.stat.statMap);
MBM.stat.thresMap(MBM.stat.pMap > MBM.stat.thres) = 0;


%% plotting
if MBM.plot.visualize == 1

   plot_brain_map_mask( MBM.stat.thresMap)
        % save the result figure
        if isfield(MBM.plot,'saveFig') & MBM.plot.saveFig == 1
            saveas(gcf, MBM.plot.figFile);
        end
end

%% saving results
if MBM.eig.saveResult == 1
    save(MBM.eig.resultFile, 'MBM');
end

end