function plot_map(ax1, vertices,faces,data_to_plot,hemis)
% plot surface
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

a = patch(ax1, 'Vertices', vertices, 'Faces', faces, 'FaceVertexCData', data_to_plot, ...
    'EdgeColor', 'none', 'FaceColor', 'interp');

if strcmpi(hemis, 'left')
    view(ax1,[-90 0]);
elseif strcmpi(hemis, 'right')
    view(ax1,[90 0]);
end
camlight(ax1,'headlight')
 material(a,'dull');
colormap(ax1,bluewhitered(ax1));
axis(ax1,'off');
axis(ax1, 'image');
% cc = colorbar('Position',[ax1.Position(1)+ax1.Position(3)*1.05 ax1.Position(2)+ax1.Position(4)*0.2 0.01 ax1.Position(4)*0.6]);

% a1 = annotation(fig, 'textbox', [ax1.Position(1), ax1.Position(2)+ax1.Position(4)*1.02, ax1.Position(3), 0.02], 'string', 't-map', 'edgecolor', 'none', ...
%     'FontName',font_name,'FontSize',font_size,  'horizontalalignment', 'center');

end