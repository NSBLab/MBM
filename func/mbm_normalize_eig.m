function eigNormalized = mbm_normalize_eig(eig, nEig)
% normalise each column of EIG by dividing by its norm.
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022

eigNormalized = zeros(size(eig)); % preallocation space
for iEig = 1:nEig
    eigNormalized(:, iEig) = eig(:, iEig)./ norm(eig(:, iEig));
end
end
