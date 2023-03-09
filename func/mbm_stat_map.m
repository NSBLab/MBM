function stat_map = mbm_stat_map(y,g,test)
% STAT_MAP = stat_map_cal(Y,G,TEST) calculates a statistical map.
% 
% Y: measurement matrix (mxn), where n and m are the number of independent
% measurements and number of samples in each measurement, respectively.
% G: contrast matrix (mxk) whose elements (value 1) indicate the sampling
% group. k is the number of groups.
% TEST: specifies the statistical test: 'one sample' is
% for one-sample t-test, 'two sample' is for two-sample t-test,
% 'one way ANOVA' is for one-way ANOVA.
%
% STAT_MAP: vector (1xn) of a statistical map.
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022

[N_sub,N_vertice] = size(y);

if N_sub < 10
    warning('Number of subjects is small (<10). \n')
end

% glm statistical map
switch test
    
    case 'one sample'
        [h,p,ci,stats] = ttest(y);
        stat_map = stats.tstat;
        
    case 'two sample'
        [h,p,ci,stats] = ttest2(y(g(:,1)==1,:),y(g(:,2)==1,:));
        stat_map = stats.tstat;
        
    case 'one way ANOVA'
        
        % seperating measurement of each group
        yy = zeros(size(g,1),size(y,2),size(g,2)); % preallocation space
        for i = 1:size(g,2)
            if i>1 & sum(g(:,i-1)==1) ~= sum(g(:,i)==1)
                error('Error. Numbers of subjects in each group are different.');
            else
                yy(:,:,i) = y(g(:,i)==1,:);
            end
        end
        
        stat_map = zeros(1,N_vertice);
        for ii = 1:N_vertice
            [p,tbl,stats] = anova1(squeeze(yy(:,ii,:)),[],'off');
            stat_map(ii) = tbl{2,5};
        end
        
    otherwise
        disp('not supported test');
        
end

end