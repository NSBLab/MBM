function [varargout] = mbm_plot_map(axisPlot, vertices, faces, dataToPlot, hemis, isCbar)
% plot measurement on a surface
%
%% Inputs:
% axisPlot      - axis to plot on
%
% vertices      - vector of vertices
%
% faces         - matrix of faces (3 columns)
%
% dataToPlot    - vector of data to plot
%
% hemis         - 'left' or 'right' to indicate the hemisphere for showing
%               the suitable view
%
%% Output:
% The plot is shown on the given axis.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

a = patch(axisPlot, 'Vertices', vertices, 'Faces', faces, 'FaceVertexCData', dataToPlot, ...
    'EdgeColor', 'none', 'FaceColor', 'interp');

if strcmpi(hemis, 'left')
    view(axisPlot,[-90 0]);
elseif strcmpi(hemis, 'right')
    view(axisPlot,[90 0]);
end

camlight(axisPlot,'headlight')
material(a,'dull');
colormap(axisPlot,mbm_bluewhitered(axisPlot));
axis(axisPlot,'off');
axis(axisPlot, 'image');

if isCbar == 1
cbar = colorbar(axisPlot);
varargout{1} = cbar;
% cbar.Position =[axisPlot.Position(1)+axisPlot.Position(3) axisPlot.Position(2)+axisPlot.Position(4)*0.15 axisPlot.Position(3)*0.03 axisPlot.Position(4)*0.6];
            
end


end