function beta = mbm_eigen_decompose(statMap, eig)
% Calculates the beta spectrum from the statistical map and the eigenmodes.
%
%% Inputs:
% statMap   - vector of the statistical map (1xn).
%
% eig       - matrix (nxm) with m columns of eigenmodes, where each
%           eigenmode has n elements.
%
%% Output:
% beta      - vector of beta spectrum.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

if size(eig, 1) ~= size(statMap, 2)
    error('Error. The sizes of the eigenmode matrix and statistical map do not match.')
end

beta = ((eig.'*eig)\(eig.'*(statMap)'))';

end