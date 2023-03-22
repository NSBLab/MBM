function MBM=mbm_main(MBM)
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
%                 MBM.maps.mask_file    - Character vector 
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
%                 MBM.stat.G            - Character vector 
%                                       - Path to a text file containing
%                                       group indicator matrix [m
%                                       subjects by k groups]
%                                       - '1' or '0' indicates a subject in
%                                       a group or not.
%
%                 MBM.stat.N_per        - Number of permutations in the
%                                       statistical test.
%
%                 MBM.stat.Pthr         - Threshold of p-values. If the
%                                       p-values are below MBM.stat.Pthr,
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
%                 MBM.eig.eig_file           - Path to a text file containing
%                                       eigenmodes in columns.
%   
%                 MBM.eig.N_eig         - Number of eigenmodes to be used
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
%                 MBM.plot.N_influ      - Number of the most influential 
%                                       modes to be plot
%
%
% A MBM structure contains the following output fields:
%   MBM.stat    - Structure of parameters to produce a statistical map from
%               the input maps for MBM analysis. Output fields are:
%                 MBM.stat.stat_map     - Vector of a statistical map
%
%                 MBM.stat.p_map        - Vector of p-values of the
%                                       statistical map
%
%                 MBM.stat.rev_map      - Vector of "false" or "true"
%                                       indicating the observed value of an 
%                                       element in the statistical map on
%                                       the right or left tail of the null
%                                       distribution.
%
%                 MBM.stat.thres_map     - Vector of a thresholded map
%
%   MBM.eig     - Structure of MBM variables. Output fields are: 
%                 MBM.eig.beta          - Vector of beta spectrum
%
%                 MBM.eig.p_beta        - Vector of p-values of the
%                                       beta spectrum.
%
%                 MBM.eig.rev_beta      - Vector of "false" or "true"
%                                       indicating the observed value of an 
%                                       element in the beta spectrum on
%                                       the right or left tail of the null
%                                       distribution.                 
%
%                 MBM.eig.sig_beta      - Vector of significant betas
%
%                 MBM.eig.eig           - Matrix with columns of normalised
%                                       eigenmodes
%
%                 MBM.eig.recon_map     - Vector of significant patterns
%
%                 MBM.eig.beta_order    - Vector of influential order
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

%% initialisation
global MBM

addpath('func')
addpath(fullfile('utils','gifti-matlab'))
addpath(fullfile('utils','PALM-master'))
addpath(fullfile('utils','fdr_bh'))

% read inputs from paths
[input_maps, G] = mbm_read_inputs();

% remove the unused vertices, e.g., the medial wall
input_maps = input_maps(:,MBM.maps.mask==1);
MBM.eig.eig = MBM.eig.eig(MBM.maps.mask==1,1:MBM.eig.N_eig);

%% SBM
% calculate statistical map
MBM.stat.stat_map = mbm_stat_map(input_maps,G,MBM.stat.test);

% permutation tests on the statitical map
[stat_map_null] = mbm_perm_test_map(input_maps,G);

% thresholded map
MBM.stat.thres_map = sign(MBM.stat.stat_map);
MBM.stat.thres_map(MBM.stat.p_map >= MBM.stat.thres) = 0;

%% MBM
% normalize the eigenmodes
MBM.eig.eig = mbm_eig_norm(MBM.eig.eig,MBM.eig.N_eig);

% eigenmode decomposision
MBM.eig.beta = mbm_eigen_decomp(MBM.stat.stat_map', MBM.eig.eig);

% permutation tests on the beta spectrum
mbm_perm_test_beta(stat_map_null)

% significant betas
MBM.eig.sig_beta = MBM.eig.beta;
MBM.eig.sig_beta(MBM.eig.p_beta >= MBM.stat.thres) = 0;

% sort significant beta
[beta_sorted, MBM.eig.beta_order] = sort(abs(MBM.eig.sig_beta),'descend');

% sigificant patterns
MBM.eig.recon_map = MBM.eig.sig_beta*MBM.eig.eig';  

%% plotting
if MBM.plot.vis == 1
    mbm_plot(MBM)
end

end