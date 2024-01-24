function [inputMap] = read_map(mapList)
% Read the gifti maps from the file paths.
%
%% Input:    
% mapList    - Cell array of character vectors.
%            - Each array element contains the path to an input
%                      anatomical map in a GIFTI file.
%
%% Output:   
% inputMap   - Matrix of rows of anatomical maps.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

[filepath,name,ext] = fileparts(mapList(1));

switch char(ext)
case '.gii'

for iMap = 1:length(mapList)
    
    giftiMap = gifti(char(mapList(1,iMap)));
    inputMap(iMap,:) = giftiMap.cdata;
    
end

    case '.mgh'
for iMap = 1:length(mapList)
    
    inputMap(iMap,:) = load_mgh(char(mapList(1,iMap)));
    
    
end
    otherwise
        uialert(fig, 'Not supported format', 'err');
        uiwait(fig)
        error('Not supported format');
end

end
