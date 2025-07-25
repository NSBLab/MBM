function [errReturn] = mbm_check_input_app(MBM)
% Check if required inputs are provided for the app. If not, display error
% message.
%
%% Inputs:
% MBM       - structure
%
% fig       - figure where error message is displayed.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.
errReturn = false;
dumvar = 1; %to use break in while
while dumvar
    if isfield(MBM, 'maps')==0 | isfield(MBM.maps, 'anatListFile') == 0 | strcmp(MBM.maps.anatListFile,fullfile(0,0))

        msgbox('No map list');

        errReturn = true;
        break
    end



    if isfield(MBM,'maps') == 0 | isfield(MBM.maps, 'maskFile') == 0 | strcmp(MBM.maps.maskFile,fullfile(0,0))
        msgbox('No mask');

        errReturn = true;
        break


    end

    if isfield(MBM.stat, 'designFile') == 0 | strcmp(MBM.stat.designFile,fullfile(0,0))
        msgbox('No Design matrix G');

        errReturn = true;
        break

    end


    if (isfield(MBM.eig, 'eigFile') == 0 | isfield(MBM.eig, 'massFile') == 0 | ...
            strcmp(MBM.eig.eigFile,fullfile(0,0)) | strcmp(MBM.eig.massFile,fullfile(0,0))) & ...
            (isfield(MBM.plot, 'vtkFile') == 0 | strcmp(MBM.plot.vtkFile,fullfile(0,0)))
        msgbox('No Surface');

        errReturn = true;
        break
    end

    dumvar = 0;
end
end
