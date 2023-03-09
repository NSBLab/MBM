function mbm_perm_test_beta(stat_map_null)
% permutation tests on the beta spectrum
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022
global MBM
% eigenmode decomposision of the null statistical map
beta_null = mbm_eigen_decomp(stat_map_null,MBM.eig.eig);

% calculate p-value of the beta spectrum and identify the significant betas
for ii=1:MBM.eig.N_eig
    
    [MBM.eig.p_beta(ii), MBM.eig.rev_beta(ii)] = p_val_tail_est(beta_null(:,ii), MBM.eig.beta(ii), MBM.stat.Pthr); % MBM.eig.rev_beta with value "false" or "true" indicates the observed value is on the right or left tail of the null distribution.
    
end

% correction with fdr if wishing
if MBM.stat.fdr == 1
    [h, crit_p, adj_ci_cvrg, MBM.eig.p_beta] = fdr_bh(MBM.eig.p_beta,MBM.stat.thres,'pdep');
end