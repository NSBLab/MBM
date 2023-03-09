function [statMapNull, MBM] = mbm_perm_test_map(inputMap, indicatorMatrix, MBM)
% permutation tests on the statitical map
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022
%global MBM

[nSub,nVertice] = size(inputMap);  % number of subjects and number of vertices after removing the medial wall

statMapNull = zeros(MBM.stat.nPer, size(inputMap,2)); % preallocation space

for i=1:MBM.stat.nPer
    
    if MBM.stat.test == 'one sample'
        
        % null input maps
        inputMapNull = inputMap.*sign(rand(nSub,1)-0.5);
        
    else
        
        %suffling the labels of the groups
        nu_in = randperm(nSub);
        
        % null input maps
        inputMapNull = inputMap(nu_in,:);
        
    end
    
    % statistical map of the null inputs
    statMapNull(i,:) = mbm_stat_map(inputMapNull,indicatorMatrix,MBM.stat.test);
    
end

% calculate p-value of the t-map and obtain the thresholded map
for ii=1:nVertice
    
    [MBM.stat.pMap(ii), MBM.stat.revMap(ii)] = estimate_p_val_tail(statMapNull(:,ii), MBM.stat.statMap(ii), MBM.stat.pThr); % MBM.stat.revMap with value "false" or "true" indicates the observed value is on the right or left tail of the null distribution.
    
end

% correction with fdr if wishing
if MBM.stat.fdr == 1
    [h, crit_p, adj_ci_cvrg, MBM.stat.pMap] = fdr_bh(MBM.stat.pMap,MBM.stat.thres,'pdep');
end

end
