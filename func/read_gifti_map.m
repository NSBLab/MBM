function [inputMap] = read_gifti_map(mapList)
% read the gifti maps from the mapList
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.


for iMap = 1:length(mapList)
    
    giftiMap = gifti(char(mapList(1,iMap)));
    inputMap(iMap,:) = giftiMap.cdata;
    
end

end
