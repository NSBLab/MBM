function [varargout] = mbm_plot(MBM)
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

% check input
dumbar = 1; % to use in while in order to use break
while dumbar
    if isfield(MBM.plot, 'vtkFile') == 0 | strcmp(MBM.plot.vtkFile,fullfile(0,0))

        msgbox('No Surface');

        errReturn = true;
        varargout{1} = errReturn;
        break


    else

        % Define constants
        lightGray = [0.5 0.5 0.5]; % define color
        lightGreen = [0.35 0.65 0.35]; % define color
        fontName = 'Arial'; % font for labels
        fontSize = 15;

        % read surface
        switch MBM.plot.vtkFile(end-3:end)
            case '.mat'
                st = load(MBM.plot.vtkFile);
                vertices = st.vertices; 
                faces = st.faces;
            case '.vtk'
                [vertices,faces] = read_vtk(MBM.plot.vtkFile);
                vertices = vertices';
                faces = faces';
        end

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
        ax1.Title.String = 'statistical map';

        %% plot thresholded map

        % restore removed vertices
        thresMapNoMask = zeros(size(MBM.maps.mask))';
        thresMapNoMask(MBM.maps.mask==1) = MBM.stat.thresMap;

        ax2 = axes('Position', [initX+lengthX*1.25  ax1.Position(2) lengthX lengthY]);
        isCbar = false;
        mbm_plot_map(ax2, vertices, faces, thresMapNoMask, MBM.plot.hemis, isCbar);
        ax2.Title.String = ['thresholded map, p\leq',num2str(MBM.stat.thres)];

        %% plot beta spectrum

        ax3 = axes('Position', [ax2.Position(1)+ax2.Position(3)*1.3 ax1.Position(2) lengthX*2 lengthY*0.8],'FontName',fontName,'FontSize',fontSize);

        bar(ax3,MBM.eig.beta,'FaceColor',lightGray,'EdgeColor',lightGray);
        hold(ax3,'on');
        bar(ax3,MBM.eig.significantBeta,'FaceColor',lightGreen,'EdgeColor',lightGreen);
        hold(ax3, 'off')

        xlabel(ax3, '\psi', 'FontName', fontName, 'FontSize', fontSize);
        ylabel(ax3, '\beta', 'FontName', fontName, 'FontSize', fontSize);

        le = legend('non-significant',['significant, p\leq', num2str(MBM.stat.thres)],'NumColumns',2);
        le.Location = 'best';
        legend('boxoff');

        ax3.Title.String = '\beta spectrum';

        %% plot significant pattern
        % restore removed vertices
        reconMapNoMask = zeros(size(MBM.maps.mask))';
        reconMapNoMask(MBM.maps.mask==1) = MBM.eig.reconMap;

        ax4 = axes('Position', [ax1.Position(1) initY ax1.Position(3) ax1.Position(4)]);
        isCbar = false;
        mbm_plot_map(ax4, vertices, faces, reconMapNoMask, MBM.plot.hemis, isCbar);
        ax4.Title.String = 'significant pattern';

        %% plot the most influent pattern
        % restore removed vertices
        eigNoMask = zeros(size(MBM.maps.mask,2),MBM.plot.nInfluentialMode);
        eigNoMask(MBM.maps.mask==1,:) = MBM.eig.eig(:,MBM.eig.betaOrder(1:MBM.plot.nInfluentialMode)).*sign(MBM.eig.beta(MBM.eig.betaOrder(1:MBM.plot.nInfluentialMode)));

        % define axis para
        factorX = 1.1;
        factorY = 1.4;
        initX = ax4.Position(1)+ax4.Position(3)*1.1;
        nRow = floor(sqrt(MBM.plot.nInfluentialMode));    %No of rows
        nCol = ceil(MBM.plot.nInfluentialMode/nRow);    %No of columns
        lengthX = (0.95 - initX)/(factorX*(nCol-1)+1);
        lengthY = (0.4 - initY)/(factorY*(nRow-1)+1);

        for iEig = 1:MBM.plot.nInfluentialMode % influent order of the modes

            i = ceil(iEig/nCol); % row index
            ii = mod(iEig+nCol-1,nCol)+1; % column index
            ax5 = axes('Position', [initX+factorX*lengthX*(ii-1) initY+factorY*lengthY*(nRow-i) lengthX lengthY]);
            isCbar = false;
            mbm_plot_map(ax5, vertices, faces, eigNoMask(:,iEig), MBM.plot.hemis, isCbar);

            switch iEig
                case 1
                    if (i==1 & ii == floor((nCol+1)/2))
                        ax5.Title.String = {'most influential modes', [num2str(iEig), 'st-mode ', num2str(MBM.eig.betaOrder(iEig))]};
                    else
                        ax5.Title.String = [num2str(iEig), 'st-mode ', num2str(MBM.eig.betaOrder(iEig))];
                    end

                case 2
                    if (i==1 & ii == floor((nCol+1)/2))
                        ax5.Title.String = {'most influential modes', [num2str(iEig), 'nd-mode ', num2str(MBM.eig.betaOrder(iEig))]};
                    else
                        ax5.Title.String = [num2str(iEig), 'nd-mode ', num2str(MBM.eig.betaOrder(iEig))];
                    end
                case 3
                    if i==1 & ii == floor((nCol+1)/2)
                        ax5.Title.String = {'most influential modes', [num2str(iEig), 'rd-mode ', num2str(MBM.eig.betaOrder(iEig))]};
                    else
                        ax5.Title.String = [num2str(iEig), 'rd-mode ', num2str(MBM.eig.betaOrder(iEig))];
                    end
                otherwise
                    if i==1 & ii == floor((nCol+1)/2)
                        ax5.Title.String = ['most influential modes \n', num2str(iEig), 'th-mode ', num2str(MBM.eig.betaOrder(iEig))];
                    else
                        ax5.Title.String = [num2str(iEig), 'th-mode ', num2str(MBM.eig.betaOrder(iEig))];
                    end
            end

        end

        % save the result figure
        if MBM.plot.saveFig == 1
            saveas(fig, MBM.plot.figFile);
        end

        varargout{1} = fig;
        dumbar = 0;
    end
end
end