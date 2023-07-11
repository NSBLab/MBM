function processRunButtonHandle = mbm_setup_progress_bar(processRunButtonHandle)
% set up the progress bar for the app
%% Input:
% processRunButtonHandle        - RunButton handle
%
%% Output:
% processRunButtonHandle.Icon   - Progress bar created in the handle

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

% % Store original button text
% originalButtonText = processRunButtonHandle.Text;
% % When the function ends, return the original button state
% cleanup = onCleanup(@()set(processRunButtonHandle,'Text',originalButtonText,'Icon',''));
% Change button name to "Processing"
processRunButtonHandle.Text = 'Processing...';
% Put text on top of icon
processRunButtonHandle.IconAlignment = 'bottom';
% Create waitbar with same color as button
wbar = permute(repmat(processRunButtonHandle.BackgroundColor,15,1,200),[1,3,2]);
% Black frame around waitbar
wbar([1,end],:,:) = 0;
wbar(:,[1,end],:) = 0;
% Load the empty waitbar to the button
processRunButtonHandle.Icon = wbar;

end