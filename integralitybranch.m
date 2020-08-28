function [B_lower,B_upper] = integralitybranch(B,xbar,n_nus)
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
%       B_lower, B_upper: (3xN)-cell arrays of same type like B

logic = find(abs(xbar-round(xbar))>10^(-5));
ind = logic(1);
[p_ind,p_i] = getPlayersIndex(ind,n_nus);
B_lower = B;
B_upper = B;
B_lower{3,p_ind}(p_i,2) = floor(xbar(ind));
B_upper{3,p_ind}(p_i,1) = ceil(xbar(ind));
end

