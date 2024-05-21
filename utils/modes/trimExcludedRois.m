function [vertices2, faces2, rois2, mask] = trimExcludedRois(vertices, faces, rois, varargin)
%% TRIMEXCLUDEDROIS Remove specified vertices and faces from surface mesh
% Removes rois with a value of 0 and the corresponding vertices and faces.
% Reindexes the remaining vertices and faces. 
%   
%   
%% Syntax
%   [vertices2, faces2, rois2] = trimExcludedRois(vertices, faces, rois)
%   [vertices2, faces2, rois2] = trimExcludedRois(___, Name, Value)
%   
%   
%% Description
% `[vertices2, faces2, rois2] = trimExcludedRois(vertices, faces, rois)` removes
% the rois labelled 0 (as well as the faces and vertices within those rois). It
% retains the remaining rois, and reindexes the remaining vertices and faces.
%  
% `[vertices2, faces2, rois2] = trimExcludedRois(___, Name, Value)` specifies
% additional parameters for retaining/returning the rois.
%   
%   
%% Examples
%   [vertices2, faces2, rois2] = trimExcludedRois(lh_verts, lh_faces, lh_aparc);
%   z = cell(1, 3); [z{:}] = trimExcludedRois(lh_verts, lh_faces, lh_aparc>25); plotBrain(z{:}, z{1}(:, 2));
%   
%   
%% Input Arguments
%  vertices - vertex coordinates (matrix)
%  V × 3 matrix of xyz coordinates of surface vertices (V is the number of
%  vertices).
% 
%  faces - face allocations (matrix)
%  F × 3 matrix, where each row is the vertex IDs that make up each face (F is
%  the number of faces).
%
%  rois - parcellation aka ROI allocation (vector)
%  V × 1 matrix, where each element is the ROI that each vertex is allocated to.
%   
%% Name-Value Arguments
%  reindexRois - flag for reindexing rois (false (default)|logical)
%  If set to false, rois2 will be numbered according to the input roi
%  numbering. If set to true, rois2 will be renumbered from 1 to
%  length(unique(rois2)).
%   
%  setOrder - flag for changing numbering of rois ('sorted' (default)|'stable')
%  Order flag, specified as 'sorted' or 'stable', indicates the order of the
%  rois returned. Requires 'reindexRois' to be set to true. 'sorted': reindexes
%  rois in order of original value; 'stable': reindexes rois in order of
%  appearance.
%   
%   
%% Output Arguments
%  vertices2 - retained vertex coordinates (matrix)
%  V_2 × 3 matrix of xyz coordinates of surface vertices that are contained
%  within the retained rois (V_2 is the number of retained vertices).
%
%  faces2 - retained face allocations (matrix)
%  F_2 × 3 matrix, where each row is the vertex IDs that make up each retained
%  face (F_2 is the number of retained faces).
%
%  rois2 - parcellation aka ROI allocation (vector)
%  V_2 × 1 matrix, where each element is the ROI that each retained vertex is
%  allocated to.
%   
%   
%% See also 
%   plotBrain, surfKeepCortex
%
%   Python surfdist (Daniel Margulies) https://github.com/NeuroanatomyAndConnectivity/surfdist/blob/master/surfdist/utils.py
%   
%   
%% Authors
% Mehul Gajwani, Monash University, 2023
%
%

%% ENDPUBLISH


% Examples of roi reordering
% reindexRois = {true, false}; setOrder = {'sorted', 'stable'};
% figure; tiledlayout(2, 2);
% for ii = 1:2; for jj = 1:2;
%         [v,f,r] = trimExcludedRois(lh_verts, lh_faces, (34-lh_aparc).*(lh_aparc<20), ...
%             'reindexRois', reindexRois{ii}, 'setOrder', setOrder{jj});
%         nexttile(); scatter(nonzeros(34-lh_aparc(lh_aparc<20)), r);
% end; end;

% TODO : generate tests
% TODO : incorporate functionality with plotBrain
% TODO : pass through user options in recursive call


%% Prelims
ip = inputParser;
addRequired(ip, 'vertices');
addRequired(ip, 'faces');
addRequired(ip, 'rois');

addParameter(ip, 'reindexRois', false);
addParameter(ip, 'removeUnconnected', true);
addParameter(ip, 'setOrder', 'sorted'); % only for reindexing rois, can be 'sorted' or 'stable' (see UNIQUE)
addParameter(ip, 'overrideAssertions', false);

parse(ip, vertices, faces, rois, varargin{:});

vertices = ip.Results.vertices;
faces = ip.Results.faces;
rois = reshape(ip.Results.rois, [], 1);


%% Assertions
if ~ip.Results.overrideAssertions
    [vertices, faces, rois] = checkVertsFacesRoisData(vertices, faces, rois+0);
%     assert(size(vertices, 1) == size(rois, 1), ...
%         'vertices and rois are not the same length');
%     assert(size(vertices, 2) == 3, ...
%         'vertices needs x, y, z, coordinates');
%     assert(max(faces(:)) == size(vertices, 1), ...
%         'faces should use all the vertices');
%     assert(size(faces, 2) == 3, ...
%         'each face should have three vertices');
end


%% Generate new data
% rois - extract only appropriate rois
mask = logical(rois);
rois2 = rois(mask); %nonzeros rois

% vertices - reindex vertices to remove unneccessary ones
vertices2 = vertices(mask,:);
if nargout < 2; return; end

% faces
% create list of new vertex IDs, in old vertex positions
vertIDs = zeros(length(rois), 1);
vertIDs(mask) = 1:length(rois2);

% exclude faces where any vertex is in a defunct roi
roisExcludedIds = find(~rois);
facesExcluded = any(ismember(faces, roisExcludedIds), 2);

% generate output
faces2 = faces(~facesExcluded, :);
faces2 = vertIDs(faces2);


%% Reindex rois
if ip.Results.reindexRois 
    % get the number of rois in the new parcellation, and find where they need
    % to be reallocated to
    temp = unique(rois2, ip.Results.setOrder)'; % can be reordered by the user if expecially desired
    rois2 = (rois2 == temp) * (1:length(temp))'; % implicit expansion
end


%% Fix any unconnected vertices, if desired
if ip.Results.removeUnconnected
    A = triangulation2adjacency(faces2, 1:height(vertices2), 'returnSparse', true);
    G = graph(A); 
    N = conncomp(G)';
    mask2 = N == mode(N);       % get mask of largest component
    if all(mask2); return; end  % return if all verts are connected
    [vertices2, faces2] = trimExcludedRois(vertices2, faces2, mask2); 
    rois2 = rois2(mask2);
    mask(logical(mask)) = mask2; % for output
end


end

