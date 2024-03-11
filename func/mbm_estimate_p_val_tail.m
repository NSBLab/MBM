function [pValueTail, rev] = mbm_estimate_p_val_tail(null, observe, pThr)
% Calculates p-value (2 sides) by comparing the observed value and the distribution of the null samples. 
%
%% Inputs:
% null      - matrix (nxm) of null samples, where n is the number of null
%           sample and m is the number of elements in each sample.
%
% observe   - observed value.
%
% pThr      - threshold to use approximation. If the p-values are
%           below pThr, these are refined further using a tail
%           approximation from the Generalised Pareto Distribution (GPD) by PALM
%           (Winkler AM, Ridgway GR, Webster MA, Smith SM, Nichols TE. Permutation
%           inference for the general linear model. NeuroImage, 2014;92:381-397).
%
%% Outputs:
% rev:       - vector (1xm)
%            - "false" or "true" indicates the observed value is on
%           the right or left tail of the null distribution. 
%
% pValueTail - vector (1xm) of p-values.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.


corr_mat1out = false;

if max(null) <= observe
    
    pValueTail = 0;
    rev = false; %right tail
    
elseif min(null) >= observe
    
    pValueTail = 0;
    rev = true; %left tail
    
elseif max(null) == min(null)
    
    pValueTail = 1;
    rev = true; %no tail
    
else
    
    if observe < median(null)
        rev = true; %left tail
    else
        rev = false; %right tail
    end
    pValueTail = 2 * palm_pareto(observe, null, rev, pThr, corr_mat1out);
end
end

