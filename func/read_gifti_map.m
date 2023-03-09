function [input_maps] = read_gifti_map(map_list)
% read the gifti maps from the map_list
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.


for ig=1:length(map_list)
    
    g_gifti = gifti(char(map_list(1,ig)));
    input_maps(ig,:) = g_gifti.cdata;
    
end

end
