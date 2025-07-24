function [MBM] = mbm_perm_test_beta(statMapNull, MBM)
% permutation tests on the beta spectrum
%
%% Inputs:
% statMapNull   - Matrix of rows of null statistical maps
%
% MBM           - structure having the input fields:
%               MBM.eig.nEigenmode    - Number of eigenmodes to be used.
%
%               MBM.eig.eig           - Matrix of columns of eigenmodes.
%
%               MBM.eig.beta          - Vector of beta spectrum.
%
%               MBM.stat.pThr         - Threshold of p-values for 
%                                     tail approximation. If the
%                                     p-values are below MBM.stat.pThr,
%                                     these are refined further using a
%                                     tail approximation from the
%                                     Generalise Pareto Distribution (GPD).
%
%               MBM.stat.thres        - Threshold of p-values for 
%                                     being significant. When the 
%                                     p-value is below MBM.stat.thres, 
%                                     the statitical test is considered 
%                                     significant.     
%
%               MBM.stat.fdr          - Option ('true' or 'false') to
%                                     correct multiple test with FDR or not.
%
%% Outputs:
% MBM           - structure having the output fields:
%               MBM.eig.pBeta         - Vector of p-values of the
%                                       beta spectrum.
%
%               MBM.eig.revBeta       - Vector of "false" or "true"
%                                       indicating the observed value of an 
%                                       element in the beta spectrum on
%                                       the right or left tail of the null
%                                       distribution.                              

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

% eigenmode decomposision of the null statistical map
betaNull = calc_eigendecomposition(statMapNull', MBM.eig.eig, 'orthogonal', MBM.eig.mass);
betaNull = betaNull';
% update progress bar if using app
    if isfield(MBM, 'processRunButtonHandle')==1
        currentProg = min(round((size(MBM.processRunButtonHandle.Icon,2)-2)*(1/10+3/10+2/10+1/10)),...
            size(MBM.processRunButtonHandle.Icon,2)-2);
        RGB = MBM.processRunButtonHandle.Icon;
        RGB(2:end-1, 2:currentProg+1, 1) = 0.25391; % (royalblue)
        RGB(2:end-1, 2:currentProg+1, 2) = 0.41016;
        RGB(2:end-1, 2:currentProg+1, 3) = 0.87891;
        MBM.processRunButtonHandle.Icon = RGB;
        pause(0.0001)
    end

% normalise beta spectrum
    betaNormalized = MBM.eig.beta./ norm(MBM.eig.beta);
    for iBetaNull = 1:height(betaNull)
        betaNullNormalized(iBetaNull,:) = betaNull(iBetaNull,:)./norm(betaNull(iBetaNull,:));
    end
% calculate p-value of the beta spectrum and identify the significant betas
for iEig = 1:MBM.eig.nEigenmode
    
    
    [MBM.eig.pBeta(iEig), MBM.eig.revBeta(iEig)] = mbm_estimate_p_val_tail(betaNullNormalized(:,iEig), betaNormalized(iEig), MBM.stat.pThr); % MBM.eig.revBeta with value "false" or "true" indicates the observed value is on the right or left tail of the null distribution.
       
    % update progress bar if using app
    if isfield(MBM, 'processRunButtonHandle')==1
        currentProg = min(round((size(MBM.processRunButtonHandle.Icon,2)-2)*(1/10+3/10+2/10+1/10+2/10*iEig/MBM.eig.nEigenmode)),...
            size(MBM.processRunButtonHandle.Icon,2)-2);
        RGB = MBM.processRunButtonHandle.Icon;
        RGB(2:end-1, 2:currentProg+1, 1) = 0.25391; % (royalblue)
        RGB(2:end-1, 2:currentProg+1, 2) = 0.41016;
        RGB(2:end-1, 2:currentProg+1, 3) = 0.87891;
        MBM.processRunButtonHandle.Icon = RGB;
        pause(0.0001)
    end
end

% correction with fdr if wishing
if MBM.stat.fdr == 1
    [h, crit_p, adj_ci_cvrg, MBM.eig.pBeta] = fdr_bh(MBM.eig.pBeta, MBM.stat.thres, 'pdep');
end

end
