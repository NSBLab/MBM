function [stat_map_null] = mbm_perm_test_map(input_maps, G)
% permutation tests on the statitical map
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022
global MBM

[N_sub,N_vertice] = size(input_maps);  % number of subjects and number of vertices after removing the medial wall

stat_map_null = zeros(MBM.stat.N_per, size(input_maps,2)); % preallocation space

for i=1:MBM.stat.N_per
    
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
    stat_map_null(i,:) = mbm_stat_map(input_maps_null,G,MBM.stat.test);
    
end

% calculate p-value of the t-map and obtain the thresholded map
for ii=1:N_vertice
    
    [MBM.stat.p_map(ii), MBM.stat.rev_map(ii)] = p_val_tail_est(stat_map_null(:,ii), MBM.stat.stat_map(ii), MBM.stat.Pthr); % MBM.stat.rev_map with value "false" or "true" indicates the observed value is on the right or left tail of the null distribution.
    
end

% correction with fdr if wishing
if MBM.stat.fdr == 1
    [h, crit_p, adj_ci_cvrg, MBM.stat.p_map] = fdr_bh(MBM.stat.p_map,MBM.stat.thres,'pdep');
end

end
