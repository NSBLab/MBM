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
%                       'ANCOVA_F': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%                       'ANCOVA_Z': first column: '1' or another number (e.g., '2'): group effect (similar to input file for mri_glmfit in freesurfer)
%                                                                     second to k-th columns: covariates (discrete or continous numbers)
%
%
% stat.test:             - specifies the statistical test:
%                   'one sample' is for one-sample t-test,
%                   'two sample' is for two-sample t-test,
%                   'one way ANOVA' is for one-way ANOVA.
%                   'ANCOVA_F' ANCOVA with two groups (f-test).
%                   'ANCOVA_Z' ANCOVA with two groups (z-test, producing z-map from FreeSurfer).
%
%
%% Outputs:
% statMap:          - vector (1xn) of a statistical map.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2024.


[nSub,nVertice] = size(y);

if nSub < 20
    warning('Number of subjects is small (<10). \n')
end

% glm statistical map
switch stat.test

    case 'one sample'

        [h, p, ci, stats] = ttest(y(stat.designMatrix == 1,:));
        statMap = stats.tstat;

    case 'two sample'

        [h, p, ci, stats] = ttest2(y(stat.designMatrix(:,1) == 1,:), y(stat.designMatrix(:,2) == 1,:));
        statMap = stats.tstat;
        statMap(isnan(statMap)) = 0; % mean is 0 and variance is 0, which mean the everyone in the two groups are identical.
    case 'one way ANOVA'

        % seperating measurement of each group
        yy = zeros(size(stat.designMatrix,1)/2, size(y,2), size(stat.designMatrix,2)); % preallocation space
        for iCol = 1:size(stat.designMatrix,2)

            yy(:,:,iCol) = y(stat.designMatrix(:,iCol) == 1,:);

        end

        % calculating the statistics
        statMap = zeros(1,nVertice);
        for iVertice = 1:nVertice
            [p, tbl, stats] = anova1(squeeze(yy(:,iVertice,:)), [], 'off');
            statMap(iVertice) = tbl{2,5};
        end
        statMap(isnan(statMap)) = 1; % mean is 0 and variance is 0, which mean the everyone in the two groups are identical.

    case 'ANCOVA_F'

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
        statMap(isnan(statMap)) = 1; % mean is 0 and variance is 0, which mean the everyone in the two groups are identical.

    case 'ANCOVA_Z'

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

        FMap = (G.*inv(C*inv(matrixX'*matrixX) *C').*G)./(J*rvar);
        FMap(isnan(FMap)) = 1; % mean is 0 and variance is 0, which mean the everyone in the two groups are identical.
        
        p = (1 - tcdf(sqrt(FMap), DOF))*2;
        z = norminv(1 - p/2);
        statMap = z.*sign(G);

    otherwise

        error('not supported test');

end

end