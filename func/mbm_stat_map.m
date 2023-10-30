function statMap = mbm_stat_map(y,indicatorMatrix,test)
% Calculates a statistical map.
% 
%% Inputs:   
% y:                - measurement matrix (mxn), where n and m are the
%                   number of independent measurements and number of
%                   samples in each measurement, respectively.
%
% indicatorMatrix:  - Indicator matrix [m subjects by k groups].
%                   - '1' or '0' indicates a subject in a group or not.
%
% test:             - specifies the statistical test: 
%                   'one sample' is for one-sample t-test, 
%                   'two sample' is for two-sample t-test,
%                   'one way ANOVA' is for one-way ANOVA.
%
%% Outputs:   
% statMap:          - vector (1xn) of a statistical map.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

[nSub,nVertice] = size(y);

if nSub < 10
    warning('Number of subjects is small (<10). \n')
end

% glm statistical map
switch test
    
    case 'one sample'
        [h, p, ci, stats] = ttest(y(indicatorMatrix == 1));
        statMap = stats.tstat;
        
    case 'two sample'
        [h, p, ci, stats] = ttest2(y(indicatorMatrix(:,1) == 1,:), y(indicatorMatrix(:,2) == 1,:));
        statMap = stats.tstat;
        
    case 'one way ANOVA'
        
        % seperating measurement of each group
        yy = zeros(size(indicatorMatrix,1), size(y,2), size(indicatorMatrix,2)); % preallocation space
        for iCol = 1:size(indicatorMatrix,2)
            if iCol>1 & sum(indicatorMatrix(:,iCol-1) == 1) ~= sum(indicatorMatrix(:,iCol) == 1)
                error('Error. Numbers of subjects in each group are different.');
            else
                yy(:,:,iCol) = y(indicatorMatrix(:,iCol) == 1,:);
            end
        end
        
        % calculating the statistics
        statMap = zeros(1,nVertice);
        for iVertice = 1:nVertice
            [p, tbl, stats] = anova1(squeeze(yy(:,iVertice,:)), [], 'off');
            statMap(iVertice) = tbl{2,5};
        end
        
    case 'ANOCOVA'

        aoctool(x,y,group,alpha,xname,yname,gname,displayopt,model)
    otherwise
        disp('not supported test');
        
end

end