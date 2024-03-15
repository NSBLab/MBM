function [allButton,StopButton, RunButton, errReturn] = mbm_check_input_app(MBM, allButton,StopButton, RunButton)
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
        RunButton.Text = 'Run';
        RunButton.Icon = '';

        set(allButton,'Enable','on')
        StopButton.Enable = "off";
        errReturn = true;
        break
    end



    if isfield(MBM,'maps') == 0 | isfield(MBM.maps, 'maskFile') == 0 | strcmp(MBM.maps.maskFile,fullfile(0,0))
        msgbox('No mask');
        RunButton.Text = 'Run';
        RunButton.Icon = '';

        set(allButton,'Enable','on')
        StopButton.Enable = "off";
        errReturn = true;
        break


    end

    if isfield(MBM.stat, 'designFile') == 0 | strcmp(MBM.stat.designFile,fullfile(0,0))
        msgbox('No Design matrix G');
        RunButton.Text = 'Run';
        RunButton.Icon = '';

        set(allButton,'Enable','on')
        StopButton.Enable = "off";
        errReturn = true;
        break

    end

    if isfield(MBM.eig, 'eigFile') == 0 | strcmp(MBM.eig.eigFile,fullfile(0,0))

        msgbox('No Eigenmodes');
        RunButton.Text = 'Run';
        RunButton.Icon = '';

        set(allButton,'Enable','on')
        StopButton.Enable = "off";
        errReturn = true;
        break
    end

    if isfield(MBM.plot, "visualize") == 1 & MBM.plot.visualize == 1 & strcmp(MBM.plot.vtkFile,fullfile(0,0))
         msgbox('No Surface');
        RunButton.Text = 'Run';
        RunButton.Icon = '';

        set(allButton,'Enable','on')
        StopButton.Enable = "off";
        errReturn = true;
        break
    end
    dumvar = 0;
end
end
