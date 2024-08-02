function [inputMap] = mbm_read_map(mapList)
% Read the gifti or mgh maps from the file paths.
%
%% Input:
% mapList    - Cell array of character vectors.
%            - Each array element contains the path to an input
%                      anatomical map in a gifti or mgh file.
%
%% Output:
% inputMap   - Matrix of rows of anatomical maps.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

[filepath,name,ext] = fileparts(mapList{1});

switch char(ext)
    case '.gii'

        for iMap = 1:length(mapList)

            giftiMap = gifti(mapList{iMap});
            inputMap(iMap,:) = giftiMap.cdata;

        end

    case '.mgh'
        for iMap = 1:length(mapList)

            inputMap(iMap,:) = load_mgh(mapList{iMap});


        end
    case '.nii'
        for iMap = 1:length(mapList)

            inputMap(iMap,:) = niftiread(mapList{iMap});


        end
    case '.nii.gz'
        for iMap = 1:length(mapList)

            inputMap(iMap,:) = niftiread(mapList{iMap});


        end
    otherwise
        % uialert(fig, 'Not supported format', 'err');
        % uiwait(fig)
        error('Not supported input map format');
end

end
