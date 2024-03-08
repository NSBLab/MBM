function statMap = mbm_stat_map(y,stat)
% Calculates a statistical map.
%
%% Inputs:
% y:                - measurement matrix (mxn), where n and m are the
%                   number of independent measurements and number of
%                   samples in each measurement, respectively.
%
% stat.designMatrix:  - Design matrix [m subjects by k effects].
%                     - For the design matrix in the statistical test:
%                       'one sample': one column, '1' or '0' indicates a subject in the group or not.
%                       'two sample': two columns, '1' or '0' indicates a subject in a group or not.
%                       'one way ANOVA': k columns, '1' or '0' indicates a subject in a group or not, number of subjects in each group must be equal.
%                       'ANCOVA': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%
%
% stat.test:             - specifies the statistical test:
%                   'one sample' is for one-sample t-test,
%                   'two sample' is for two-sample t-test,
%                   'one way ANOVA' is for one-way ANOVA.
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
        if size(stat.designMatrix,2) ~= 1

            error('Design matrix for one sample t-test must have one column');

        end
        [h, p, ci, stats] = ttest(y(stat.designMatrix == 1,:));
        statMap = stats.tstat;

    case 'two sample'
        if size(stat.designMatrix,2) ~= 2

            % uialert(fig, 'Design matrix for two sample t-test must have two columns', 'err');
            % uiwait(fig)
            error('Design matrix for two sample t-test must have two columns');

        end
        [h, p, ci, stats] = ttest2(y(stat.designMatrix(:,1) == 1,:), y(stat.designMatrix(:,2) == 1,:));
        statMap = stats.tstat;

    case 'one way ANOVA'

        % seperating measurement of each group
        yy = zeros(size(stat.designMatrix,1), size(y,2), size(stat.designMatrix,2)); % preallocation space
        for iCol = 1:size(stat.designMatrix,2)

            if iCol>1 & sum(stat.designMatrix(:,iCol-1) == 1) ~= sum(stat.designMatrix(:,iCol) == 1)
                % uialert(fig, 'Numbers of subjects in each group are different.', 'err');
                % uiwait(fig)
                error('Numbers of subjects in each group are different.');
            end

            yy(:,:,iCol) = y(stat.designMatrix(:,iCol) == 1,:);

        end

        % calculating the statistics
        statMap = zeros(1,nVertice);
        for iVertice = 1:nVertice
            [p, tbl, stats] = anova1(squeeze(yy(:,iVertice,:)), [], 'off');
            statMap(iVertice) = tbl{2,5};
        end

    case 'ANCOVA'

        matrixX = zeros(size(stat.designMatrix,1), size(stat.designMatrix,2)+1) ;
        matrixX(:,1) = double(stat.designMatrix(:,1)==1);
        matrixX(:,2) = double(stat.designMatrix(:,1)~=1);
        matrixX(:,3:end) = stat.designMatrix(:,2:end);

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
        uialert(fig, 'not supported test', 'err');
        uiwait(fig)
        error('not supported test');

end

end