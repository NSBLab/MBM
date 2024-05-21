function [W, medialNeighbors] = triangulation2adjacency(faces, varargin)
%% TRIANGULATION2ADJACENCY Returns adjacency matrix from face and ROI allocations
%
% ![](../IMAGES/adjacenciesAndParcellations.svg)
%
%% Syntax
%   W = triangulation2adjacency(faces, rois)
%   
%   
%% Description
% `W = triangulation2adjacency(faces, rois)` generates a weighted adjacency
% matrix, where each element W_{ij} is the number of faces that span region
% i and region j if they are adjacent, and 0 otherwise.
%   
%   
%% Examples
%   W = triangulation2adjacency(lh_faces, lh_aparc);
%   colors = GraphColoringJohnson(graph(triangulation2adjacency(lh_faces, lh_aparc)));  figure; plotBrain(lh_verts, lh_faces, lh_aparc, colors+1);
%   
%   
%% Input Arguments
%  faces - face allocations (matrix)
%  F × 3 matrix, where each row is the vertex IDs that make up each face (F
%  is the number of faces).
%
%  rois - parcellation aka ROI allocation (vector) 
%  V × 1 matrix, where each element is the ROI that each vertex is
%  allocated to (V is the number of vertcies). ROIs indexed as zero are
%  treated as the medial wall and are not included. Note that faces which
%  border the medial wall are output in `medialNeighbors`.
%   
%   
%% Name-Value Arguments
%  nrois - number of ROIs in parcellation (positive integer scalar)
%  Use this to specify a number of ROIs, if the last ROI(s) have 0 vertices
%  in the parcellation. 
%  
%  returnSparse - flag to return sparse matrix (false (default) | true)
%  This should only be used on a full triangulation (i.e. with no input in
%  `rois`). 
%
%
%
%% Output Arguments
%  W - weighted adjacency matrix (matrix)
%  nRois × nRois weighted adjacency matrix, where each element W_{ij} is
%  the number of faces that span region i and region j, if any.
%   
%  medialNeighbors - list of ROIs adjacent to the medial wall (vector) 
%   
%   
%% Authors
% Mehul Gajwani, Monash University, 2023
%
%
%% ENDPUBLISH

% TODO : consider using SPARSE and SPFUN operators as described here https://stackoverflow.com/questions/28455189/matlab-adjacency-matrix-from-patch-object
% TODO : create flag to include/exclude rois indexed with 0 in the calculation
% TODO : create flag to include unindexed rois in the calculation/rois not starting from 1 (e.g. A = zeros(length(unique(rois));)
% TODO : create tests

%% Prelims
ip = inputParser;
ip.addRequired('faces');
ip.addOptional('rois', (1:max(faces,[],'all')).');

ip.addParameter('nrois', []);
ip.addParameter('overrideAssertions', false);
ip.addParameter('returnSparse', false);

ip.parse(faces, varargin{:});
faces = ip.Results.faces; 
rois = ip.Results.rois;
nrois = ip.Results.nrois; if isempty(nrois); nrois = max(rois); end


%% Assertions
if ~ip.Results.overrideAssertions
    [~, faces, rois] = checkVertsFacesRoisData([], faces, rois);
end


%% Computations
roiFaces = rois(faces); % matrix of the ROI allocations for each face

W = ...
    sparse( ...
        reshape(roiFaces            , [], 1)+1, ... % add 1 to avoid 0 rois
        reshape(roiFaces(:, [2 3 1]), [], 1)+1, ...
        1, nrois+1, nrois+1 ...
    );

if ip.Results.returnSparse; W = W+W'; W = W(2:end,2:end); return; end

% symmetrise and diag to 0 
W = full(W+W.'); 
medialNeighbors = logical(W(2:end,1));
W = W(2:end, 2:end); % remove 0 rois
W(1:(size(W,1)+1):end) = 0;

end



%% Older, slower method
% % % % % % find the faces that have different roi allocations on their vertices
% % % % % % with the non-zero rois excluded 
% % % % % boundaryFaces = any(diff(roiFaces, 1, 2), 2) & all(roiFaces ~= 0, 2);
% % % % % 
% % % % % % for each pair of dimensions (e.g. 1&2/1&3/2&3), get the rois on those faces
% % % % % % and set the adjacency matrix
% % % % % for ii = 2:size(faces, 2)
% % % % %     for jj = 1:(ii-1)
% % % % %         temp = sub2ind(size(A), ...
% % % % %             roiFaces(boundaryFaces, ii), roiFaces(boundaryFaces, jj));
% % % % %         A(temp) = 1;
% % % % %     end
% % % % % end
% % % % % 
% % % % % % diag to 0 and symmetrise
% % % % % A = +logical(A+A.');
% % % % % A(1:(size(A,1)+1):end) = 0;
