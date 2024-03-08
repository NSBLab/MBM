function r_phi = bin_corr_mat(data)
% Calculate the binnary correlation matrix.
%
% This code includes the case when there is no 0 (or no 1) in a column,
% which is not defined for the binary correlation in U. Yule, On the Methods
% of Measuring Association Between Two Attributes, Journal of the Royal
% Statistical Society 75 (6) (1912) 579-652.).
%
%% Input:
% data      - the matrix whose columns are correlated.
%
%% Output:
% r_phi     - binary correlation matrix.

% Trang Cao, Neural Systems and Behaviour Lab, Monash University, 2022.

[nVertice nSite] = size(data); % number of columns/sites

r_phi = zeros(nSite, nSite); % preallocation space
for iLoop1 = 1:nSite
    for iLoop2 = 1:nSite 
        
        m00 = sum((data(:,iLoop1)==0) & (data(:,iLoop2)==0));
        m01 = sum((data(:,iLoop1)==0) & (data(:,iLoop2)==1));
        m10 = sum((data(:,iLoop1)==1) & (data(:,iLoop2)==0));
        m11 = sum((data(:,iLoop1)==1) & (data(:,iLoop2)==1));
        mx0 = m00 + m10;
        mx1 = m01 + m11;
        m0x = m00 + m01;
        m1x = m10 + m11;
        r_phi(iLoop1,iLoop2) = (m11*m00 - m10*m01)/sqrt(m1x*m0x*mx0*mx1);
        
        if m1x==0
            r_phi(iLoop1,iLoop2) = (m00-m01)/nVertice;
        else if m0x==0
                r_phi(iLoop1,iLoop2) = (m11-m10)/nVertice;
            else if mx1==0
                    r_phi(iLoop1,iLoop2) = (m00-m10)/nVertice;
                else if mx0==0
                        r_phi(iLoop1,iLoop2) = (m11-m01)/nVertice;
                    end
                end
            end
        end    
        
    end
end