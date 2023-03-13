function [inputMap] = read_gifti_map(mapList)
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


for iMap = 1:length(mapList)
    
    giftiMap = gifti(char(mapList(1,iMap)));
    inputMap(iMap,:) = giftiMap.cdata;
    
end

end
