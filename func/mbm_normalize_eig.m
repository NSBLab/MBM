function [eigNormalized, varargout] = mbm_normalize_eig(eig, nEig, varargin)
% normalise each column of eig by dividing by its norm.
%
%% Inputs:
% eig       - Matrix of columns of eigenmodes.
%
% nEig      - Number of eigenmodes.
%
%% Output:
% eigNormalized - Matrix of columns of normalized eigenmodes.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

eigNormalized = zeros(size(eig)); % preallocation space
for iEig = 1:nEig
    if norm(eig(:, iEig)) ~= 0
        eigNormalized(:, iEig) = eig(:, iEig)./ norm(eig(:, iEig));
    else
        if isempty(varargin) % varargin indicates app usage

            error(['Norm of ', num2str(iEig),' eigenmode is zero.']);
        else
            msgbox(['Norm of ', num2str(iEig),' eigenmode is zero.']);
            varargout{1} = true; % report error
            break
        end
    end
end

end
