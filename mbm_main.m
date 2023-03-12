function MBM = mbm_main(MBM)
% mbm_main is the main function of mbm which performs MBM analysis on the
% input structure MBM. The outputs are then stored in the structure MBM.
%
% A MBM structure contains the following required fields:
%   MBM.maps    - Structure containing maps. Fields are:
%                 MBM.maps.anatList    - Cell array of character
%                                       vectors.
%                                       - Each array element contains the
%                                       path to an input anatomical map in
%                                       a GIFTI file.
%
%                 MBM.maps.maskFile    - Character vector 
%                                       - Path to a text file containing
%                                       a mask where values 1 or 0
%                                       indicating the vertices of the
%                                       applied maps to be used or removed.
%
%                 MBM.maps.mask         - Vector of the mask
%
%   MBM.stat    - Structure of parameters to produce a statistical map from
%               the input maps for MBM analysis. Fields are:
%                 MBM.stat.test         - Statistical test to be used:
%                                       'one sample' one-sample t-test,
%                                       'two sample' two-sample t-test, 
%                                       'one way ANOVA' one-way ANOVA.          
%
%                 MBM.stat.indicatorMatrix            - Character vector 
%                                       - Path to a text file containing
%                                       group indicator matrix [m
%                                       subjects by k groups]
%                                       - '1' or '0' indicates a subject in
%                                       a group or not.
%
%                 MBM.stat.nPer        - Number of permutations in the
%                                       statistical test.
%
%                 MBM.stat.pThr         - Threshold of p-values. If the
%                                       p-values are below MBM.stat.pThr,
%                                       these are refined further using a
%                                       tail approximation from the
%                                       Generalise Pareto Distribution (GPD).
%
%                 MBM.stat.thres        - Threshold of p-values. When the 
%                                       p-values are below MBM.stat.thres, 
%                                       the statitical test is considered 
%                                       significant.     
%
%                 MBM.stat.fdr          - Option ('true' or 'false') to
%                                       correct multiple test with FDR or not.
%
%   MBM.eig     - Structure of MBM variables. Fields are:
%                 MBM.eig.eigFile           - Path to a text file containing
%                                       eigenmodes in columns.
%   
%                 MBM.eig.nEigenmode         - Number of eigenmodes to be used
%
%   MBM.plot    - Structure of parameters for plotting. Fields are:
%                 MBM.plot.vis          - Option ('true' or 'false') to
%                                       visualize the results.
%
%                 MBM.plot.vtk          - Path to a vtk file containing a
%                                       surface to plot.
%
%                 MBM.plot.hemis        - 'left' or 'right' to visialise left or 
%                                       right hemisphere.
%
%                 MBM.plot.nInfluentialMode      - Number of the most influential 
%                                       modes to be plot
%
%
% A MBM structure contains the following output fields:
%   MBM.stat    - Structure of parameters to produce a statistical map from
%               the input maps for MBM analysis. Output fields are:
%                 MBM.stat.statMap     - Vector of a statistical map
%
%                 MBM.stat.pMap        - Vector of p-values of the
%                                       statistical map
%
%                 MBM.stat.revMap      - Vector of "false" or "true"
%                                       indicating the observed value of an 
%                                       element in the statistical map on
%                                       the right or left tail of the null
%                                       distribution.
%
%                 MBM.stat.thresMap     - Vector of a thresholded map
%
%   MBM.eig     - Structure of MBM variables. Output fields are: 
%                 MBM.eig.beta          - Vector of beta spectrum
%
%                 MBM.eig.pBeta        - Vector of p-values of the
%                                       beta spectrum.
%
%                 MBM.eig.revBeta      - Vector of "false" or "true"
%                                       indicating the observed value of an 
%                                       element in the beta spectrum on
%                                       the right or left tail of the null
%                                       distribution.                 
%
%                 MBM.eig.significantBeta      - Vector of significant betas
%
%                 MBM.eig.eig           - Matrix with columns of normalised
%                                       eigenmodes
%
%                 MBM.eig.reconMap     - Vector of significant patterns
%
%                 MBM.eig.betaOrder    - Vector of influential order
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

%% initialisation
%global MBM

addpath('func')
addpath(fullfile('utils','gifti-matlab'))
addpath(fullfile('utils','PALM-master'))
addpath(fullfile('utils','fdr_bh'))

% read inputs from paths
[inputMap, indicatorMatrix, MBM] = mbm_read_inputs(MBM);

% remove the unused vertices, e.g., the medial wall
inputMap = inputMap(:, MBM.maps.mask == 1);
MBM.eig.eig = MBM.eig.eig(MBM.maps.mask == 1, 1:MBM.eig.nEigenmode);

%% SBM
% calculate statistical map
MBM.stat.statMap = mbm_stat_map(inputMap, indicatorMatrix, MBM.stat.test);

% permutation tests on the statitical map
[statMapNull, MBM] = mbm_perm_test_map(inputMap, indicatorMatrix, MBM);

% thresholded map
MBM.stat.thresMap = sign(MBM.stat.statMap);
MBM.stat.thresMap(MBM.stat.pMap >= MBM.stat.thres) = 0;

%% MBM
% normalize the eigenmodes
MBM.eig.eig = mbm_normalize_eig(MBM.eig.eig, MBM.eig.nEigenmode);

% eigenmode decomposision
MBM.eig.beta = mbm_eigen_decompose(MBM.stat.statMap, MBM.eig.eig);

% permutation tests on the beta spectrum
MBM = mbm_perm_test_beta(statMapNull, MBM);

% significant betas
MBM.eig.significantBeta = MBM.eig.beta;
MBM.eig.significantBeta(MBM.eig.pBeta >= MBM.stat.thres) = 0;

% sort significant beta
[betaSorted, MBM.eig.betaOrder] = sort(abs(MBM.eig.significantBeta), 'descend');

% sigificant patterns
MBM.eig.reconMap = MBM.eig.significantBeta * MBM.eig.eig';  

%% plotting
if MBM.plot.vis == 1
    mbm_plot(MBM)
end

end