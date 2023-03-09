function r_phi = bin_corr_mat(data)
% R_PHI = bin_corr_mat(DATA) calculate the binnary correlation matrix.
% This code includes the case when there is no 0 (or no 1) in a column,
% which is not defined in the binary correlation from G. U. Yule, On the Methods
% of Measuring Association Between Two Attributes, Journal of the Royal
% Statistical Society 75 (6) (1912) 579-652.).
%
% DATA: the matrix whose columns are correlated.
%
% R_PHI: binary correlation matrix
%
% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022

[N_vertices N_f] = size(data); % number of columns/sites

r_phi = zeros(N_f, N_f); % preallocation space
for ii=1:N_f
    for j=1:N_f
        m00=sum((data(:,ii)==0)&(data(:,j)==0));
        m01=sum((data(:,ii)==0)&(data(:,j)==1));
        m10=sum((data(:,ii)==1)&(data(:,j)==0));
        m11=sum((data(:,ii)==1)&(data(:,j)==1));
        mx0=m00+m10;
        mx1=m01+m11;
        m0x=m00+m01;
        m1x=m10+m11;
        r_phi(ii,j)=(m11*m00-m10*m01)/sqrt(m1x*m0x*mx0*mx1);
        if m1x==0
            r_phi(ii,j)=(m00-m01)/N_vertices;
        else if m0x==0
                r_phi(ii,j)=(m11-m10)/N_vertices;
            else if mx1==0
                    r_phi(ii,j)=(m00-m10)/N_vertices;
                else if mx0==0
                        r_phi(ii,j)=(m11-m01)/N_vertices;
                    end
                end
            end
        end
        
    end
end