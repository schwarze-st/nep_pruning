function [ind] = getFullIndex(p_nr,p_i,n_nus)
%Get full index, given playernumber and index of a players variable
%   Input:
%       p_nr    (int)
%       p_i     (int)
%       n_nus   (N x 1) vector
%   Output:
%       ind     (int)
ind = sum(n_nus(1:p_nr-1,1))+p_i;
end

