function statMap = mbm_stat_map(y,stat)
% Calculates a statistical map.
%
%% Inputs:
% y:                - measurement matrix (mxn), where n and m are the
%                   number of independent measurements and number of
%                   samples in each measurement, respectively.
%
% stat.indicatorMatrix:  - Indicator matrix [m subjects by k groups].
%                   - '1' or '0' indicates a subject in a group or not.
%
% stat.test:             - specifies the statistical test:
%                   'one sample' is for one-sample t-test,
%                   'two sample' is for two-sample t-test,
%                   'one way ANOVA' is for one-way ANOVA.
%
% varargin:         - array of indices of the column in the indicatorMatrix that are
%                   continuous when using ANCOVA
%
%
%% Outputs:
% statMap:          - vector (1xn) of a statistical map.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.


[nSub,nVertice] = size(y);

if nSub < 10
    warning('Number of subjects is small (<10). \n')
end

% glm statistical map
switch stat.test

    case 'one sample'
        [h, p, ci, stats] = ttest(y(stat.indicatorMatrix == 1));
        statMap = stats.tstat;

    case 'two sample'
        [h, p, ci, stats] = ttest2(y(stat.indicatorMatrix(:,1) == 1,:), y(stat.indicatorMatrix(:,2) == 1,:));
        statMap = stats.tstat;

    case 'one way ANOVA'

        % seperating measurement of each group
        yy = zeros(size(stat.indicatorMatrix,1), size(y,2), size(stat.indicatorMatrix,2)); % preallocation space
        for iCol = 1:size(stat.indicatorMatrix,2)
            if iCol>1 & sum(stat.indicatorMatrix(:,iCol-1) == 1) ~= sum(stat.indicatorMatrix(:,iCol) == 1)
                error('Error. Numbers of subjects in each group are different.');
            else
                yy(:,:,iCol) = y(stat.indicatorMatrix(:,iCol) == 1,:);
            end
        end

        % calculating the statistics
        statMap = zeros(1,nVertice);
        for iVertice = 1:nVertice
            [p, tbl, stats] = anova1(squeeze(yy(:,iVertice,:)), [], 'off');
            statMap(iVertice) = tbl{2,5};
        end

    case 'ANCOVA'
        
        % for iVertice = 1:nVertice
        % 
        %     % [p,t,stats,terms] = anovan(y(:,iVertice),stat.indicatorMatrix,'continuous',stat.continousCov,'display','off');
        %     % statMap(iVertice) = t{2,6};
        % end
            % similar to freesurfer
            matrixX = zeros(size(stat.indicatorMatrix,1), size(stat.indicatorMatrix,2)+1) ;
            matrixX(:,1) = double(stat.indicatorMatrix(:,1)==1);
            matrixX(:,2) = double(stat.indicatorMatrix(:,1)~=1);
            matrixX(:,3:end) = stat.indicatorMatrix(:,2:end);

            B = (matrixX'*matrixX)\(matrixX'*y);
            eres = y - matrixX*B;
            DOF = size(matrixX,1) - size(matrixX,2);
            rvar = sum(eres.^2,1)/DOF;
            C = [1 -1 zeros(1,size(matrixX,2)-2)];
            J = sum(C~=0,2)-1;
            G = C*B;

            statMap = (G.*inv(C*inv(matrixX'*matrixX) *C').*G)./(J*rvar);
      statMap(isnan(statMap)) = max(statMap(~isnan(statMap)))+1;
    otherwise
        disp('not supported test');

end

end