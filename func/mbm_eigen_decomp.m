function beta = mbm_eigen_decomp(stat_map,eig)
% BETA = eigen_decomp(STAT_MAP,EIG) calculates the BETA in the beta
% spectrum from the statistical map STAT_MAP and the eigenmodes EIG.
%
% STAT_MAP: matrix of the statistical map (nxk).
% EIG: matrix (nxm) with m columns of eigenmodes, where each eigenmode has
% n elements.
%
% BETA: matrix of beta spectrum (mxk).
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022

if size(eig,1) ~= size(stat_map,1)
    error('Error. The sizes of the eigenmode matrix and statistical map do not match.')
end

beta = ((eig.'*eig)\(eig.'*(stat_map)))';

end