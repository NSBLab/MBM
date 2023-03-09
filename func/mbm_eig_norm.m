function eig_norm = mbm_eig_norm(eig,nEig)
% normalise each column of EIG by dividing by its norm.
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022

eig_norm = zeros(size(eig)); % preallocation space
for iEig = 1:nEig
    eig_norm(:,iEig) = eig(:,iEig)./norm(eig(:,iEig));
end
end
