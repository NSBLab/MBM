function [statMapNull, MBM] = mbm_perm_test_map(inputMap, MBM)
% Permutation tests on the statitical map
%
%% Inputs:
% inputMap - Matrix of rows of anatomical maps.
%
% MBM   - structure having the input fields:
%       MBM.stat.test               - Statistical test to be used:
%                                   'one sample' one-sample t-test,
%                                   'two sample' two-sample t-test,
%                                   'one way ANOVA' one-way ANOVA.
%                                   'ANCOVA' ANCOVA with two groups (f-test).          
%
%       MBM.stat.designMatrix       - Design matrix [m subjects by k effects]. 
%                                                  - For the design matrix in the statistical test:
%                                                           'one sample': one column, '1' or '0' indicates a subject in the group or not.
%                                                           'two sample': two columns, '1' or '0' indicates a subject in a group or not.
%                                                           'one way ANOVA': k columns, '1' or '0' indicates a subject in a group or not, number of subjects in each group must be equal.
%                                                           'ANCOVA': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%
%       MBM.stat.nPer               - Number of permutations in the
%                                   statistical test.
%
%       MBM.stat.pThr               - Threshold of p-values. If the
%                                   p-values are below MBM.stat.pThr,
%                                   these are refined further using a
%                                   tail approximation from the
%                                   Generalise Pareto Distribution (GPD).
%
%       MBM.stat.thres              - Threshold of p-values. When the
%                                   p-value is below MBM.stat.thres,
%                                   the statitical test is considered
%                                   significant.
%
%       MBM.stat.fdr                - Option ('true' or 'false') to
%                                   correct multiple test with FDR or not.
%
%% Outputs:
% statMapNull   - Matrix of rows of null statistical maps
%
% MBM   - structure having the output fields:
%       MBM.stat.statMap            - Vector of a statistical map.
%
%       MBM.stat.pMap               - Vector of p-values of the
%                                   statistical map.
%
%       MBM.stat.revMap             - Vector of "false" or "true"
%                                   indicating the observed value of an
%                                   element in the statistical map on
%                                   the right or left tail of the null
%                                   distribution.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022

[nSub, nVertice] = size(inputMap);  % number of subjects and number of vertices

statMapNull = zeros(MBM.stat.nPer, size(inputMap,2)); % preallocation space
for iPer = 1:MBM.stat.nPer

    if strcmp(MBM.stat.test, 'one sample')

        % null input maps
        inputMapNull = inputMap.* sign(rand(nSub,1) - 0.5);

        % statistical map of the null inputs
        statMapNull(iPer,:) = mbm_stat_map(inputMapNull, MBM.stat);

    else

        %suffling the labels of the groups
        iNull = randperm(nSub);
        statNull = MBM.stat;
        statNull.designMatrix = MBM.stat.designMatrix(iNull,:);

        % statistical map of the null inputs
        statMapNull(iPer,:) = mbm_stat_map(inputMap, statNull);
    end



    % update progress bar if using app
    if isfield(MBM, 'processRunButtonHandle')==1
        currentProg = min(round((size(MBM.processRunButtonHandle.Icon,2)-2)*...
            (1/10+3/10*iPer/MBM.stat.nPer)),...% as the mbm_main does not have a single loop, we roughly devided the progress by 10, 1/10 for input checking, 3/10 is for this loop
            size(MBM.processRunButtonHandle.Icon,2)-2);
        RGB = MBM.processRunButtonHandle.Icon;
        RGB(2:end-1, 2:currentProg+1, 1) = 0.25391; % (royalblue)
        RGB(2:end-1, 2:currentProg+1, 2) = 0.41016;
        RGB(2:end-1, 2:currentProg+1, 3) = 0.87891;
        MBM.processRunButtonHandle.Icon = RGB;
        pause(0.01)

    end
end

% calculate p-value of the t-map and obtain the thresholded map
for iVertice = 1:nVertice

    [MBM.stat.pMap(iVertice), MBM.stat.revMap(iVertice)] = mbm_estimate_p_val_tail(statMapNull(:,iVertice),...
        MBM.stat.statMap(iVertice), MBM.stat.pThr); % MBM.stat.revMap with value "false" or "true" indicates the observed value is on the right or left tail of the null distribution.

    % update progress bar if using app
    if isfield(MBM, 'processRunButtonHandle')==1
        currentProg = min(round((size(MBM.processRunButtonHandle.Icon,2)-2)*(1/10+3/10+2/10*iVertice/nVertice)),...
            size(MBM.processRunButtonHandle.Icon,2)-2);
        RGB = MBM.processRunButtonHandle.Icon;
        RGB(2:end-1, 2:currentProg+1, 1) = 0.25391; % (royalblue)
        RGB(2:end-1, 2:currentProg+1, 2) = 0.41016;
        RGB(2:end-1, 2:currentProg+1, 3) = 0.87891;
        MBM.processRunButtonHandle.Icon = RGB;
        pause(0.01)
    end
end

% correction with fdr if wishing
if MBM.stat.fdr == 1
    [h, crit_p, adj_ci_cvrg, MBM.stat.pMap] = fdr_bh(MBM.stat.pMap, MBM.stat.thres, 'pdep');
end

end
