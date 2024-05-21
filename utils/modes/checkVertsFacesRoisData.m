function [verts,faces,rois,data] = checkVertsFacesRoisData(varargin)


ip = inputParser;
validationFcn = @(x) (isnumeric(x) && ismatrix(x));
addOptional(ip, 'verts', [], @(x) validationFcn(x));
addOptional(ip, 'faces', [], @(x) validationFcn(x));
addOptional(ip, 'rois',  [], @(x) validationFcn(x));
addOptional(ip, 'data',  [], @(x) validationFcn(x));

addParameter(ip, 'checkContents', true, @islogical);
addParameter(ip, 'fillEmpty', false, @islogical);

parse(ip, varargin{:});
verts = ip.Results.verts;
faces = ip.Results.faces;
rois = ip.Results.rois;
data = ip.Results.data;


%% Check shape
% Check one dimension and transpose if needed

matrices = {verts, faces, rois, data};
names = {'Vertices', 'Faces', 'ROIs', 'Data'};
target2ndDim = {3, 3, 1, 1};

for ii = 1:length(matrices)
    if ~isempty(matrices{ii})

        if size(matrices{ii}, 2) == target2ndDim{ii}
            % good
        elseif size(matrices{ii}, 1) == target2ndDim{ii}
            matrices{ii} = matrices{ii}.';
        else
            error('%s must have a dimension of size %d', names{ii}, target2ndDim{ii});
        end

    end
end

[verts, faces, rois, data] = deal(matrices{:});

if isallhere({verts, rois})
    assert(size(verts, 1) == size(rois, 1), ...
        'Vertices and ROIs must have the same number of points');
end


%% Fill empty, if desired
if ip.Results.fillEmpty
    if isempty(rois); rois = ones(size(verts, 1),1); end
    if isempty(data); data = verts(:, 2); end
end


%% Check contents
if ip.Results.checkContents
    if isallhere({verts, faces})
        if max(faces, [], "all") ~= size(verts, 1)
            warning('The vertices are not all mapped to the faces');
        end
    end

    if isallhere(faces)
        mustBeNonnegative(faces); mustBeInteger(faces);
        if max(faces, [], "all") ~= length(unique(faces))
            warning('The faces skip some of the vertices');
        end
    end

    if isallhere(rois)
        mustBeNonnegative(rois); mustBeInteger(rois);

        goodRois = ( all(rois) && (length(unique(rois))==max(rois)) ) || ... % no non-zeros rois
            (~all(rois) && (length(unique(rois))==max(rois)+1) ); % some non-zero rois

        if ~goodRois
            warning('ROIs appear to not be sequential');
        end
    end

    if isallhere({data, verts}) || isallhere({data, rois})
        assert(size(data, 1) == size(verts, 1) || size(data, 1) == max(rois), ...
            'Data should be one per vertex or one per ROI');
    end
end

end % main

function out = isallhere(inp)
% returns true if inp is (i) a non-empty matrix OR (ii) a cell with all non-empty entries
% else returns false
if ~iscell(inp); out = ~isempty(inp); return; end
out = all(cellfun(@(x) ~isempty(x), inp));
end



