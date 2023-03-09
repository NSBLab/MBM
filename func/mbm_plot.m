function mbm_plot(MBM)
% plot MBM results
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022

% For plotting                                             
light_gray = [0.5 0.5 0.5]; % define color
light_green = [0.35 0.65 0.35]; % define color
font_name = 'Arial'; % font for labels
font_size = 15;

% read surface
[vertices,faces] = read_vtk(MBM.plot.vtk);
vertices = vertices';
faces = faces';

% define figure model
fig = figure('Position', [200 200 1000 600], 'color', 'w');

% define axis para
factor_x = 1.5;
factor_y = 1.5;
init_x = 0.01;
init_y = 0.02;
num_row = 2;    %No of rows
num_col = 3;    %No of columns
length_x = (0.85 - init_x)/(factor_x*(num_col-1)+1);
length_y = (0.95 - init_y)/(factor_y*(num_row-1)+1);

%% plot tmap

% restore removed vertices
statMap_nomask = zeros(size(MBM.maps.mask))';
statMap_nomask(MBM.maps.mask==1) = MBM.stat.statMap;

% define axis
ax1 = axes('Position', [init_x init_y+factor_y*length_y length_x length_y]);

patch(ax1, 'Vertices', vertices, 'Faces', faces, 'FaceVertexCData', statMap_nomask, ...
    'EdgeColor', 'none', 'FaceColor', 'interp');

if strcmpi(MBM.plot.hemis, 'left')
    view([-90 0]);
elseif strcmpi(MBM.plot.hemis, 'right')
    view([90 0]);
end
camlight('headlight')
material dull
colormap(ax1,bluewhitered(ax1));
axis off;
axis image;
cc = colorbar('Position',[ax1.Position(1)+ax1.Position(3)*1.05 ax1.Position(2)+ax1.Position(4)*0.2 0.01 ax1.Position(4)*0.6]);

a1 = annotation(fig, 'textbox', [ax1.Position(1), ax1.Position(2)+ax1.Position(4)*1.02, ax1.Position(3), 0.02], 'string', 't-map', 'edgecolor', 'none', ...
    'FontName',font_name,'FontSize',font_size,  'horizontalalignment', 'center');

%% plot thresholded map

% restore removed vertices
thresMap_nomask = zeros(size(MBM.maps.mask))';
thresMap_nomask(MBM.maps.mask==1) = MBM.stat.thresMap;

ax2 = axes('Position', [init_x+length_x*1.25  ax1.Position(2) length_x length_y]);

patch(ax2, 'Vertices', vertices, 'Faces', faces, 'FaceVertexCData', thresMap_nomask, ...
    'EdgeColor', 'none', 'FaceColor', 'interp');
if strcmpi(MBM.plot.hemis, 'left')
    view([-90 0]);
elseif strcmpi(MBM.plot.hemis, 'right')
    view([90 0]);
end
camlight('headlight')
material dull
colormap(ax2,bluewhitered(ax2))
axis off;
axis image;
a2 = annotation(fig, 'textbox', [ax2.Position(1), ax2.Position(2)+ax2.Position(4)*1.02, ax2.Position(3), 0.02], 'string', ' thresholded t-map', 'edgecolor', 'none', ...
    'FontName',font_name,'FontSize',font_size,  'horizontalalignment', 'center');

%% plot beta spectrum

ax3 = axes('Position', [ax2.Position(1)+ax2.Position(3)*1.3 ax1.Position(2) length_x*2 length_y*0.8],'FontName',font_name,'FontSize',font_size);

bar(ax3,MBM.eig.beta,'FaceColor',light_gray,'EdgeColor',light_gray);
hold(ax3,'on');
bar(ax3,MBM.eig.significantBeta,'FaceColor',light_green,'EdgeColor',light_green);
hold(ax3, 'off')

xlabel(ax3, '\psi', 'FontName', font_name, 'FontSize', font_size);
ylabel(ax3, '\beta', 'FontName', font_name, 'FontSize', font_size);

legend('non-significant','significant','NumColumns',2)
legend('boxoff')

a3 = annotation(fig, 'textbox', [ax3.Position(1), a2.Position(2), ax3.Position(3), 0.02], 'string', '\beta spectrum', 'edgecolor', 'none', ...
    'FontName',font_name,'FontSize',font_size, 'horizontalalignment', 'center');

%% plot significant patterns
% restore removed vertices
reconMap_nomask = zeros(size(MBM.maps.mask))';
reconMap_nomask(MBM.maps.mask==1) = MBM.eig.reconMap;

ax4 = axes('Position', [ax1.Position(1) init_y ax1.Position(3) ax1.Position(4)],'FontName',font_name,'FontSize',font_size);

patch(ax4, 'Vertices', vertices, 'Faces', faces, 'FaceVertexCData', reconMap_nomask, ...
    'EdgeColor', 'none', 'FaceColor', 'interp');

if strcmpi(MBM.plot.hemis, 'left')
    view([-90 0]);
elseif strcmpi(MBM.plot.hemis, 'right')
    view([90 0]);
end
camlight('headlight')
material dull
colormap(ax4,bluewhitered(ax4));
axis off;
axis image;

a4 = annotation(fig, 'textbox', [ax4.Position(1), ax4.Position(2)+ax4.Position(4)*1.02, ax4.Position(3), 0.02], 'string', 'significant patterns', 'edgecolor', 'none', ...
    'FontName',font_name,'FontSize',font_size,  'horizontalalignment', 'center');

%% plot the most influent pattern
% restore removed vertices
eig_nomask = zeros(size(MBM.maps.mask,2),MBM.plot.nInfluentialMode);
eig_nomask(MBM.maps.mask==1,:) = MBM.eig.eig(:,MBM.eig.betaOrder(1:MBM.plot.nInfluentialMode)).*sign(MBM.eig.beta(MBM.eig.betaOrder(1:MBM.plot.nInfluentialMode)));

% define axis para
factor_x = 1.1;
factor_y = 1.4;
init_x = ax4.Position(1)+ax4.Position(3)*1.1;
num_row = 2;    %No of rows
num_col = ceil(MBM.plot.nInfluentialMode/2);    %No of columns
length_x = (0.95 - init_x)/(factor_x*(num_col-1)+1);
length_y = (0.4 - init_y)/(factor_y*(num_row-1)+1);

for eig_in = 1:MBM.plot.nInfluentialMode % influent order of the modes
    
    i = ceil(eig_in/num_col); % row index
    ii = mod(eig_in+num_col-1,num_col)+1; % column index
    ax5 = axes('Position', [init_x+factor_x*length_x*(ii-1) init_y+factor_y*length_y*(num_row-i) length_x length_y],'FontName',font_name,'FontSize',font_size);

    patch(ax5, 'Vertices', vertices, 'Faces', faces, 'FaceVertexCData', eig_nomask(:,eig_in), ...
        'EdgeColor', 'none', 'FaceColor', 'interp');
    
    if strcmpi(MBM.plot.hemis, 'left')
        view([-90 0]);
    elseif strcmpi(MBM.plot.hemis, 'right')
        view([90 0]);
    end
    camlight('headlight')
    material dull
    colormap(ax5,bluewhitered(ax5));
    axis off;
    axis image;
    % cc = colorbar('Position',[ax4.Position(1)+ax4.Position(3)*1.03 ax4.Position(2) 0.01 ax4.Position(4)*0.8]);
    switch eig_in
        case 1
            a5 = annotation(fig, 'textbox', [ax5.Position(1), ax5.Position(2)+ax5.Position(4)*1.2, ax5.Position(3), 0.02], 'string', [num2str(eig_in), 'st'], 'edgecolor', 'none', ...
                'FontName',font_name,'FontSize',font_size,  'horizontalalignment', 'center');
        case 2
            a5 = annotation(fig, 'textbox', [ax5.Position(1), ax5.Position(2)+ax5.Position(4)*1.2, ax5.Position(3), 0.02], 'string', [num2str(eig_in), 'nd'], 'edgecolor', 'none', ...
                'FontName',font_name,'FontSize',font_size,  'horizontalalignment', 'center');
        case 3
            a5 = annotation(fig, 'textbox', [ax5.Position(1), ax5.Position(2)+ax5.Position(4)*1.2, ax5.Position(3), 0.02], 'string', [num2str(eig_in), 'rd'], 'edgecolor', 'none', ...
                'FontName',font_name,'FontSize',font_size,  'horizontalalignment', 'center');
        otherwise
            a5 = annotation(fig, 'textbox', [ax5.Position(1), ax5.Position(2)+ax5.Position(4)*1.2, ax5.Position(3), 0.02], 'string', [num2str(eig_in), 'th'], 'edgecolor', 'none', ...
                'FontName',font_name,'FontSize',font_size,  'horizontalalignment', 'center');
    end
end

a6 = annotation(fig, 'textbox', [ax4.Position(1)+ax4.Position(3), init_y+2.1*length_y*factor_y, length_x*num_col*factor_x, 0.02], 'string', 'most influential modes', 'edgecolor', 'none', ...
    'FontName',font_name,'FontSize',font_size,  'horizontalalignment', 'center');

end