function MBM = mbm_main(MBM)
% mbm_main is the main function of MBM toolbox which performs MBM analysis
%
%% Input: 
% MBM       - Structure
%             MBM.maps    - Structure containing maps. Input fields are:
%                           MBM.maps.anatListFile - Character vector.
%                                                 - Path to either:
%                                                   + a text file comprising the list
%                                                 of paths to the anatomical maps
%                                                 in GIFTI or .mgh format. 
%                                                   + a .mat file
%                                                   containing a matrix
%                                                   whose each row is a map.
%                                                   + a .mgh file
%                                                   containing a matrix
%                                                   whose each row is a
%                                                   map. (can be obtained
%                                                   from freesurfer
%                                                   mri_glmgit output)
%
%                           MBM.maps.maskFile     - Character vector.
%                                                 - Path to a text file containing
%                                                   a binary mask where values '1' or
%                                                   '0' indicating the vertices of the
%                                                   applied maps to be used or removed.file:///home/trangc/kg98/trangc/MBM/mbm_app.mlapp
%
%
%             MBM.stat    - Structure of parameters to produce a statistical map from
%                           the input maps for MBM analysis. Input fields are:
%                           MBM.stat.test         - Statistical test to be used:
%                                                 'one sample' one-sample t-test,
%                                                 'two sample' two-sample t-test, 
%                                                 'one way ANOVA' one-way ANOVA,
%                                                 'ANCOVA' ANCOVA with two groups (f-test).          
%
%                           MBM.stat.designFile    - Character vector. 
%                                                  - Path to a text file containing a
%                                                    design matrix [m subjects by k effects]. 
%                                                  - For the design matrix in the statistical test:
%                                                           'one sample': one column, '1' or '0' indicates a subject in the group or not.
%                                                           'two sample': two columns, '1' or '0' indicates a subject in a group or not.
%                                                           'one way ANOVA': k columns, '1' or '0' indicates a subject in a group or not, number of subjects in each group must be equal.
%                                                           'ANCOVA': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
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
%                                                 - Path to a text file containing
%                                                   eigenmodes in columns.
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
%                           MBM.plot.vtkFile      - Character vector.
%                                                 - Path to a vtk file containing a
%                                                   surface to plot.
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
%                                                           'ANCOVA': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
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
%                           MBM.eig.reconMap      - Vector of significant pattern.
%
%                           MBM.eig.betaOrder     - Vector of influential order.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

%% initialisation
% addpath to the included packages or modify the path to the packages in your system
currentPath = fileparts(mfilename('fullpath'));
addpath(fullfile(currentPath,'func'))
addpath(fullfile(currentPath,'utils'))
addpath(fullfile(currentPath,'utils','gifti-matlab'))
addpath(fullfile(currentPath, 'utils','PALM-master'))
addpath(fullfile(currentPath, 'utils','fdr_bh'))

% check input
mbm_check_input(MBM);

% read inputs from paths
[inputMap, MBM] = mbm_read_inputs(MBM);
mbm_check_read_inputs(MBM, inputMap);

% remove the unused vertices, e.g., the medial wall
inputMap = inputMap(:, MBM.maps.mask == 1);
MBM.eig.eig = MBM.eig.eig(MBM.maps.mask == 1, 1:MBM.eig.nEigenmode);

%% SBM

% calculate statistical map
MBM.stat.statMap = mbm_stat_map(inputMap, MBM.stat);

% permutation tests on the statitical map
[statMapNull, MBM] = mbm_perm_test_map(inputMap, MBM);

% thresholded map
MBM.stat.thresMap = sign(MBM.stat.statMap);
MBM.stat.thresMap(MBM.stat.pMap > MBM.stat.thres) = 0;

%% MBM
% normalize the eigenmodes
MBM.eig.eig = mbm_normalize_eig(MBM.eig.eig, MBM.eig.nEigenmode);

% eigenmode decomposision
MBM.eig.beta = mbm_eigen_decompose(MBM.stat.statMap, MBM.eig.eig);

% permutation tests on the beta spectrum
MBM = mbm_perm_test_beta(statMapNull, MBM);

% significant betas
MBM.eig.significantBeta = MBM.eig.beta;
MBM.eig.significantBeta(MBM.eig.pBeta > MBM.stat.thres) = 0;

% sort significant beta
[betaSorted, MBM.eig.betaOrder] = sort(abs(MBM.eig.significantBeta), 'descend');

% sigificant pattern
MBM.eig.reconMap = MBM.eig.significantBeta * MBM.eig.eig';  

%% plotting
if MBM.plot.visualize == 1
    mbm_plot(MBM);
    
end

%% saving results
if MBM.eig.saveResult == 1
    save(MBM.eig.resultFile, 'MBM');
end

end