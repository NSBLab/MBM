function [statMap_null] = mbm_perm_test_map(input_maps, indicatorMatrix)
% permutation tests on the statitical map
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022
global MBM

[N_sub,N_vertice] = size(input_maps);  % number of subjects and number of vertices after removing the medial wall

statMap_null = zeros(MBM.stat.nPer, size(input_maps,2)); % preallocation space

for i=1:MBM.stat.nPer
    
    if MBM.stat.test == 'one sample'
        
        % null input maps
        input_maps_null = input_maps.*sign(rand(N_sub,1)-0.5);
        
    else
        
        %suffling the labels of the groups
        nu_in = randperm(N_sub);
        
        % null input maps
        input_maps_null = input_maps(nu_in,:);
        
    end
    
    % statistical map of the null inputs
    statMap_null(i,:) = mbm_statMap(input_maps_null,indicatorMatrix,MBM.stat.test);
    
end

% calculate p-value of the t-map and obtain the thresholded map
for ii=1:N_vertice
    
    [MBM.stat.pMap(ii), MBM.stat.revMap(ii)] = p_val_tail_est(statMap_null(:,ii), MBM.stat.statMap(ii), MBM.stat.pThr); % MBM.stat.revMap with value "false" or "true" indicates the observed value is on the right or left tail of the null distribution.
    
end

% correction with fdr if wishing
if MBM.stat.fdr == 1
    [h, crit_p, adj_ci_cvrg, MBM.stat.pMap] = fdr_bh(MBM.stat.pMap,MBM.stat.thres,'pdep');
end

end
