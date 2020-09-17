function B_int = integralitybranch(B,xbar,n_nus)
% Create a partition in two sets, such that one component in xbar) is
% driven to integer values
%   Input:
%       B: (3xN)-cell array
%           B(1,nu): A^nu (m_nu x n_nu) Matrix
%           B(2,nu): b^nu (m_nu x 1) Vector
%           B(3,nu): bnd^nu (n_nu x 2) Matrix
%       xbar (n x 1) Vector
%       n_nus (N x 1) Vector
%   Output
%       B_int (1x1) or (1x2) cell-array containing nonempty strategy subsets       

B_int = cell(1,2);

ind = find(abs(xbar-round(xbar))>10^(-5),1);
[p_ind,p_i] = getPlayersIndex(ind,n_nus);
B_lower = B;
B_upper = B;
B_lower{3,p_ind}(p_i,2) = floor(xbar(ind));
if ~setempty(B_lower,n_nus)
    B_int{1} = B_lower;
end
B_upper{3,p_ind}(p_i,1) = ceil(xbar(ind));
if ~setempty(B_upper,n_nus)
    B_int{2} = B_upper;
end

