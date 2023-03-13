function eigNormalized = mbm_normalize_eig(eig, nEig)
% normalise each column of eig by dividing by its norm.
%
%% Inputs:
% eig       - Matrix of columns of eigenmodes.
%
% nEig      - Number of eigenmodes.
%
%% Output:
% eigNormalized - Matrix of columns of normalized eigenmodes.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022

eigNormalized = zeros(size(eig)); % preallocation space
for iEig = 1:nEig
    eigNormalized(:, iEig) = eig(:, iEig)./ norm(eig(:, iEig));
end

end
