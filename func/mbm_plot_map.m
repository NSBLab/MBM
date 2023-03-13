function mbm_plot_map(axisPlot, vertices, faces, dataToPlot, hemis)
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

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

a = patch(axisPlot, 'Vertices', vertices, 'Faces', faces, 'FaceVertexCData', dataToPlot, ...
    'EdgeColor', 'none', 'FaceColor', 'interp');

if strcmpi(hemis, 'left')
    view(axisPlot,[-90 0]);
elseif strcmpi(hemis, 'right')
    view(axisPlot,[90 0]);
end

camlight(axisPlot,'headlight')
material(a,'dull');
colormap(axisPlot,bluewhitered(axisPlot));
axis(axisPlot,'off');
axis(axisPlot, 'image');
% cc = colorbar('Position',[ax1.Position(1)+ax1.Position(3)*1.05 ax1.Position(2)+ax1.Position(4)*0.2 0.01 ax1.Position(4)*0.6]);

% a1 = annotation(fig, 'textbox', [ax1.Position(1), ax1.Position(2)+ax1.Position(4)*1.02, ax1.Position(3), 0.02], 'string', 't-map', 'edgecolor', 'none', ...
%     'FontName',font_name,'FontSize',font_size,  'horizontalalignment', 'center');

end