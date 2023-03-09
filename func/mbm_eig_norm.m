function eig_norm = mbm_eig_norm(eig,N_EM)
% normalise each column of EIG by dividing by its norm.
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022

eig_norm = zeros(size(eig)); % preallocation space
for i = 1:N_EM
    eig_norm(:,i) = eig(:,i)./norm(eig(:,i));
end
end
