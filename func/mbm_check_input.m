function mbm_check_input(MBM, fig)
% Check if required inputs are provided for the app. If not, display error
% message.
%
%% Inputs:
% MBM       - structure
%
% fig       - figure where error message is displayed.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

if isfield(MBM, 'maps')==0 | isfield(MBM.maps, 'anatList') == 0 | strcmp(MBM.maps.anatList,fullfile(0,0))

    uialert(fig, 'No input maps', 'err');
    uiwait(fig)
    error('No input maps');

end

if isfield(MBM,'maps') == 0 | isfield(MBM.maps, 'maskFile') == 0 | strcmp(MBM.maps.maskFile,fullfile(0,0))

    uialert(fig, 'No mask', 'err');
    uiwait(fig)
    error('No mask');

end

if isfield(MBM.stat, 'indicatorFile') == 0 | strcmp(MBM.stat.indicatorFile,fullfile(0,0))

    uialert(fig, 'No indicatorMatrix', 'err');
    uiwait(fig)
    error('No indicatorMatrix');

end

if isfield(MBM.eig, 'eigFile') == 0 | strcmp(MBM.eig.eigFile,fullfile(0,0))

    uialert(fig, 'No eigenmodes', 'err');
    uiwait(fig)
    error('No eigenmodes');

end

if isfield(MBM.plot, 'vtk') == 0 | strcmp(MBM.plot.vtk,fullfile(0,0))

    uialert(fig, 'No surface', 'err');
    uiwait(fig)
    error('No surface');

end
end
