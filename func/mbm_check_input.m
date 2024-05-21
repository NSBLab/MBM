function mbm_check_input(MBM)
% Check if required inputs are provided for the app. If not, display error
% message.
%
%% Inputs:
% MBM       - structure
%
% fig       - figure where error message is displayed.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

    if isfield(MBM, 'maps')==0 | isfield(MBM.maps, 'anatListFile') == 0 | strcmp(MBM.maps.anatListFile,fullfile(0,0))

        error('No map list');
       
    end



    if isfield(MBM,'maps') == 0 | isfield(MBM.maps, 'maskFile') == 0 | strcmp(MBM.maps.maskFile,fullfile(0,0))
        error('No mask');
        
    end

    if isfield(MBM.stat, 'designFile') == 0 | strcmp(MBM.stat.designFile,fullfile(0,0))
        error('No Design matrix G');
        
    end

    % if isfield(MBM.eig, 'eigFile') == 0 | strcmp(MBM.eig.eigFile,fullfile(0,0))
    % 
    %     error('No Eigenmodes');
    % 
    % end

    if isfield(MBM.plot, "visualize") == 1 & MBM.plot.visualize == 1 & strcmp(MBM.plot.vtkFile,fullfile(0,0))
       error('No Surface');
       
    end
end

