function [MBM] = mbm_perm_test_beta(statMapNull, MBM)
% permutation tests on the beta spectrum
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022
%global MBM
% eigenmode decomposision of the null statistical map
betaNull = mbm_eigen_decomp(statMapNull,MBM.eig.eig);

% calculate p-value of the beta spectrum and identify the significant betas
for iEig=1:MBM.eig.nEigenmode
    
    [MBM.eig.pBeta(iEig), MBM.eig.revBeta(iEig)] = estimate_p_val_tail(betaNull(:,iEig), MBM.eig.beta(iEig), MBM.stat.pThr); % MBM.eig.revBeta with value "false" or "true" indicates the observed value is on the right or left tail of the null distribution.
    
end

% correction with fdr if wishing
if MBM.stat.fdr == 1
    [h, crit_p, adj_ci_cvrg, MBM.eig.pBeta] = fdr_bh(MBM.eig.pBeta,MBM.stat.thres,'pdep');
end