function mbm_plot(MBM)
% plot MBM results
%
%% Inputs:
% MBM   - structure having the fields:
%
%       MBM.maps.mask         - Vector of the binary mask.
%
%       MBM.plot.saveFig      - Option ('true' or 'false') to
%                               save the visualisation of the results.
%
%       MBM.plot.figFile      - Character vector.
%                             - Filename including path to
%                               save the visualisation of the results.
%                             - File formats supported
%                             by 'saveas' in Matlab
%                             such as .fig .png .jpg .eps...
%
%       MBM.plot.vtkFile      - Path to a vtk file containing a
%                                       surface to plot.
%
%       MBM.plot.hemis        - 'left' or 'right' to visialise left or
%                                       right hemisphere.
%
%       MBM.plot.nInfluentialMode      - Number of the most influential
%                                       modes to be plot.
%
%       MBM.stat              - Structure of parameters to produce a statistical map from
%                             the input maps for MBM analysis. Output fields are:
%
%       MBM.stat.statMap      - Vector of a statistical map.
%
%       MBM.stat.thresMap     - Vector of a thresholded map.
%
%       MBM.eig.beta          - Vector of beta spectrum.
%
%       MBM.eig.significantBeta      - Vector of significant betas.
%
%       MBM.eig.eig           - Matrix of columns of eigenmodes.
%
%       MBM.eig.reconMap      - Vector of significant pattern.
%
%       MBM.eig.betaOrder     - Vector of influential order.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.

% Define constants
lightGray = [0.5 0.5 0.5]; % define color
lightGreen = [0.35 0.65 0.35]; % define color
fontName = 'Arial'; % font for labels
fontSize = 15;

% read surface
[vertices,faces] = read_vtk(MBM.plot.vtkFile);
vertices = vertices';
faces = faces';

% define figure model
fig = figure('Position', [200 200 1000 600], 'color', 'w');

% define axis para
factorX = 1.5;
factorY = 1.5;
initX = 0.01;
initY = 0.02;
nRow = 2;    %Number of rows
nCol = 3;    %Number of columns
lengthX = (0.85 - initX)/(factorX*(nCol-1) + 1);
lengthY = (0.95 - initY)/(factorY*(nRow-1) + 1);

%% plot statistical map

% restore removed vertices
statMapNoMask = zeros(size(MBM.maps.mask))';
statMapNoMask(MBM.maps.mask == 1) = MBM.stat.statMap;

% define axis
ax1 = axes('Position', [initX initY+factorY*lengthY lengthX lengthY]);
isCbar = true;
cbar = mbm_plot_map(ax1, vertices, faces, statMapNoMask, MBM.plot.hemis, isCbar);
cbar.Position = [ax1.Position(1)+ax1.Position(3)*1.05 ax1.Position(2)+ax1.Position(4)*0.2 0.01 ax1.Position(4)*0.6];

a1 = annotation(fig, 'textbox', [ax1.Position(1), ax1.Position(2)+ax1.Position(4)*1.02, ax1.Position(3), 0.02], 'string', 'statistical map', 'edgecolor', 'none', ...
    'FontName',fontName,'FontSize',fontSize,  'horizontalalignment', 'center');

%% plot thresholded map

% restore removed vertices
thresMapNoMask = zeros(size(MBM.maps.mask))';
thresMapNoMask(MBM.maps.mask==1) = MBM.stat.thresMap;

ax2 = axes('Position', [initX+lengthX*1.25  ax1.Position(2) lengthX lengthY]);
isCbar = false;
mbm_plot_map(ax2, vertices, faces, thresMapNoMask, MBM.plot.hemis, isCbar);
a2 = annotation(fig, 'textbox', [ax2.Position(1), ax2.Position(2)+ax2.Position(4)*1.02, ax2.Position(3), 0.02], 'string', ' thresholded map', 'edgecolor', 'none', ...
    'FontName',fontName,'FontSize',fontSize,  'horizontalalignment', 'center');

%% plot beta spectrum

ax3 = axes('Position', [ax2.Position(1)+ax2.Position(3)*1.3 ax1.Position(2) lengthX*2 lengthY*0.8],'FontName',fontName,'FontSize',fontSize);

bar(ax3,MBM.eig.beta,'FaceColor',lightGray,'EdgeColor',lightGray);
hold(ax3,'on');
bar(ax3,MBM.eig.significantBeta,'FaceColor',lightGreen,'EdgeColor',lightGreen);
hold(ax3, 'off')

xlabel(ax3, '\psi', 'FontName', fontName, 'FontSize', fontSize);
ylabel(ax3, '\beta', 'FontName', fontName, 'FontSize', fontSize);

legend('non-significant','significant','NumColumns',2)
legend('boxoff')

a3 = annotation(fig, 'textbox', [ax3.Position(1), a2.Position(2), ax3.Position(3), 0.02], 'string', '\beta spectrum', 'edgecolor', 'none', ...
    'FontName',fontName,'FontSize',fontSize, 'horizontalalignment', 'center');

%% plot significant pattern
% restore removed vertices
reconMapNoMask = zeros(size(MBM.maps.mask))';
reconMapNoMask(MBM.maps.mask==1) = MBM.eig.reconMap;

ax4 = axes('Position', [ax1.Position(1) initY ax1.Position(3) ax1.Position(4)],'FontName',fontName,'FontSize',fontSize);
isCbar = false;
mbm_plot_map(ax4, vertices, faces, reconMapNoMask, MBM.plot.hemis, isCbar);
a4 = annotation(fig, 'textbox', [ax4.Position(1), ax4.Position(2)+ax4.Position(4)*1.02, ax4.Position(3), 0.02], 'string', 'significant pattern', 'edgecolor', 'none', ...
    'FontName',fontName,'FontSize',fontSize,  'horizontalalignment', 'center');

%% plot the most influent pattern
% restore removed vertices
eigNoMask = zeros(size(MBM.maps.mask,2),MBM.plot.nInfluentialMode);
eigNoMask(MBM.maps.mask==1,:) = MBM.eig.eig(:,MBM.eig.betaOrder(1:MBM.plot.nInfluentialMode)).*sign(MBM.eig.beta(MBM.eig.betaOrder(1:MBM.plot.nInfluentialMode)));

% define axis para
factorX = 1.1;
factorY = 1.4;
initX = ax4.Position(1)+ax4.Position(3)*1.1;
nRow = 2;    %No of rows
nCol = ceil(MBM.plot.nInfluentialMode/2);    %No of columns
lengthX = (0.95 - initX)/(factorX*(nCol-1)+1);
lengthY = (0.4 - initY)/(factorY*(nRow-1)+1);

for iEig = 1:MBM.plot.nInfluentialMode % influent order of the modes

    i = ceil(iEig/nCol); % row index
    ii = mod(iEig+nCol-1,nCol)+1; % column index
    ax5 = axes('Position', [initX+factorX*lengthX*(ii-1) initY+factorY*lengthY*(nRow-i) lengthX lengthY],'FontName',fontName,'FontSize',fontSize);
    isCbar = false;
    mbm_plot_map(ax5, vertices, faces, eigNoMask(:,iEig), MBM.plot.hemis, isCbar);

    switch iEig
        case 1
            a5 = annotation(fig, 'textbox', [ax5.Position(1), ax5.Position(2)+ax5.Position(4)*1.2, ax5.Position(3), 0.02], 'string', [num2str(iEig), 'st'], 'edgecolor', 'none', ...
                'FontName',fontName,'FontSize',fontSize,  'horizontalalignment', 'center');
        case 2
            a5 = annotation(fig, 'textbox', [ax5.Position(1), ax5.Position(2)+ax5.Position(4)*1.2, ax5.Position(3), 0.02], 'string', [num2str(iEig), 'nd'], 'edgecolor', 'none', ...
                'FontName',fontName,'FontSize',fontSize,  'horizontalalignment', 'center');
        case 3
            a5 = annotation(fig, 'textbox', [ax5.Position(1), ax5.Position(2)+ax5.Position(4)*1.2, ax5.Position(3), 0.02], 'string', [num2str(iEig), 'rd'], 'edgecolor', 'none', ...
                'FontName',fontName,'FontSize',fontSize,  'horizontalalignment', 'center');
        otherwise
            a5 = annotation(fig, 'textbox', [ax5.Position(1), ax5.Position(2)+ax5.Position(4)*1.2, ax5.Position(3), 0.02], 'string', [num2str(iEig), 'th'], 'edgecolor', 'none', ...
                'FontName',fontName,'FontSize',fontSize,  'horizontalalignment', 'center');
    end
end

a6 = annotation(fig, 'textbox', [ax4.Position(1)+ax4.Position(3), initY+2.1*lengthY*factorY, lengthX*nCol*factorX, 0.02], 'string', 'most influential modes', 'edgecolor', 'none', ...
    'FontName',fontName,'FontSize',fontSize,  'horizontalalignment', 'center');

% save the result figure
if MBM.plot.saveFig == 1
    saveas(fig, MBM.plot.figFile)
end

end