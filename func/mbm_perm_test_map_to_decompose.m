function [statMapNull] = mbm_perm_test_map_to_decompose(inputMap, stat)
% Permutation tests on the statitical map
%
%% Inputs:
% inputMap - Matrix of rows of anatomical maps.
%
% stat   - structure having the input fields:
%       stat.test               - Statistical test to be used:
%                                   'one sample' one-sample t-test,
%                                   'two sample' two-sample t-test,
%                                   'one way ANOVA' one-way ANOVA.
%                                   'ANCOVA_F' ANCOVA with two groups (f-test).
%                                   'ANCOVA_Z' ANCOVA with two groups (z-test, producing z-map from FreeSurfer).
%
%       stat.designMatrix       - Design matrix [m subjects by k effects]. 
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
%       stat.nPer               - Number of permutations in the
%                                   statistical test.
%
%       stat.pThr               - Threshold of p-values. If the
%                                   p-values are below stat.pThr,
%                                   these are refined further using a
%                                   tail approximation from the
%                                   Generalise Pareto Distribution (GPD).
%
%       stat.thres              - Threshold of p-values. When the
%                                   p-value is below stat.thres,
%                                   the statitical test is considered
%                                   significant.
%
%       stat.fdr                - Option ('true' or 'false') to
%                                   correct multiple test with FDR or not.
%
%       observedMap            - Vector of a statistical map.
%
%% Outputs:
% statMapNull   - Matrix of rows of null statistical maps
%
% stat   - structure having the output fields:
%
%       stat.pMap               - Vector of p-values of the
%                                   statistical map.
%
%       stat.revMap             - Vector of "false" or "true"
%                                   indicating the observed value of an
%                                   element in the statistical map on
%                                   the right or left tail of the null
%                                   distribution.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

% only take the controls
inputMap = inputMap(stat.designMatrix(:,1)==1,:);
designMatrix = stat.designMatrix(stat.designMatrix(:,1)==1,:);

[nSub, nVertice] = size(inputMap);  % number of subjects and number of vertices

statMapNull = zeros(stat.nPer, size(inputMap,2)); % preallocation space
for iPer = 1:stat.nPer

    if strcmp(stat.test, 'one sample')

        % null input maps
        inputMapNull = inputMap.* sign(rand(nSub,1) - 0.5);
        statNull = stat;
        statNull.designMatrix = designMatrix;
        % statistical map of the null inputs
        statMapNull(iPer,:) = mbm_stat_map(inputMapNull, stat);

    else

        %suffling the labels of the groups
        iNull = randperm(nSub);
        statNull = stat;
        statNull.designMatrix = designMatrix;
        statNull.designMatrix(iNull(1:floor(nSub/2)),1) = 1;
        statNull.designMatrix(iNull(floor(nSub/2)+1:end),1) = 2;
        % statistical map of the null inputs
        statMapNull(iPer,:) = mbm_stat_map(inputMap, statNull);
    end

end

end
