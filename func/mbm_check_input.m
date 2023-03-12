function mbm_check_input(MBM, fig)
% to check if required inputs are provided for the app. If not, display error message
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

if isfield(MBM, 'maps')==0 | isfield(MBM.maps, 'anatList') == 0
    
    uialert(fig, 'No input maps', 'err');
    pause(3)
    error('No input maps');
    
end

if isfield(MBM,'maps') == 0 | isfield(MBM.maps, 'maskFile') == 0
    
    uialert(fig, 'No mask', 'err');
    error('No mask');
    
end

if isfield(MBM.stat, 'indicatorMatrix') == 0
    
    uialert(fig, 'No indicatorMatrix', 'err');
    error('No indicatorMatrix');
    
end

if isfield(MBM.eig, 'eigFile') == 0
    
    uialert(fig, 'No eigenmodes', 'err');
    error('No eigenmodes');
    
end

if isfield(MBM.plot, 'vtk') == 0
    
    uialert(fig, 'No surface', 'err');
    error('No surface');
    
end
end
