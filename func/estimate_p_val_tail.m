function [pvals_tail, rev] = estimate_p_val_tail(null, ob, pThr)
% [PVALS_TAIL, REV] = estimate_p_val_tail(NULL, OB, PTHR) calculates
% p-value (2 sides) by comparing the observed value OB and the distribution of the null samples
% NULL. REV with value "false" or "true" indicates the observed value is on
% the right or left tail of the null distribution. If the p-values are
% below PTHR, these are refined further using a tail
% approximation from the Generalised Pareto Distribution (GPD) by PALM
% (Winkler AM, Ridgway GR, Webster MA, Smith SM, Nichols TE. Permutation
% inference for the general linear model. NeuroImage, 2014;92:381-397).
%
% NULL: matrix (nxm) of null samples, where n is the number of null sample
% and m is the number of elements in each sample.
% OB: observed value.
% PTHR: threshold to use approximation.
%
% PVALS_TAIL: vector (1xm) of p-values.
% REV: vector (1xm) of "false" or "true" indicates the observed value is on
% the right or left tail of the null distribution.
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.


corr_mat1out = false;

if max(null) < ob
    
    pvals_tail = 0;
    rev = false; %right tail
    
elseif min(null)> ob
    
    pvals_tail = 0;
    rev = true; %left tail
    
elseif max(null) == min(null)
    
    pvals_tail = 1;
    rev = true; %no tail
    
else
    
    if ob<median(null)
        rev = true; %left tail
    else
        rev =false; %right tail
    end
    pvals_tail = 2 * palm_pareto(ob,null,rev,pThr,corr_mat1out);
end
end

